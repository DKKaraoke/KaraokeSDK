//
//  AuthenticationInterceptor.swift
//  
//
//  Created by devonly on 2022/01/22.
//

import Foundation
import Alamofire
import UIKit

public struct OAuthCredential: AuthenticationCredential, Codable {
    public let code: String
    public let ip: String
    public let serial: String
    public let cdmNo: String
    public let deviceNm: String
    public let devicdId: String
    public let deviceType: DeviceId
    public let expiration: Date
    
    // 10分前だったら自動更新する
    public var requiresRefresh: Bool { Date(timeIntervalSinceNow: 600) > expiration }
    
    init(response: Connect.Response) {
        let code: QRCode = try! QRCode(code: response.QRcode)
        self.code = response.QRcode
        self.ip = code.ip
        let serial = String(bytes: code.serial.chunked(by: 2).compactMap({ UInt8($0, radix: 16) }), encoding: .ascii)!
        self.serial = serial
        self.cdmNo = response.cdmNo
        self.deviceNm = response.deviceNm
        self.devicdId = response.deviceId
        self.deviceType = {
            let deviceId = serial.prefix(2)
            switch deviceId {
                case "AF":
                    return .xg5000
                case "AM":
                    return .xg7000
                case "AT":
                    return .xg8000
                default:
                    return .unknown
            }
        }()
        self.expiration = Date(timeIntervalSinceNow: 3600)
    }
}

extension DKKaraoke: Authenticator {
    public func didRequest(_ urlRequest: URLRequest, with response: HTTPURLResponse, failDueToAuthenticationError error: Error) -> Bool {
        return false
    }
    
    public func isRequest(_ urlRequest: URLRequest, authenticatedWith credential: OAuthCredential) -> Bool {
        return true
    }
    
    public func apply(_ credential: OAuthCredential, to urlRequest: inout URLRequest) {
        guard let data = urlRequest.httpBody else {
            return
        }
        guard var parameters = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            return
        }
        let device: [String: String] = [
            "appVer": "3.3.4.1",
            "deviceNm": credential.devicdId,
            "QRcode": credential.code,
            "osVer": UIDevice.current.systemVersion,
            "deviceId": credential.devicdId,
            "cdmNo": credential.cdmNo
        ]
        // パラメータを上書き
        parameters.merge(device, uniquingKeysWith: { (_, new) in new } )
        // 強制的にエンコーディング(失敗することはないと思われる)
        urlRequest = try! JSONEncoding.default.encode(urlRequest, with: parameters)
    }
    
    public func refresh(_ credential: OAuthCredential, for session: Session, completion: @escaping (Swift.Result<OAuthCredential, Error>) -> Void) {
        let qrCode: String = try! QRCode(code: credential.code).code
        self.connect(qrCode: qrCode, cdmNo: credential.cdmNo)
            .sink(receiveCompletion: { result in
                switch result {
                    case .finished:
                        break
                    case .failure(let error):
                        completion(.failure(error))
                        return
                }
            }, receiveValue: { response in
                let credential: OAuthCredential = OAuthCredential(response: response)
                self.credential = credential
                completion(.success(credential))
            })
            .store(in: &self.task)
    }
}
