//
//  QRCode.swift
//  
//
//  Created by devonly on 2022/01/21.
//

import Foundation

public struct QRCode {
    /// ローカルIPアドレス
    public let ip: String
    /// DAM筐体のシリアルナンバー
    public let serial: String
    /// UNIXタイムスタンプ
    public let timestamp: Int
    public let publishedTime: String
    
    public init(code: String) throws {
        let formatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.timeZone = TimeZone.current
            formatter.dateFormat = "HH:mm:ss"
            return formatter
        }()
        let bytes: [String] = code.chunked(by: 2)
        // Validation
        // 文字列が32文字かつ、英数字のみで構成されている
        if code.rangeOfCharacter(from: CharacterSet.alphanumerics.inverted) != nil || bytes.count != 16 {
            throw DKError.qrCodeGenerationFailed
        }
        
        self.ip = [bytes[0], bytes[4], bytes[8], bytes[12]]
            .compactMap({ UInt8($0, radix: 16) }).map({ String(format: "%03d", $0) }).joined(separator: ".")
        self.serial = [bytes[9], bytes[11], bytes[13], bytes[15], bytes[1], bytes[3], bytes[5], bytes[7]]
            .joined(separator: "")
        self.timestamp = Int([bytes[14], bytes[10], bytes[6], bytes[2]].joined(separator: ""), radix: 16)!
        self.publishedTime = formatter.string(from: Date(timeIntervalSince1970: Double(self.timestamp)))
    }
    
    public var code: String {
        let ip: [String] = self.ip.split(separator: ".").compactMap({ UInt8($0) }).compactMap({ String(format: "%02X", $0)})
        let serial: [String] = self.serial.chunked(by: 2)
        let timestamp: [String] = String(format: "%08X", Int(Date().timeIntervalSince1970)).chunked(by: 2)
        return [
            ip[0],
            serial[4],
            timestamp[3],
            serial[5],
            ip[1],
            serial[6],
            timestamp[2],
            serial[7],
            ip[2],
            serial[0],
            timestamp[1],
            serial[1],
            ip[3],
            serial[2],
            timestamp[0],
            serial[3]
        ]
            .joined(separator: "")
    }
}

internal extension String {
    func chunked(by chunkSize: Int) -> [String] {
        let array: [String] = self.map({ String($0) })
        return stride(from: 0, to: array.count, by: chunkSize).map {
            Array(array[$0..<Swift.min($0 + chunkSize, array.count)]).joined(separator: "").uppercased()
        }
    }
}
