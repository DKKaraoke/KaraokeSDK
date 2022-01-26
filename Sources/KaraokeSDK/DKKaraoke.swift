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
    public internal(set) var credential: Credential? {
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
    /// キュー
    let queue: DispatchSemaphore = DispatchSemaphore(value: 1)
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
    
    /// スクレイピング用のコード
    internal func parseToHTML(data: Data) -> [Ranking.Response] {
        guard let html = String(data: data, encoding: .shiftJIS),
              let document = try? HTML(html: html, encoding: .shiftJIS)
        else {
            return []
        }
        let users = document.xpath("//*[@id=\"Rankingbattle\"]/table[2]/tr[not(@style=\"background:#DFF1FD\")]")
        return users.compactMap({ Ranking.Response(document: $0) })
    }
    
    /// FistiaAPIから点数速報データを取得
    public func getPredictionsDKRanbato(timeLimit: Int, since: Date = Date(), includeNormal: Bool) -> AnyPublisher<Fistia.Prediction.Response, AFError> {
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
    public func getScorePredictionCount(timeSpan: Int = 1800, timeLimit: Int = 86400, since: Date = Date()) -> AnyPublisher<Fistia.PredictionCount.Response, AFError> {
        // 区切りが良い時間に修正するコード
        let currentTime = (Int(Date().timeIntervalSince1970) / timeSpan) * timeSpan
        let startTime = Date(timeIntervalSince1970: TimeInterval(currentTime))
        let request = Fistia.PredictionCount(startTime: startTime, timeSpan: timeSpan, timeLimit: timeLimit)
        return publish(request)
    }
    
    /// ランキングデータ取得
    public func ranking(requestNo: Int) -> AnyPublisher<[Ranking.Response], AFError> {
        let request = Ranking(requestNo: requestNo)
        return Future { promise in
            self.session.request(request)
                .validate()
                .validate(contentType: ["text/html"])
                .cURLDescription { request in
                    print(request)
                }
                .publishData()
                .value()
                .sink(receiveCompletion: { completion in
                    print(completion)
                }, receiveValue: { response in
                    promise(.success(self.parseToHTML(data: response)))
                })
                .store(in: &self.task)
        }
        .eraseToAnyPublisher()
    }
    
    /// 認証用のリクエスト
    internal func authorize(_ request: Connect) -> AnyPublisher<Connect.Response, AFError> {
        session.request(request)
            .validateWithFuckingDKFormat()
            .validate(contentType: ["application/json"])
            .cURLDescription { request in
                print(request)
            }
            .publishDecodable(type: Connect.Response.self, decoder: decoder)
            .value()
            .handleEvents(receiveSubscription: { _ in
                self.delegate?.sessionIsRunning()
            }, receiveOutput: { response in
                /// 認証情報を作成してKeychainに保存
                let credential: OAuthCredential = OAuthCredential(response: response)
                self.credential = credential
            }, receiveCompletion: { _ in
                self.delegate?.sessionIsTerminated()
            })
            .handleEvents(receiveOutput: { response in
            })
            .eraseToAnyPublisher()
    }
    
    internal func publish(_ request: Login) -> AnyPublisher<Login.Response, AFError> {
        session.request(request)
            .validateWithFuckingDKFormat()
            .validate(contentType: ["application/json"])
            .cURLDescription { request in
                print(request)
            }
            .publishDecodable(type: Login.Response.self, decoder: decoder)
            .value()
            .handleEvents(receiveSubscription: { _ in
                self.delegate?.sessionIsRunning()
            }, receiveCompletion: { _ in
                self.delegate?.sessionIsTerminated()
            })
            .eraseToAnyPublisher()
    }
    
    internal func publish(_ request: Search) -> AnyPublisher<Search.Response, AFError> {
        session.request(request)
            .validateWithFuckingDKFormat()
            .validate(contentType: ["application/json"])
            .cURLDescription { request in
                print(request)
            }
            .publishDecodable(type: Search.Response.self, decoder: decoder)
            .value()
            .handleEvents(receiveSubscription: { _ in
                self.delegate?.sessionIsRunning()
            }, receiveCompletion: { _ in
                self.delegate?.sessionIsTerminated()
            })
            .eraseToAnyPublisher()
    }
    
    internal func publish(_ request: Detail) -> AnyPublisher<Detail.Response, AFError> {
        return session.request(request)
            .validateWithFuckingDKFormat()
            .validate(contentType: ["application/json"])
            .cURLDescription { request in
                print(request)
            }
            .publishDecodable(type: Detail.Response.self, decoder: JSONDecoder())
            .value()
            .handleEvents(receiveSubscription: { _ in
                self.delegate?.sessionIsRunning()
            }, receiveCompletion: { _ in
                self.delegate?.sessionIsTerminated()
            })
            .eraseToAnyPublisher()
    }
    
    internal func publish(_ request: Fistia.Prediction) -> AnyPublisher<Fistia.Prediction.Response, AFError> {
        session.request(request)
            .validateWithFuckingDKFormat()
            .validate(contentType: ["application/json"])
            .cURLDescription { request in
                print(request)
            }
            .publishDecodable(type: Fistia.Prediction.Response.self, decoder: JSONDecoder())
            .value()
            .handleEvents(receiveSubscription: { _ in
                self.delegate?.sessionIsRunning()
            }, receiveCompletion: { _ in
                self.delegate?.sessionIsTerminated()
            })
            .eraseToAnyPublisher()
    }
    
    internal func publish(_ request: Fistia.PredictionCount) -> AnyPublisher<Fistia.PredictionCount.Response, AFError> {
        session.request(request)
            .validateWithFuckingDKFormat()
            .validate(contentType: ["application/json"])
            .cURLDescription { request in
                print(request)
            }
            .publishDecodable(type: Fistia.PredictionCount.Response.self, decoder: JSONDecoder())
            .value()
            .handleEvents(receiveSubscription: { _ in
                self.delegate?.sessionIsRunning()
            }, receiveCompletion: { _ in
                self.delegate?.sessionIsTerminated()
            })
            .eraseToAnyPublisher()
    }
    
    /// リクエスト送信
    internal func publish<T: RequestType>(_ request: T) -> AnyPublisher<T.ResponseType, AFError> {
        guard let credential = credential else {
            return Fail(outputType: T.ResponseType.self, failure: AFError.requestAdaptationFailed(error: DKError.authenticationError))
                .eraseToAnyPublisher()
        }
        
        let interceptor = AuthenticationInterceptor(authenticator: self, credential: credential)
        return session.request(request, interceptor: interceptor)
            .validateWithFuckingDKFormat()
            .validate(contentType: ["application/json"])
            .cURLDescription { request in
                print(request)
            }
            .publishDecodable(type: T.ResponseType.self, decoder: decoder)
            .value()
            .handleEvents(receiveSubscription: { _ in
                self.delegate?.sessionIsRunning()
            }, receiveCompletion: { _ in
                self.delegate?.sessionIsTerminated()
            })
            .eraseToAnyPublisher()
    }
    
    /// リザルト取得
    public func getDKRanbatoResults(cdmNo: String) -> AnyPublisher<Ranbato.Response, AFError> {
        let request = Ranbato(cdmNo: cdmNo)
        return publish(request)
    }
    
    /// ペアリング
    public func connect(qrCode: String, cdmNo: String? = nil) -> AnyPublisher<Connect.Response, AFError> {
        do {
            // 常に最新のQRに変換する
            let qrCode: String = try QRCode(code: qrCode).code
            let request = Connect(qrCode: qrCode, cdmNo: cdmNo)
            return authorize(request)
        } catch (let error) {
            return Fail(outputType: Connect.Response.self, failure: AFError.createURLRequestFailed(error: error))
                .eraseToAnyPublisher()
        }
    }
    
    /// ペアリングを延長する
    public func update() -> AnyPublisher<Connect.Response, AFError> {
        guard let credential = credential else {
            return Fail(outputType: Connect.Response.self, failure: AFError.createURLRequestFailed(error: DKError.authenticationError))
                .eraseToAnyPublisher()
        }
        return self.connect(qrCode: credential.code, cdmNo: credential.cdmNo)
    }
    
    /// ペアリング解除
    public func disconnect() -> AnyPublisher<Disconnect.Response, AFError> {
        let request = Disconnect()
        return publish(request)
            .handleEvents(receiveCompletion: { completion in
                self.credential = nil
            })
            .eraseToAnyPublisher()
    }
    
    /// サインイン
    public func signIn(damtomoId: String, password: String) -> AnyPublisher<Login.Response, AFError> {
        let request = Login(damtomoId: damtomoId, password: password)
        return publish(request)
    }
    
    /// 楽曲予約
    public func request(requestNo: Int, myKey: Int) -> AnyPublisher<Request.Response, AFError> {
        let request = Request(reqNo: requestNo, myKey: myKey)
        return publish(request)
    }
    
    /// コマンド送信
    public func command(command: DKCommand) -> AnyPublisher<Command.Response, AFError> {
        let request = Command(command: command)
        return publish(request)
    }
    
    /// 画像送信
    public func sendPicture(image: UIImage) -> AnyPublisher<Picture.Response, AFError> {
        let request = Picture(image: image)
        return publish(request)
    }
    
    /// 楽曲検索
    public func searchByKeyword(keyword: String, mode: Search.Mode) -> AnyPublisher<Search.Response, AFError> {
        let request = Search(keyword: keyword, mode: mode)
        return publish(request)
    }
    
    /// 楽曲詳細情報取得
    public func getSongDetail(requestNo: String) -> AnyPublisher<Detail.Response, AFError> {
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
}
