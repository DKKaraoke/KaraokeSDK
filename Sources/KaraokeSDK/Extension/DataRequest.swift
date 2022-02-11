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
                if let data = data {
                    if let failure = try? decoder.decode(ValidationModel.Login.self, from: data),
                       (failure.result == .failure || failure.result == .timeout)
                    {
                        throw AFError.responseValidationFailed(reason: .customValidationFailed(error: DKError.loginFailedError(failure)))
                    }
                    if let failure = try? decoder.decode(ValidationModel.Logout.self, from: data),
                       (failure.result == .pairing || failure.result == .timeout)
                    {
                        throw AFError.responseValidationFailed(reason: .customValidationFailed(error: DKError.logoutFailedError(failure)))
                    }
                    if let failure = try? decoder.decode(ValidationModel.Remocon.self, from: data),
                       failure.result == .failure
                    {
                        throw AFError.responseValidationFailed(reason: .customValidationFailed(error: DKError.remoconSendFailedError(failure)))
                    }
                    if let failure = try? decoder.decode(ValidationModel.Picture.self, from: data),
                       (failure.result == .failure || failure.result == .unknown)
                    {
                        throw AFError.responseValidationFailed(reason: .customValidationFailed(error: DKError.pictureSendFailedError(failure)))
                    }
                }
            })
        })
    }
}
