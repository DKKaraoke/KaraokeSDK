//
//  RequestType.swift
//
//
//  Created by devonly on 2021/12/24.
//

import Foundation
import Combine
import Alamofire

public class DKKaraoke {
    /// シングルトン
    public static let shared: DKKaraoke = DKKaraoke()
    /// 接続用のQRコード
    static var qrCode: String?
    /// 固有ID
    static var cdmNo: String?
    /// タスク管理
    static var task = Set<AnyCancellable>()
    /// キュー
    let queue: DispatchSemaphore = DispatchSemaphore(value: 1)
    /// JSONDecoder
    static let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()
    
    /// リクエスト送信
    internal static func publish<T: RequestType>(_ request: T) -> AnyPublisher<T.ResponseType, AFError> {
        do {
            guard let cdmNo = cdmNo, let qrCode = qrCode else {
                throw NSError(domain: "No cdmNo or qrCode", code: 401, userInfo: nil)
            }
            let request = try request.asURLRequest(cdmNo: cdmNo, qrCode: qrCode)
            return AF.request(request)
                .validate()
                .validate(contentType: ["application/json"])
                .cURLDescription { request in
                    print(request)
                }
                .publishDecodable(type: T.ResponseType.self, decoder: decoder)
                .value()
        } catch {
            return Fail(outputType: T.ResponseType.self, failure: AFError.createURLRequestFailed(error: error))
                .eraseToAnyPublisher()
        }
    }
    
    /// ペアリング
    public static func connect(qrCode: String) {
        self.qrCode = qrCode
    }
    
    /// サインイン
    public static func signIn(damtomoId: String, password: String) -> AnyPublisher<Bool, AFError> {
        let request = Login(damtomoId: damtomoId, password: password)
        return Future { promise in
            DKKaraoke.publish(request)
                .sink(receiveCompletion: { completion in
                    switch completion {
                        case .finished:
                            promise(.success(true))
                        case .failure(let error):
                            promise(.failure(error))
                    }
                }, receiveValue: { response in
                    self.cdmNo = response.cdmNo
                })
                .store(in: &task)
        }
        .eraseToAnyPublisher()
    }
    
    /// コマンド送信
    public static func command(command: DKCommand) -> AnyPublisher<Command.Response, AFError> {
        let request = Command(command: command)
        return DKKaraoke.publish(request)
    }
}
