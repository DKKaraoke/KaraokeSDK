//
//  Login.swift
//  
//
//  Created by devonly on 2021/12/24.
//

import Foundation
import Alamofire
import UIKit

public final class Login: RequestType {
    typealias ResponseType = Response
    
    var method: HTTPMethod = .post
    var path: String = "DkDamDAMTomoLoginServlet"
    var parameters: Parameters

    init(damtomoId: String, password: String) {
        self.parameters = [
            "password": password,
            "damtomoId": damtomoId,
        ]
    }
    
    public struct Response: Codable {
        public let cdmNo: String
        let damtomoId: String
        let deviceId: String
        let osVer: String
        let result: String
        let serialNo: String
        public let myContents: MyContents
        
        // MARK: - MyContents
        public struct MyContents: Codable {
            public let myHistoryList: [MyList]
            public let myList1List: [MyList]
            public let myList1TagName: String
            public let myList2List: [MyList]
            public let myList2TagName: String
            public let myList3List: [MyList]
            public let myList3TagName: String
            public let myList4List: [MyList]
            public let myList4TagName: String
        }

        // MARK: - MyList
        public struct MyList: Codable {
            @StringAcceptable public var artistId: Int
            public let artistKana: String
            public let artistName: String
            @StringAcceptable public var distEnd: Int
            @StringAcceptable public var distStart: Int
            public let firstBars: String
            @StringAcceptable public var funcAnimePicture: Bool
            @StringAcceptable public var funcPersonPicture: Bool
            @StringAcceptable public var funcRecording: Bool
            @StringAcceptable public var funcScore: Bool
            public let indicationMonth: String
            @StringAcceptable public var myKey: Int
            @StringAcceptable public var myListNo: Int
            @StringAcceptable public var orgKey: Int
            public let programTitle: String
            public let registerDate: String
            public let reqNo: String
            public let songKana: String
            public let songName: String
            public let titleFirstKana: String
            @StringAcceptable public var updateLockKey: Int
        }
    }
}

extension KeyedDecodingContainer {
    func decodeIfAccaptable<T: Decodable>(_ type: T.Type, forKey key: KeyedDecodingContainer<K>.Key) throws -> T where T: LosslessStringConvertible {
        // その型に変換できたらそのまま返す
        if let rawValue = try? decode(T.self, forKey: key) {
            return rawValue
        }
        // 文字列に変換できたらTに変換する
        if let stringValue = try? decode(String.self, forKey: key),
           let rawValue = T(stringValue) {
            return rawValue
        }
        throw DecodingError.typeMismatch(T.self, .init(codingPath: self.codingPath, debugDescription: "Expected to decode `\(T.self)/String` but found a `Unknown` instead.", underlyingError: nil))
    }
    
    func decodeIfPresentAccaptable<T: Decodable>(_ type: T.Type, forKey key: KeyedDecodingContainer<K>.Key) throws -> T? where T: LosslessStringConvertible {
        // その型に変換できたらそのまま返す
        if let rawValue = try? decode(T.self, forKey: key) {
            return rawValue
        }
        // 文字列に変換できたらTに変換する
        if let stringValue = try? decode(String.self, forKey: key),
           let rawValue = T(stringValue) {
            return rawValue
        }
        return nil
    }
}
