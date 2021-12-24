//
//  RequestType.swift
//
//
//  Created by devonly on 2021/12/24.
//

import Foundation
import Combine
import Alamofire

open class DKKaraoke {
    /// シングルトン
    public static let shared: DKKaraoke = DKKaraoke()
    /// 接続用のQRコード
    public internal(set) var qrCode: String?
    /// 固有ID
    public internal(set) var cdmNo: String?
    /// タスク管理
    var task = Set<AnyCancellable>()
    /// キュー
    let queue: DispatchSemaphore = DispatchSemaphore(value: 1)
    /// JSONDecoder
    let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    /// リクエスト送信
    internal func publish<T: RequestType>(_ request: T) -> AnyPublisher<T.ResponseType, AFError> {
        do {
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
    public func connect(qrCode: String) {
        self.qrCode = qrCode
    }
    
    /// サインイン
    public func signIn(damtomoId: String, password: String) -> AnyPublisher<Bool, AFError> {
        let request = Login(damtomoId: damtomoId, password: password)
        return Future { [self] promise in
            publish(request)
                .sink(receiveCompletion: { completion in
                    switch completion {
                        case .finished:
                            promise(.success(true))
                        case .failure(let error):
                            promise(.failure(error))
                    }
                }, receiveValue: { response in
                    print(response)
                    self.cdmNo = response.cdmNo
                })
                .store(in: &task)
        }
        .eraseToAnyPublisher()
    }
    
    /// コマンド送信
    public func command(command: DKCommand) -> AnyPublisher<Command.Response, AFError> {
        let request = Command(command: command)
        return publish(request)
    }
}
