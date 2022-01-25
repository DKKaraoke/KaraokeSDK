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
        public let newReleaseFlag: Bool
        public let futureReleaseFlag: Bool
        public let newArrivalsFlag: Bool
        public let honninFlag: Bool
        public let animeFlag: Bool
        public let liveFlag: Bool
        public let kidsFlag: Bool
        public let mamaotoFlag: Bool
        public let namaotoFlag: Bool
        public let duetFlag: Bool
        public let guideVocalFlag: Bool
        public let prookeFlag: Bool
        public let damTomoMovieFlag: Bool
        public let damTomoRecordingFlag: Bool
        public let damTomoPublicVocalFlag: Bool?
        public let damTomoPublicMovieFlag: Bool?
        public let damTomoPublicRecordingFlag: Bool?
        public let scoreFlag: Bool
        public let myListFlag: Bool
        public let shift: String?
        public let playbackTime: Int
        public let highlightLyrics: String?
    }
    
    // MARK: - DataClass
    public struct DataClass: Codable {
        public let pageCount: Int
        public let hasPreview: String
        public let overFlag: String
        public let pageNo: Int
        public let hasNext: String
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

extension Search.List {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.requestNo = try container.decode(String.self, forKey: .requestNo)
        self.title = try container.decode(String.self, forKey: .title)
        self.titleYomi = try container.decode(String.self, forKey: .titleYomi)
        self.artistCode = try container.decode(Int.self, forKey: .artistCode)
        self.artist = try container.decode(String.self, forKey: .artist)
        self.artistYomi = try container.decode(String.self, forKey: .artistYomi)
        self.releaseDate = try container.decode(String.self, forKey: .releaseDate)
        self.newReleaseFlag = Bool(try container.decode(String.self, forKey: .newReleaseFlag))
        self.futureReleaseFlag = Bool(try container.decode(String.self, forKey: .futureReleaseFlag))
        self.newArrivalsFlag = Bool(try container.decode(String.self, forKey: .newArrivalsFlag))
        self.honninFlag = Bool(try container.decode(String.self, forKey: .honninFlag))
        self.animeFlag = Bool(try container.decode(String.self, forKey: .animeFlag))
        self.liveFlag = Bool(try container.decode(String.self, forKey: .liveFlag))
        self.kidsFlag = Bool(try container.decode(String.self, forKey: .kidsFlag))
        self.mamaotoFlag = Bool(try container.decode(String.self, forKey: .mamaotoFlag))
        self.namaotoFlag = Bool(try container.decode(String.self, forKey: .namaotoFlag))
        self.duetFlag = Bool(try container.decode(String.self, forKey: .duetFlag))
        self.guideVocalFlag = Bool(try container.decode(String.self, forKey: .guideVocalFlag))
        self.prookeFlag = Bool(try container.decode(String.self, forKey: .prookeFlag))
        self.damTomoMovieFlag = Bool(try container.decode(String.self, forKey: .damTomoMovieFlag))
        self.damTomoRecordingFlag = Bool(try container.decode(String.self, forKey: .damTomoRecordingFlag))
        self.damTomoPublicVocalFlag = Bool(try container.decodeIfPresent(String.self, forKey: .damTomoPublicVocalFlag))
        self.damTomoPublicMovieFlag = Bool(try container.decodeIfPresent(String.self, forKey: .damTomoPublicMovieFlag))
        self.damTomoPublicRecordingFlag = Bool(try container.decodeIfPresent(String.self, forKey: .damTomoPublicRecordingFlag))
        self.scoreFlag = Bool(try container.decode(String.self, forKey: .scoreFlag))
        self.myListFlag = Bool(try container.decode(String.self, forKey: .myListFlag))
        self.shift = try container.decodeIfPresent(String.self, forKey: .shift)
        self.playbackTime = try container.decode(Int.self, forKey: .playbackTime)
        self.highlightLyrics = try container.decodeIfPresent(String.self, forKey: .highlightLyrics)
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
