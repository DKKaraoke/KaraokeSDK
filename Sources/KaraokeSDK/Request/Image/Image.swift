//
//  File.swift
//  
//
//  Created by devonly on 2022/01/28.
//

import Foundation
import Alamofire
import Kanna

public enum Amazon {
    final public class Image: RequestType {
        public typealias ResponseType = Response

        public var method: HTTPMethod = .get
        public var baseURL: URL = URL(string: "https://www.amazon.co.jp/")!
        public var path: String = "s"
        public var parameters: Parameters?
        public var encoding: ParameterEncoding = URLEncoding.queryString

        init(searchText: String) {
            self.parameters = [
                "k": searchText,
                "i": "digital-music"
            ]
        }

        public class Response: Codable, Identifiable {
            public let imageURL: URL

            internal init?(document: XMLElement) {
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
         let results = try regex().matches(in: self, range: NSRange(self.startIndex..., in: self))
         return results.map {
             String(self[Range($0.range, in: self)!])
         }
     }

     func matching(pattern regexPattern: String) throws -> [String] {
         return try self.matching(expression: NSRegularExpression(pattern: regexPattern))
     }
 }
