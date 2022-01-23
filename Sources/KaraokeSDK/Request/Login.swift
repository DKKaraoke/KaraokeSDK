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
            public init(artistId: String, artistKana: String, artistName: String, distEnd: String, distStart: String, firstBars: String, funcAnimePicture: String, funcPersonPicture: String, funcRecording: String, funcScore: String, indicationMonth: String, myKey: String, myListNo: String, orgKey: String, programTitle: String, registerDate: String, reqNo: String, songKana: String, songName: String, titleFirstKana: String, updateLockKey: String) {
                self.artistId = artistId
                self.artistKana = artistKana
                self.artistName = artistName
                self.distEnd = distEnd
                self.distStart = distStart
                self.firstBars = firstBars
                self.funcAnimePicture = funcAnimePicture
                self.funcPersonPicture = funcPersonPicture
                self.funcRecording = funcRecording
                self.funcScore = funcScore
                self.indicationMonth = indicationMonth
                self.myKey = myKey
                self.myListNo = myListNo
                self.orgKey = orgKey
                self.programTitle = programTitle
                self.registerDate = registerDate
                self.reqNo = reqNo
                self.songKana = songKana
                self.songName = songName
                self.titleFirstKana = titleFirstKana
                self.updateLockKey = updateLockKey
            }
            
            public let artistId: String
            public let artistKana: String
            public let artistName: String
            public let distEnd: String
            public let distStart: String
            public let firstBars: String
            public let funcAnimePicture: String
            public let funcPersonPicture: String
            public let funcRecording: String
            public let funcScore: String
            public let indicationMonth: String
            public let myKey: String
            public let myListNo: String
            public let orgKey: String
            public let programTitle: String
            public let registerDate: String
            public let reqNo: String
            public let songKana: String
            public let songName: String
            public let titleFirstKana: String
            public let updateLockKey: String
        }
    }
}
