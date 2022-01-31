//
//  Search.swift
//  
//
//  Created by devonly on 2022/01/24.
//

import Foundation
import Alamofire

public final class Search: RequestType {
    typealias ResponseType = Response
    
    var method: HTTPMethod = .post
    var baseURL: URL = URL(string: "https://csgw.clubdam.com/dkwebsys/search-api/")!
    var parameters: Parameters
    var path: String
    
    init(keyword: String, mode: Mode) {
        self.path = mode.rawValue
        self.parameters = [
            "authKey": "2/Qb9R@8s*",
            "pageNo": 1,
            "dispCount": 100,
            "sort": 2,
            "keyword": keyword,
            "compId": 1,
            "modelTypeCode": 3
        ]
    }
    
    public struct Response: Codable {
        public let result: ResultClass
        public let data: DataClass
        public let list: [List]
    }
    
    // MARK: - List
    public struct List: Codable {
        public let requestNo: String
        public let title: String
        public let titleYomi: String
        public let artistCode: Int
        public let artist: String
        public let artistYomi: String
        public let releaseDate: String
        @StringAcceptable public var newReleaseFlag: Bool
        @StringAcceptable public var futureReleaseFlag: Bool
        @StringAcceptable public var newArrivalsFlag: Bool
        @StringAcceptable public var honninFlag: Bool
        @StringAcceptable public var animeFlag: Bool
        @StringAcceptable public var liveFlag: Bool
        @StringAcceptable public var kidsFlag: Bool
        @StringAcceptable public var mamaotoFlag: Bool
        @StringAcceptable public var namaotoFlag: Bool
        @StringAcceptable public var duetFlag: Bool
        @StringAcceptable public var guideVocalFlag: Bool
        @StringAcceptable public var prookeFlag: Bool
        @StringAcceptable public var damTomoMovieFlag: Bool
        @StringAcceptable public var damTomoRecordingFlag: Bool
        @NullAcceptable public var damTomoPublicVocalFlag: Bool?
        @NullAcceptable public var damTomoPublicMovieFlag: Bool?
        @NullAcceptable public var damTomoPublicRecordingFlag: Bool?
        @StringAcceptable public var scoreFlag: Bool
        @StringAcceptable public var myListFlag: Bool
        @NullAcceptable public var shift: Int?
        public let playbackTime: Int?
        public let highlightLyrics: String?
    }
    
    // MARK: - DataClass
    public struct DataClass: Codable {
        public let pageCount: Int
        @StringAcceptable public var hasPreview: Bool
        @StringAcceptable public var overFlag: Bool
        @StringAcceptable public var pageNo: Int
        @StringAcceptable public var hasNext: Bool
        public let keyword: String
        public let totalCount: Int
    }
    
    // MARK: - ResultClass
    public struct ResultClass: Codable {
        public let statusCode: String
        public let message: String
    }

    public enum Mode: String, CaseIterable {
        case artist     = "SearchArtistByKeywordApi"
        case music      = "SearchMusicByKeywordApi"
        case various    = "SearchVariousByKeywordApi"
    }
}
