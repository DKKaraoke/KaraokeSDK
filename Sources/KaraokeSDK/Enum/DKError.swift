//
//  DKError.swift
//  
//
//  Created by devonly on 2022/01/01.
//

import Foundation
import Alamofire

public enum DKError: Error {
    case loginFailedError(ValidationModel.Login)
    case logoutFailedError(ValidationModel.Logout)
    case remoconSendFailedError(ValidationModel.Remocon)
    case authenticationError
    case invalidQRCodeError
}

extension DKError: LocalizedError {
    public var errorDescription: String? {
        switch self {
            case .loginFailedError(let value):
                return value.result.rawValue
            case .logoutFailedError(let value):
                return value.result.rawValue
            case .remoconSendFailedError(let value):
                return value.result.rawValue
            case .authenticationError:
                return "No credential."
            case .invalidQRCodeError:
                return "Invalid QRCode."
        }
    }
}
