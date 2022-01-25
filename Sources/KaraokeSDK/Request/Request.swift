//
//  Request.swift
//  
//
//  Created by devonly on 2021/12/26.
//

import Foundation
import Alamofire

public final class Request: RequestType {
    typealias ResponseType = Response
    
    var method: HTTPMethod = .post
    var path: String = "DkDamSendServlet"
    var parameters: Parameters
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "YYYY/MM/dd HH:mm:ss"
        return formatter
    }()
    
    init(reqNo: Int, myKey: Int, interrupt: Int = 0) {
        self.parameters = [
            "reqNo": reqNo,
            "sendDate": dateFormatter.string(from: Date()),
            "myKey": String(myKey),
            "interrupt": String(interrupt)
        ]
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
        public let result: Result.Request
        public let sendDate: String
    }
}
