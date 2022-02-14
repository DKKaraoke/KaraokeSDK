//
//  DataRequest.swift
//  
//
//  Created by devonly on 2022/01/01.
//

import Foundation
import Alamofire

public extension DataRequest {
    @discardableResult
    func validateWithFuckingDKFormat() -> Self {
        validate({ _, response, data in
            DataRequest.ValidationResult(catching: {
                let decoder: JSONDecoder = JSONDecoder()
                guard let data = data else {
                    throw DKError.responseDataCorrupted
                }
                
                guard let result = try? decoder.decode(ValidationModel.self, from: data) else {
                    return
                }
                
                switch result.result {
                case .successLogin, .successConnect, .successPicture, .successRemocon, .successDisconnect:
                    break
                default:
                    throw DKError.responseValidationFailed(result.result)
                }
            })
        })
    }
}

internal struct ValidationModel: Codable {
    let result: DKResult
}
