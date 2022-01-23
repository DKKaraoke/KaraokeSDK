//
//  RequestType.swift
//  
//
//  Created by devonly on 2021/12/24.
//

import Foundation
import Alamofire
import UIKit

protocol RequestType: URLRequestConvertible {
    associatedtype ResponseType: Decodable
    
    var method: HTTPMethod { get }
    var baseURL: URL { get }
    var path: String { get }
    var encoding: ParameterEncoding { get }
    var parameters: Parameters { get set }
}

extension RequestType {
    var baseURL: URL {
        URL(string: "https://denmoku.clubdam.com/dkdenmoku/")!
    }
    
    var encoding: ParameterEncoding {
        JSONEncoding.default
    }
    
    public func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        let deviceId: String = UIDevice.current.identifierForVendor!.uuidString.data(using: .utf8)!.base64EncodedString().lowercased()
        var request = try URLRequest(url: url, method: method, headers: nil)
        request.timeoutInterval = TimeInterval(10)
        let parameters = parameters.merging(["deviceId": deviceId], uniquingKeysWith: { (_, new) in new } )
        return try encoding.encode(request, with: parameters)
    }
}
