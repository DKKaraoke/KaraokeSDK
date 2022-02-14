//
//  RequestType.swift
//
//
//  Created by devonly on 2021/12/24.
//

import Foundation
import Combine
import Alamofire
import Kanna
import KeychainAccess
import UIKit

open class DKKaraoke {
    public weak var delegate: AFSesseionProgressDelegate? = nil
    /// シングルトン
    public static let shared: DKKaraoke = DKKaraoke()
    /// 接続用の認証情報
    public internal(set) var credential: OAuthCredential? {
        get {
            guard let data = try? keychain.getData("CREDENTIAL"),
                  let credential = try? decoder.decode(OAuthCredential.self, from: data)
            else {
                return nil
            }
            return credential
        }
        set {
            guard let newValue = newValue,
                  let data = try? encoder.encode(newValue)
            else {
                try? keychain.remove("CREDENTIAL")
                return
            }
            try? keychain.set(data, key: "CREDENTIAL")
        }
    }
    /// タスク管理
    var task = Set<AnyCancellable>()
    /// JSONDecoder
    let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    /// JSONEncoder
    let encoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        return encoder
    }()
    
    /// Keychainデータ
    private let keychain: Keychain = Keychain(service: Bundle.main.bundleIdentifier!)
    /// イニシャライザ
    private init() {}
    
    internal let session: Alamofire.Session = {
        let session = Alamofire.Session()
        session.sessionConfiguration.timeoutIntervalForRequest = 5
        session.sessionConfiguration.httpMaximumConnectionsPerHost = 1
        return session
    }()
    
    public var contentsKinds: [DKContent] {
        switch credential?.deviceType {
            case .xg8000:
                return [.設定しない, .精密採点DXG, .精密採点AI, .ランキングバトル]
            case .xg7000:
                return [.設定しない, .精密採点DXG, .ランキングバトル]
            case .xg5000:
                return [.設定しない, .精密採点DX, .ランキングバトル]
            case .unknown:
                return []
            case .none:
                return []
        }
    }
    
    /// スクレイピング用のコード
    internal func parseToHTML(data: Data, encoding: String.Encoding) -> HTMLDocument? {
        guard let html = String(data: data, encoding: encoding),
              let document = try? HTML(html: html, encoding: encoding)
        else {
            return nil
        }
        return document
    }
    
    /// FistiaAPIから点数速報データを取得
    public func getPredictionsDKRanbato(timeLimit: Int, since: Date = Date(), includeNormal: Bool) -> AnyPublisher<Fistia.Prediction.Response, DKError> {
        let isLiveDamStadium: Bool = {
            if let credential = credential {
                return credential.deviceType == .xg7000
            }
            return false
        }()
        let request = Fistia.Prediction(startTime: since, timeLimit: timeLimit, includeNormal: includeNormal, isLiveDamStadium: isLiveDamStadium)
        return publish(request)
    }
    
    /// FistiaAPIから点数速報データを取得
    public func getScorePredictionCount(timeSpan: Int = 1800, timeLimit: Int = 86400, since: Date = Date()) -> AnyPublisher<Fistia.PredictionCount.Response, DKError> {
        // 区切りが良い時間に修正するコード
        let currentTime = (Int(Date().timeIntervalSince1970) / timeSpan) * timeSpan
        let startTime = Date(timeIntervalSince1970: TimeInterval(currentTime))
        let request = Fistia.PredictionCount(startTime: startTime, timeSpan: timeSpan, timeLimit: timeLimit)
        return publish(request)
    }
    
    /// ランキングデータ取得
    public func ranking(requestNo: Int) -> AnyPublisher<[Ranking.Response], DKError> {
        let request = Ranking(requestNo: requestNo)
        return session.request(request)
            .validate()
            .validate(contentType: ["text/html"])
            .cURLDescription { request in
#if DEBUG
                print(request)
#endif
            }
            .publishData()
            .value()
            .tryMap({ response throws -> [Ranking.Response] in
                guard let html = self.parseToHTML(data: response, encoding: .shiftJIS) else {
                    throw DKError.responseDataCorrupted
                }
                let users = html.xpath("//*[@id=\"Rankingbattle\"]/table[2]/tr[not(@style=\"background:#DFF1FD\")]")
                let ranking = users.compactMap({ Ranking.Response(document: $0) })
                return ranking
            })
            .mapToDKError()
            .eraseToAnyPublisher()
    }
    
    /// 認証用のリクエスト
    internal func authorize(_ request: Connect) -> AnyPublisher<Connect.Response, DKError> {
        session.request(request)
            .validateWithFuckingDKFormat()
            .validate(contentType: ["application/json"])
            .cURLDescription { request in
#if DEBUG
                print(request)
#endif
            }
            .publishDecodable(type: Connect.Response.self, decoder: decoder)
            .value()
            .mapToDKError()
            .handleEvents(receiveSubscription: { _ in
                self.delegate?.sessionIsRunning()
            }, receiveOutput: { response in
                /// 認証情報を作成してKeychainに保存
                let credential: OAuthCredential = OAuthCredential(response: response)
                self.credential = credential
            }, receiveCompletion: { completion in
                self.delegate?.sessionIsTerminated()
            })
            .eraseToAnyPublisher()
    }
    
    public func publish<T: RequestType>(_ request: T) -> AnyPublisher<T.ResponseType, DKError> {
        let interceptor: AuthenticationInterceptor<DKKaraoke>? = {
            switch request {
                case is Login, is Search, is Detail:
                    return nil
                default:
                    break
            }
            guard let credential = credential else {
                return nil
            }
            return AuthenticationInterceptor(authenticator: self, credential: credential)
        }()
        
        return session.request(request, interceptor: interceptor)
            .validateWithFuckingDKFormat()
            .validate(contentType: ["application/json"])
            .cURLDescription { request in
#if DEBUG
                print(request)
#endif
            }
            .publishDecodable(type: T.ResponseType.self, decoder: decoder)
            .value()
            .mapToDKError()
            .handleEvents(receiveSubscription: { _ in
                self.delegate?.sessionIsRunning()
            }, receiveCompletion: { _ in
                self.delegate?.sessionIsTerminated()
            })
            .eraseToAnyPublisher()
    }
    
    /// リザルト取得
    public func getDKRanbatoResults(cdmNo: String) -> AnyPublisher<Ranbato.Response, DKError> {
        let request = Ranbato(cdmNo: cdmNo)
        return publish(request)
    }
    
    /// ペアリング
    public func connect(qrCode: String, cdmNo: String? = nil) -> AnyPublisher<Connect.Response, DKError> {
        do {
            // 常に最新のQRに変換する
            let qrCode: String = try QRCode(code: qrCode).code
            let request = Connect(qrCode: qrCode, cdmNo: cdmNo)
            return authorize(request)
        } catch {
            return Fail(outputType: Connect.Response.self, failure: DKError.qrCodeGenerationFailed)
                .eraseToAnyPublisher()
        }
    }
    
    /// ペアリングを延長する
    public func update() -> AnyPublisher<Connect.Response, DKError> {
        guard let credential = credential else {
            return Fail(outputType: Connect.Response.self, failure: DKError.authenticationFailed)
                .eraseToAnyPublisher()
        }
        return self.connect(qrCode: credential.code, cdmNo: credential.cdmNo)
    }
    
    /// ペアリング解除
    public func disconnect() -> AnyPublisher<Disconnect.Response, DKError> {
        let request = Disconnect()
        return publish(request)
            .handleEvents(receiveCompletion: { completion in
                self.credential = nil
            })
            .eraseToAnyPublisher()
    }
    
    /// サインイン
    public func signIn(damtomoId: String, password: String) -> AnyPublisher<Login.Response, DKError> {
        let request = Login(damtomoId: damtomoId, password: password)
        return publish(request)
    }
    
    /// 楽曲予約
    public func request(requestNo: Int, myKey: Int, contentsKind: DKContent = .設定しない) -> AnyPublisher<Request.Response, DKError> {
        let request = Request(reqNo: requestNo, myKey: myKey, contentsKind: contentsKind)
        return publish(request)
    }
    
    /// コマンド送信
    public func command(command: DKCommand) -> AnyPublisher<Command.Response, DKError> {
        let request = Command(command: command)
        return publish(request)
    }
    
    /// 画像送信
    public func sendPicture(image: UIImage?, quality: CGFloat = 1.0, size: CGSize = CGSize(width: 1920, height: 1080), backgroundColor: UIColor = .black) -> AnyPublisher<Picture.Response, DKError> {
        let request = Picture(image: image, quality: quality, size: size, backgroundColor: backgroundColor)
        return publish(request)
    }
    
    /// 楽曲検索
    public func searchByKeyword(keyword: String, mode: Search.Mode) -> AnyPublisher<Search.Response, DKError> {
        let request = Search(keyword: keyword, mode: mode)
        return publish(request)
    }
    
    /// 楽曲詳細情報取得
    public func getSongDetail(requestNo: String) -> AnyPublisher<Detail.Response, DKError> {
        // シリアルを作成
        let serialNo: String = {
            if let credential = credential {
                return credential.serial
            }
            return "AT00001"
        }()
        let request = Detail(requestNo: requestNo, serialNo: serialNo)
        return publish(request)
    }
    
    /// アルバム画像取得
    public func search(songName: String, artistName: String) -> AnyPublisher<URL, DKError> {
        let searchText: String = {
            if artistName.count <= 10 {
                return "\(songName.normalizedText)+\(artistName)"
            }
            return songName.normalizedText
        }()
        let request = Amazon.Image(searchText: searchText)
        return session.request(request)
            .validate()
            .validate(contentType: ["text/html"])
            .cURLDescription { request in
#if DEBUG
                print(request)
#endif
            }
            .publishData()
            .value()
            .tryMap({ response throws -> URL in
                guard let html: String = String(data: response, encoding: .utf8),
                      let mediaURL: String = try? html.matching(pattern: "https://m.media-amazon.com/images/I/([\\S]*654_QL65_).jpg").first,
                      let imageURL: URL = URL(string: mediaURL)
                else {
                    throw DKError.couldNotFouneResoureFailed
                }
                return imageURL
            })
            .mapToDKError()
            .eraseToAnyPublisher()
    }
}

extension String {
    var normalizedText: String {
        self.replacingOccurrences(of: "\\([^\\)]+\\)|\\[[^\\]]+\\]", with: "", options: .regularExpression)
    }
}

extension Publisher {
    func mapToDKError() -> Publishers.MapError<Self, DKError> {
        mapError({ error -> DKError in
            guard let error = error as? DKError else {
                return DKError.unknownErrorFailed
            }
            return error
        })
    }
}
