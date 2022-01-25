//
//  StringAcceptable.swift
//  
//
//  Created by devonly on 2022/01/24.
//

import Foundation

@propertyWrapper
public struct StringAcceptable<T: Codable> {
    public var wrappedValue: T
    
    public init(wrappedValue: T) {
        self.wrappedValue = wrappedValue
    }
}

extension StringAcceptable: Encodable {
    public func encode(to encoder: Encoder) throws where T == Optional<Bool> {
        var container = encoder.singleValueContainer()
        switch wrappedValue {
            case .some(let value):
                try container.encode(value)
            case .none:
                try container.encodeNil()
        }
    }
    
    public func encode(to encoder: Encoder) throws where T == Bool {
        var container = encoder.singleValueContainer()
        try container.encode(wrappedValue)
    }
}


extension StringAcceptable: Equatable where T: Equatable { }

extension StringAcceptable: Decodable {
    public init(from decoder: Decoder) throws where T == Optional<Bool> {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            wrappedValue = try container.decode(T.self)
        } else {
            wrappedValue = nil
        }
    }
    
    public init(from decoder: Decoder) throws where T == Bool {
        let container = try decoder.singleValueContainer()
        wrappedValue = try container.decode(T.self)
    }
}
