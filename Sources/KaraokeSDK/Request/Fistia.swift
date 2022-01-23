//
//  Fistia.swift
//  
//
//  Created by devonly on 2021/12/26.
//

import Foundation
import Alamofire

public final class Fistia: RequestType {
    typealias ResponseType = Response
    
    var method: HTTPMethod = .get 
    var path: String = "_score_predictions"
    var baseURL: URL = URL(string: "https://entei-kun.proj.tokyo/api/")!
    var parameters: Parameters
    var encoding: ParameterEncoding = URLEncoding.queryString
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }()

    init(
        startTime: Date = Date(),
        timeLimit: Int = 600,
        includeNormal: Bool = false,
        includeQuadruple: Bool = true,
        include100: Bool = true,
        isLiveDamStadium: Bool = false
    ) {
        self.parameters = [
            "startTime": dateFormatter.string(from: startTime),
            "timeLimit": timeLimit,
            "includeNormal": includeNormal.description,
            "includeQuadruple": includeQuadruple.description,
            "include100": include100.description,
            "isLiveDamStadium": isLiveDamStadium.description
        ]
    }
    
    public class Response: Codable {
        public let scorePredictions: [ScorePrediction]
    }
    
    public class ScorePrediction: Codable {
        public let time: String
        public let timeOffset: Int
        public let scoreInteger: Int
        public let scoreString: String
        public let is100: Bool
        public let isQuadruple: Bool
        public let isNormal: Bool
    }
}
