//
//  Detail.swift
//
//
//  Created by devonly on 2022/01/24.
//

import Foundation
import Alamofire

public final class Detail: RequestType {
    typealias ResponseType = Response
    
    var method: HTTPMethod = .post
    var baseURL: URL = URL(string: "https://csgw.clubdam.com/dkwebsys/search-api/")!
    var parameters: Parameters
    var path: String = "GetMusicDetailInfoApi"
    
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
        public let kidsFlag: String
        public let damTomoPublicVocalFlag: String
        public let damTomoPublicMovieFlag: String
        public let damTomoPublicRecordingFlag: String
        public let karaokeDamFlag: String
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
        public let subMovieId: String
        public let subMovieName: String
        public let honninFlag: Bool
        public let animeFlag: Bool
        public let liveFlag: Bool
        public let mamaotoFlag: Bool
        public let namaotoFlag: Bool
        public let duetFlag: Bool
        public let guideVocalFlag: Bool
        public let prookeFlag: Bool
        public let scoreFlag: Bool
        public let duetDxFlag: Bool
        public let damTomoMovieFlag: Bool
        public let damTomoRecordingFlag: Bool
        public let myListFlag: Bool
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            self.karaokeModelNum = try container.decode(String.self, forKey: .karaokeModelNum)
            self.karaokeModelName = try container.decode(String.self, forKey: .karaokeModelName)
            self.releaseDate = try container.decode(String.self, forKey: .releaseDate)
            self.shift = try container.decode(String.self, forKey: .shift)
            self.mainMovieId = try container.decode(String.self, forKey: .mainMovieId)
            self.mainMovieName = try container.decode(String.self, forKey: .mainMovieName)
            self.subMovieId = try container.decode(String.self, forKey: .subMovieId)
            self.subMovieName = try container.decode(String.self, forKey: .subMovieName)
            self.honninFlag = Bool(try container.decode(String.self, forKey: .honninFlag))
            self.animeFlag = Bool(try container.decode(String.self, forKey: .animeFlag))
            self.liveFlag = Bool(try container.decode(String.self, forKey: .liveFlag))
            self.mamaotoFlag = Bool(try container.decode(String.self, forKey: .mamaotoFlag))
            self.namaotoFlag = Bool(try container.decode(String.self, forKey: .namaotoFlag))
            self.duetFlag = Bool(try container.decode(String.self, forKey: .duetFlag))
            self.guideVocalFlag = Bool(try container.decode(String.self, forKey: .guideVocalFlag))
            self.prookeFlag = Bool(try container.decode(String.self, forKey: .prookeFlag))
            self.damTomoMovieFlag = Bool(try container.decode(String.self, forKey: .damTomoMovieFlag))
            self.damTomoRecordingFlag = Bool(try container.decode(String.self, forKey: .damTomoRecordingFlag))
            self.scoreFlag = Bool(try container.decode(String.self, forKey: .scoreFlag))
            self.myListFlag = Bool(try container.decode(String.self, forKey: .myListFlag))
            self.duetDxFlag = Bool(try container.decode(String.self, forKey: .duetDxFlag))
        }
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
