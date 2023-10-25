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
    public typealias ResponseType = Response

    public var method: HTTPMethod = .post
    public var path: String = "DkDamSeparateServlet"
    public var parameters: Parameters?

    init() {
        self.parameters = [
            "deviceId": UIDevice.current.identifierForVendor!.uuidString.data(using: .utf8)!.base64EncodedString().lowercased()
        ]
    }

    public struct Response: Codable {
        public let QRcode: String
        public let cdmNo: String
        public let deviceId: String
        public let deviceNm: String
        public let osVer: String
        public let ipAdr: String
        public let result: DKResult
        public let serialNo: String
        public let songCertification: String
        public let substituteBoot: String
    }
}
