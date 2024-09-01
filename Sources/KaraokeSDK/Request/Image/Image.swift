//
//  Image.swift
//
//
//  Created by devonly on 2022/01/28.
//

import Alamofire
import Foundation
import Kanna

public enum Amazon {
    public final class Image: RequestType {
        public typealias ResponseType = Response

        public var method: HTTPMethod = .get
        public var baseURL: URL = .init(string: "https://www.amazon.co.jp/")!
        public var path: String = "s"
        public var parameters: Parameters?
        public var encoding: ParameterEncoding = URLEncoding.queryString

        init(searchText: String) {
            parameters = [
                "k": searchText,
                "i": "digital-music",
            ]
        }

        public class Response: Codable, Identifiable {
            public let imageURL: URL

            init?(document: XMLElement) {
                guard let srcset = document["srcset"],
                      let imageURL = try? srcset.matching(pattern: "(https://m.media-amazon.com/images/I/[\\S]*)").compactMap({ URL(string: $0) }).last
                else {
                    return nil
                }
                self.imageURL = imageURL
            }
        }

        public func asURLRequest() throws -> URLRequest {
            let url = baseURL.appendingPathComponent(path)
            var request = try URLRequest(url: url, method: method, headers: nil)
            request.timeoutInterval = TimeInterval(10)
            return try encoding.encode(request, with: parameters)
        }
    }
}

extension String {
    func matching(expression regex: @autoclosure () throws -> NSRegularExpression) rethrows -> [String] {
        let results = try regex().matches(in: self, range: NSRange(startIndex..., in: self))
        return results.map {
            String(self[Range($0.range, in: self)!])
        }
    }

    func matching(pattern regexPattern: String) throws -> [String] {
        try matching(expression: NSRegularExpression(pattern: regexPattern))
    }
}
