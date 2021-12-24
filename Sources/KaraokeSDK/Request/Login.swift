//
//  .swift
//  
//
//  Created by devonly on 2021/12/24.
//

import Foundation
import Alamofire

public final class Login: RequestType {
    typealias ResponseType = Response
    
    var method: HTTPMethod = .post
    var path: String = "DkDamDAMTomoLoginServlet"
    var parameters: Parameters

    init(damtomoId: String, password: String) {
        self.parameters = [
            "deviceId": "xs6I/zA4FzO/kc8P5PlgjIos03G0ayyg7eAp079lzmI=",
            "appVer": "3.3.4.1",
            "password": password,
            "deviceNm": "iPhone 14 Pro Max",
            "damtomoId": damtomoId,
            "osVer": "15.1.1"
        ]
    }
    
    func asURLRequest(cdmNo: String?, qrCode: String?) throws -> URLRequest {
        var request = URLRequest(url: baseURL.appendingPathComponent(path))
        request.httpMethod = method.rawValue
        request.timeoutInterval = TimeInterval(5)
        return try encoding.encode(request, with: parameters)
    }
    
    public struct Response: Codable {
        let cdmNo: String
        let damtomoId: String
        let deviceId: String
        let osVer: String
        let result: String
        let serialNo: String
    }
}
