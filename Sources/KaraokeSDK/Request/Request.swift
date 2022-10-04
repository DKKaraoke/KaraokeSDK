//
//  Request.swift
//  
//
//  Created by devonly on 2021/12/26.
//

import Foundation
import Alamofire

public final class Request: RequestType {
    public typealias ResponseType = Response
    
    public var method: HTTPMethod = .post
    public var path: String = "DkDamSendServlet"
    public var parameters: Parameters?
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "YYYY/MM/dd HH:mm:ss"
        return formatter
    }()
    
    init(reqNo: Int, myKey: Int, interrupt: Int = 0, contentsKind: DKContent) {
        let parameters: [String: Any?] = [
            "reqNo": reqNo,
            "sendDate": dateFormatter.string(from: Date()),
            "myKey": String(myKey),
            "interrupt": String(interrupt),
            "contentsKind": contentsKind.kindValue
        ]
        self.parameters = parameters.compactMapValues({ $0 })
    }
    
    public struct Response: Codable {
        public let QRcode: String
        public let appVer: String
        public let cdmNo: String
        public let contentsKind: String
        public let deviceId: String
        public let deviceNm: String
        public let entryNo: String
        public let lastSendTerm: String
        public let myKey: String
        public let osVer: String
        public let reqNo: String
        public let result: DKResult
        public let sendDate: String
    }
}
