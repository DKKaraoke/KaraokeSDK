//
//  .swift
//  
//
//  Created by devonly on 2021/12/24.
//

import Foundation
import Alamofire

public final class Login: RequestType {
    typealias ResponseType = Response
    
    var method: HTTPMethod = .post
    var path: String = "DkDamDAMTomoLoginServlet"
    var parameters: Parameters

    init(damtomoId: String, password: String) {
        self.parameters = [
            "deviceId": "xs6I/zA4FzO/kc8P5PlgjIos03G0ayyg7eAp079lzmI=",
            "appVer": "3.3.4.1",
            "password": password,
            "deviceNm": "iPhone 14 Pro Max",
            "damtomoId": damtomoId,
            "osVer": "15.1.1"
        ]
    }
    public struct Response: Codable {
        let cdmNo: String
        let damtomoId: String
        let deviceId: String
        let myContents: Content
        
        struct Content: Codable {
            let myHistoryList: [SongInfo]
            let myList1TagName: String
            let myList1List: [SongInfo]
            let myList2TagName: String
            let myList2List: [SongInfo]
            let myList3TagName: String
            let myList3List: [SongInfo]
            let myList4TagName: String
            let myList4List: [SongInfo]
            
            struct SongInfo: Codable {
                let artistId: String
                let artistKana: String
                let artistName: String
                let distEnd: String
                let distStart: String
                let firstBars: String
                let funcAnimePicture: String
                let funcPersonPicture: String
                let funcScore: String
                let indicationMonth: String
                let myKey: String
                let myListNo: String
                let orgKey: String
                let programTitle: String
                let registerDate: String
                let reqNo: String
                let songKana: String
                let songName: String
                let titleFirstKana: String
                let updateLockKey: String
            }
        }
    }
}
