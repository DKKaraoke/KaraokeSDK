//
//  Detail.swift
//
//
//  Created by devonly on 2022/01/24.
//

import Foundation
import Alamofire

public final class Detail: RequestType {
    public typealias ResponseType = Response
    
    public var method: HTTPMethod = .post
    public var baseURL: URL = URL(string: "https://csgw.clubdam.com/dkwebsys/search-api/")!
    public var parameters: Parameters
    public var path: String = "GetMusicDetailInfoApi"
    
    init(requestNo: String, serialNo: String) {
        self.parameters = [
            "authKey": "2/Qb9R@8s*",
            "compId": 1,
            "modelTypeCode": 3,
            "requestNo": requestNo,
            "serialNo": serialNo
        ]
    }
    
    // MARK: - Result
    public struct Response: Codable {
        public let result: ResultClass
        public let data: DataClass
        public let list: [List]
    }
    
    // MARK: - List
    public struct List: Codable {
        public let kModelMusicInfoList: [KModelMusicInfoList]
    }
    
    // MARK: - KModelMusicInfoList
    public struct KModelMusicInfoList: Codable {
        public let highlightTieUp: String?
        @StringAcceptable public var kidsFlag: Bool
        @NullAcceptable public var damTomoPublicVocalFlag: Bool?
        @NullAcceptable public var damTomoPublicMovieFlag: Bool?
        @NullAcceptable public var damTomoPublicRecordingFlag: Bool?
        @NullAcceptable public var karaokeDamFlag: Bool?
        public let playbackTime: Int
        public let eachModelMusicInfoList: [EachModelMusicInfoList]
    }
    
    // MARK: - EachModelMusicInfoList
    public struct EachModelMusicInfoList: Codable {
        public let karaokeModelNum: String
        public let karaokeModelName: String
        public let releaseDate: String
        public let shift: String
        public let mainMovieId: String
        public let mainMovieName: String
        @StringAcceptable public var subMovieId: String
        @StringAcceptable public var subMovieName: String
        @StringAcceptable public var honninFlag: Bool
        @StringAcceptable public var animeFlag: Bool
        @StringAcceptable public var liveFlag: Bool
        @StringAcceptable public var mamaotoFlag: Bool
        @StringAcceptable public var namaotoFlag: Bool
        @StringAcceptable public var duetFlag: Bool
        @StringAcceptable public var guideVocalFlag: Bool
        @StringAcceptable public var prookeFlag: Bool
        @StringAcceptable public var scoreFlag: Bool
        @StringAcceptable public var duetDxFlag: Bool
        @StringAcceptable public var damTomoMovieFlag: Bool
        @StringAcceptable public var damTomoRecordingFlag: Bool
        @StringAcceptable public var myListFlag: Bool
    }
    
    // MARK: - DataClass
    public struct DataClass: Codable {
        public let artistCode: Int
        public let artist: String
        public let requestNo: String
        public let title: String
        public let titleYomiKana: String
        public let firstLine: String
        
        enum CodingKeys: String, CodingKey {
            case artistCode
            case artist
            case requestNo
            case title
            case titleYomiKana = "titleYomi_Kana"
            case firstLine
        }
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            self.artistCode = try container.decode(Int.self, forKey: .artistCode)
            self.artist = try container.decode(String.self, forKey: .artist)
            self.requestNo = try container.decode(String.self, forKey: .requestNo)
            self.title = try container.decode(String.self, forKey: .title)
            self.titleYomiKana = try container.decode(String.self, forKey: .titleYomiKana)
            self.firstLine = try container.decode(String.self, forKey: .firstLine)
        }
    }
    
    // MARK: - ResultClass
    public struct ResultClass: Codable {
        public let statusCode: String
        public let message: String
    }
}

