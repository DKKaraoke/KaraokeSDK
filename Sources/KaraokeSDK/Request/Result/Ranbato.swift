//
//  Ranbato.swift
//  
//
//  Created by devonly on 2021/12/25.
//

import Foundation
import Alamofire

public final class Ranbato: RequestType {
    typealias ResponseType = Response
    
    var method: HTTPMethod = .get
    var path: String = "DkDamContentsHistoryServlet"
    var parameters: Parameters
    
    init(cdmNo: String) {
        self.parameters = [
            "categoryCd": "080100",
            "cdmNo": cdmNo,
        ]
    }
    
    // MARK: - Response
    public class Response: Codable {
        public let contentsHistoryList: [ContentsHistoryList]
    }

    // MARK: - ContentsHistoryList
    public class ContentsHistoryList: Codable {
        public let artistId: String
        public let artistName: String
        public let distEnd: String
        public let distStart: String
        public let firstBars: String
        public let funcAnimePicture: String
        public let funcPersonPicture: String
        public let funcRecording: String
        public let funcScore: String
        public let markingDate: String
        public let myKey: String
        public let orgKey: String
        public let rankD: String
        public let rankM: String
        public let rankType: String
        public let reqNo: String
        public let score: String
        public let songName: String
    }
}
