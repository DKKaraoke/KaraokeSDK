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
        session.sessionConfiguration.timeoutIntervalForRequest = 10
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
    public func getPredictionsDKRanbato(timeLimit: Int, since: Date = Date(), includeNormal: Bool) -> AnyPublisher<Fistia.Response, AFError> {
        let isLiveDamStadium: Bool = {
            if let credential = credential {
                return credential.deviceType == .xg7000
            }
            return false 
        }()
        let request = Fistia(startTime: since, timeLimit: timeLimit, includeNormal: includeNormal, isLiveDamStadium: isLiveDamStadium)
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
            .handleEvents(receiveOutput: { response in
                /// 認証情報を作成してKeychainに保存
                let credential: OAuthCredential = OAuthCredential(response: response)
                self.credential = credential
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
    public func request(reqNo: String, myKey: Int) -> AnyPublisher<Request.Response, AFError> {
        let request = Request(reqNo: reqNo, myKey: myKey)
        return publish(request)
    }
    
    /// コマンド送信
    public func command(command: DKCommand) -> AnyPublisher<Command.Response, AFError> {
        let request = Command(command: command)
        return publish(request)
    }
    
    /// 画像送信
    public func sendPicture(image: UIImage, sendType: Picture.SendType) -> AnyPublisher<Picture.Response, AFError> {
        let request = Picture(image: image, sendType: sendType)
        return publish(request)
    }
}
