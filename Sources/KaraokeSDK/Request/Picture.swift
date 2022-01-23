//
//  Picture.swift
//  
//
//  Created by devonly on 2022/01/23.
//

import Foundation
import Alamofire
import UIKit

public final class Picture: RequestType {
    typealias ResponseType = Response
    
    var method: HTTPMethod = .post
    var path: String = "DkDamPictureSendServlet"
    var parameters: Parameters

    init(image: UIImage, sendType: SendType) {
        self.parameters = [
            "sendType": sendType.rawValue,
            "pictureData": image.jpegData(compressionQuality: 1.0)!.base64EncodedString(options: .lineLength64Characters)
        ]
    }
    
    public enum SendType: Int, CaseIterable, Codable {
        case send   = 1
        case delete = 2
    }
    
    public struct Response: Codable {
        public let QRcode: String
        public let appVer: String
        public let cdmNo: String
        public let connectionEquip: ConnectionEquip
        public let deviceId: String
        public let deviceNm: String
        public let lastSendTerm: String
        public let osVer: String
        public let pictureData: String
        public let remoconFlg: String
        public let result: String
        public let sendType: String
        public let songCertification: String
        public let substituteBoot: String
    }
    
    public struct ConnectionEquip: Codable {
        public let equip1: String
        public let equip10: String
        public let equip11: String
        public let equip12: String
        public let equip13: String
        public let equip14: String
        public let equip15: String
        public let equip16: String
        public let equip2: String
        public let equip3: String
        public let equip4: String
        public let equip5: String
        public let equip6: String
        public let equip7: String
        public let equip8: String
        public let equip9: String
    }
}
