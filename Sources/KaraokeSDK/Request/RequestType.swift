//
//  RequestType.swift
//  
//
//  Created by devonly on 2021/12/24.
//

import Foundation
import Alamofire

protocol RequestType {
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
    
    func asURLRequest(cdmNo: String, qrCode: String) throws -> URLRequest {
        var request = URLRequest(url: baseURL.appendingPathComponent(path))
        request.httpMethod = method.rawValue
        request.timeoutInterval = TimeInterval(5)
        
        let parameters = parameters.merging(["cdmNo": cdmNo, "qrCode": qrCode]) { $1 }
        return try encoding.encode(request, with: parameters)
    }
}
