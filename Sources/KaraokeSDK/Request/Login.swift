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
            public let artistId: String
            public let artistKana: String
            public let artistName: String
            public let distEnd: String
            public let distStart: String
            public let firstBars: String
            public let funcAnimePicture: Bool
            public let funcPersonPicture: Bool
            public let funcRecording: Bool
            public let funcScore: Bool
            public let indicationMonth: String
            public let myKey: Int
            public let myListNo: Int
            public let orgKey: Int
            public let programTitle: String
            public let registerDate: String
            public let reqNo: String
            public let songKana: String
            public let songName: String
            public let titleFirstKana: String
            public let updateLockKey: String
            
            public init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                
                self.artistId = try container.decode(String.self, forKey: .artistId)
                self.artistKana = try container.decode(String.self, forKey: .artistKana)
                self.artistName = try container.decode(String.self, forKey: .artistName)
                self.distEnd = try container.decode(String.self, forKey: .distEnd)
                self.distStart = try container.decode(String.self, forKey: .distStart)
                self.firstBars = try container.decode(String.self, forKey: .firstBars)
                self.funcAnimePicture = Bool(try container.decode(String.self, forKey: .funcAnimePicture))
                self.funcPersonPicture = Bool(try container.decode(String.self, forKey: .funcPersonPicture))
                self.funcRecording = Bool(try container.decode(String.self, forKey: .funcRecording))
                self.funcScore = Bool(try container.decode(String.self, forKey: .funcScore))
                self.indicationMonth = try container.decode(String.self, forKey: .distStart)
                self.myKey = Int(try container.decode(String.self, forKey: .myKey))!
                self.myListNo = Int(try container.decode(String.self, forKey: .myListNo))!
                self.orgKey = Int(try container.decode(String.self, forKey: .orgKey))!
                self.programTitle = try container.decode(String.self, forKey: .programTitle)
                self.registerDate = try container.decode(String.self, forKey: .registerDate)
                self.reqNo = try container.decode(String.self, forKey: .reqNo)
                self.songKana = try container.decode(String.self, forKey: .songKana)
                self.songName = try container.decode(String.self, forKey: .songName)
                self.titleFirstKana = try container.decode(String.self, forKey: .titleFirstKana)
                self.updateLockKey = try container.decode(String.self, forKey: .updateLockKey)
            }
        }
    }
}

fileprivate extension Bool {
    init(_ stringValue: String) {
        self.init(stringValue != "0")
    }
    
    init?(_ stringValue: String?) {
        guard let stringValue = stringValue else {
            return nil
        }
        self.init(stringValue != "0")
    }
}
