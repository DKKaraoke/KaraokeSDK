//
//  Fistia.swift
//  
//
//  Created by devonly on 2021/12/26.
//

import Foundation
import Alamofire

public enum Fistia {
    public final class Prediction: RequestType {
        public typealias ResponseType = Response
        
        public var method: HTTPMethod = .get
        public var path: String = "_score_predictions"
        public var baseURL: URL = {
            return URL(string: "https://entei-kun-api.proj.tokyo/")!
//            #if DEBUG
//            return URL(string: "https://entei-kun-dev-api.proj.tokyo/")!
//            #else
//            return URL(string: "https://entei-kun-api.proj.tokyo/api/")!
//            #endif
        }()
        public var parameters: Parameters?
        public var encoding: ParameterEncoding = URLEncoding.queryString

        let dateFormatter: ISO8601DateFormatter = {
            let formatter = ISO8601DateFormatter()
            formatter.timeZone = TimeZone.current
            return formatter
        }()
//        let dateFormatter: DateFormatter = {
//            let formatter = DateFormatter()
//            formatter.timeZone = TimeZone.current
//            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//            return formatter
//        }()

        init(
            startTime: Date = Date(),
            timeLimit: Int = 600,
            includeNormal: Bool = false,
            includeQuadruple: Bool = true,
            include100: Bool = true,
            isJst: Bool = false
        ) {
            self.parameters = [
                "startTime": dateFormatter.string(from: startTime),
                "timeLimit": timeLimit,
                "includeNormal": includeNormal.description,
                "includeQuadruple": includeQuadruple.description,
                "include100": include100.description,
                "isJst": isJst.description
            ]
        }
        
        public class Response: Codable {
            public let scorePredictions: [ScorePrediction]
        }
        
        public class ScorePrediction: Codable {
            public let time: String
            public let scoreInteger: Int
            public let scoreString: String
            public let scoreType: ScoreType
//            #if DEBUG
//            public let time: String
//            public let scoreInteger: Int
//            public let scoreString: String
//            public let scoreType: ScoreType
//            #else
//            public let time: String
//            public let timeOffset: Int
//            public let scoreInteger: Int
//            public let scoreString: String
//            public let is100: Bool
//            public let isQuadruple: Bool
//            public let isNormal: Bool
//            #endif
        }
        
        public enum ScoreType: String, CaseIterable, Codable {
            case hundred    = "Hundred"
            case quadruple  = "Quadruple"
            case normal     = "Normal"
        }
    }
    
    public final class PredictionCount: RequestType {
        public typealias ResponseType = Response
        
        public var method: HTTPMethod = .get
        public var path: String = "_score_prediction_count"
        public var baseURL: URL = {
            return URL(string: "https://entei-kun-api.proj.tokyo/")!
        }()
        public var parameters: Parameters?
        public var encoding: ParameterEncoding = URLEncoding.queryString

        let dateFormatter: ISO8601DateFormatter = {
            let formatter = ISO8601DateFormatter()
            formatter.timeZone = TimeZone.current
            return formatter
        }()

        init(
            startTime: Date = Date(),
            timeSpan: Int = 1800,
            timeLimit: Int = 600
        ) {
            self.parameters = [
                "startTime": dateFormatter.string(from: startTime),
                "timeLimit": timeLimit,
                "timeSpan": timeSpan
            ]
        }
        
        // MARK: - Result
        public struct Response: Codable {
            public let scorePredictionCount: [ScorePredictionCount]
        }
        
        // MARK: - ScorePredictionCount
        public struct ScorePredictionCount: Codable {
            public let startTime: String
            public let endTime: String
            public let utc: ScoreDistribution
            public let jst: ScoreDistribution
        }
        
        // MARK: - ScoreDistribution
        public struct ScoreDistribution: Codable {
            public let hundredCount: Int
            public let quadrupleCount: Int
        }
    }
}
