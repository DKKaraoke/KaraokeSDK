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
    func asURLRequest(cdmNo: String?, qrCode: String?) throws -> URLRequest
}

extension RequestType {
    var baseURL: URL {
        URL(string: "https://denmoku.clubdam.com/dkdenmoku/")!
    }
    
    var encoding: ParameterEncoding {
        JSONEncoding.default
    }
    
    func asURLRequest(cdmNo: String?, qrCode: String?) throws -> URLRequest {
        var request = URLRequest(url: baseURL.appendingPathComponent(path))
        request.httpMethod = method.rawValue
        request.timeoutInterval = TimeInterval(5)
        
        guard let cdmNo = cdmNo, let qrCode = qrCode else {
            throw NSError(domain: "No qrCode or cdmNo", code: 401, userInfo: nil)
        }

        let parameters = parameters.merging(["cdmNo": cdmNo, "qrCode": qrCode]) { $1 }
        return try encoding.encode(request, with: parameters)
    }
}
