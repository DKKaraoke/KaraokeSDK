//
//  Ranking.swift
//  
//
//  Created by devonly on 2022/04/20.
//

import Foundation
import Alamofire

final public class Ranking: RequestType {

    public typealias ResponseType = Response

    public var method: HTTPMethod = .get
    public var baseURL: URL = URL(string: "https://dkranbato.herokuapp.com/")!
    public var parameters: Parameters?
    public var path: String

    init(requestNo: Int) {
        self.path = "ranking/\(requestNo)"
    }

    init(requestNo: String) {
        self.path = "ranking/\(requestNo)"
    }

    public struct Response: Codable {
        public let requestId: Int
        public let results: [Record]
    }

    public struct Record: Codable {
        public let rank: Int
        public let username: String
        public let score: Double
        public let location: String
    }
}
