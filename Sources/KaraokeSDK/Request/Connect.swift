//
//  Connect.swift
//  
//
//  Created by devonly on 2021/12/28.
//

import Foundation
import Alamofire
import UIKit

public final class Connect: RequestType {
    public typealias ResponseType = Response
    
    public var method: HTTPMethod = .post
    public var path: String = "DkDamConnectServlet"
    public var parameters: Parameters?

    init(qrCode: String, cdmNo: String? = nil) {
        /// ペアリングするときはQRCodeの値がわかっていないので強制的に代入
        let parameters: [String: Any?] = [
            "appVer": "3.3.4.1",
            "deviceNm": "iPhone 14 Pro Max",
            "QRcode": qrCode,
            "osVer": "15.1.1",
            "cdmNo": cdmNo
        ]
        self.parameters = parameters.compactMapValues({ $0 })
    }
    
    public struct Response: Codable {
        public let QRcode: String
        public let cdmNo: String
        public let deviceId: String
        public let deviceNm: String
        public let lastSendTerm: String
        public let osVer: String
        public let remoconFlg: String
        public let result: DKResult
        public let songCertification: String
        public let substituteBoot: String
    }
}
