//
//  StringAcceptable.swift
//  
//
//  Created by devonly on 2022/01/24.
//

import Foundation

@propertyWrapper
public struct StringAcceptable<T: LosslessStringConvertible> where T: Codable {
    public var wrappedValue: T
    
    public init(wrappedValue: T) {
        self.wrappedValue = wrappedValue
    }
}

extension StringAcceptable: Codable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(String(wrappedValue))
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let wrappedValue = try? container.decode(T.self) {
            self.wrappedValue = wrappedValue
            return
        }
        let stringValue = try container.decode(String.self)
        guard let rawValue = T(rawValue: stringValue)
        else {
            throw DecodingError.typeMismatch(T.self, .init(codingPath: container.codingPath, debugDescription: "Expected to decode `\(T.self)` but found a `\(stringValue)` instead.", underlyingError: nil))
        }
        self.wrappedValue = rawValue
    }
}

extension LosslessStringConvertible {
    init?(rawValue: String) {
        if Self.Type.self == Bool.Type.self {
            if let intValue = Int(rawValue) {
                switch intValue {
                    case 0:
                        self.init("false")
                    default:
                        self.init("true")
                }
            } else {
                self.init(rawValue)
            }
        } else {
            self.init(rawValue)
        }
    }
}

extension Bool {
    init?(_ rawValue: LosslessStringConvertible) {
        guard let stringValue = rawValue as? String,
              let intValue = Int(stringValue)
        else {
            return nil
        }
        self.init(intValue != 0)
    }
}

@propertyWrapper
public struct NullAcceptable<T: Codable> where T: LosslessStringConvertible {
    public var wrappedValue: T?
    
    public init(wrappedValue: T?) {
        self.wrappedValue = wrappedValue
    }
}

extension NullAcceptable: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch wrappedValue {
            case .some(let value):
                try container.encode(value)
            case .none:
                try container.encodeNil()
        }
    }
}

extension NullAcceptable: Equatable where T: Equatable { }

extension NullAcceptable: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        guard let stringValue = try? container.decode(String.self),
              let rawValue = T(stringValue)
        else {
            wrappedValue = nil
            return
        }
        wrappedValue = rawValue
    }
}

extension KeyedDecodingContainer {
    public func decode<T>(_ type: NullAcceptable<T>.Type, forKey key: KeyedDecodingContainer<K>.Key) throws -> NullAcceptable<T> where T: Decodable {
        return try decodeIfPresent(NullAcceptable<T>.self, forKey: key) ?? NullAcceptable<T>(wrappedValue: nil)
    }
}
