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
    public typealias ResponseType = Response
    
    public var method: HTTPMethod = .post
    public var path: String = "DkDamPictureSendServlet"
    public var parameters: Parameters

    init(image: UIImage?) {
        self.parameters = [
            "sendType": "1",
            "pictureData": image.asPictureData()
        ]
    }
    
    init() {
        self.parameters = [
            "sendType": "2",
            "pictureData": ""
        ]
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

fileprivate extension Optional where Wrapped == UIImage {
    func asPictureData() -> String {
        let uiImageView = UIImageView()
        uiImageView.frame.size = CGSize(width: 1920, height: 1080)
        uiImageView.contentMode = .scaleAspectFit
        uiImageView.backgroundColor = .black
        if let image = self {
            uiImageView.image = image
        }
        let image = uiImageView.asUIImage()
        guard let pictureData = image.jpegData(compressionQuality: 1.0)?.base64EncodedString(options: .lineLength64Characters) else {
            return ""
        }
        return pictureData
    }
}

fileprivate extension UIView {
    func asUIImage() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0.0)
        let context: CGContext = UIGraphicsGetCurrentContext()!
        layer.render(in: context)
        let capturedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return capturedImage
    }
}
