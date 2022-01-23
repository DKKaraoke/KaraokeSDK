//
//  Disonnect.swift
//
//
//  Created by devonly on 2021/12/28.
//

import Foundation
import Alamofire
import UIKit

public final class Disconnect: RequestType {
    typealias ResponseType = Response
    
    var method: HTTPMethod = .post
    var path: String = "DkDamSeparateServlet"
    var parameters: Parameters

    init() {
        self.parameters = [
            "deviceId": UIDevice.current.identifierForVendor!.uuidString.data(using: .utf8)!.base64EncodedString().lowercased(),
        ]
    }
    
    public struct Response: Codable {
        public let QRcode: String
        public let cdmNo: String
        public let deviceId: String
        public let deviceNm: String
        public let osVer: String
        public let ipAdr: String
        public let result: Result.Logout
        public let serialNo: String
        public let songCertification: String
        public let substituteBoot: String
    }
}
