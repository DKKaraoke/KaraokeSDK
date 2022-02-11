//
//  ValidationModel.swift
//  
//
//  Created by devonly on 2022/01/01.
//

import Foundation
import Alamofire

public final class ValidationModel {
    public struct Login: Codable {
        let result: Result.Login
    }
    
    public struct Logout: Codable {
        let result: Result.Logout
    }
    
    public struct Remocon: Codable {
        let result: Result.Remocon
    }
    
    public struct Picture: Codable {
        let result: Result.Picture
    }
}
