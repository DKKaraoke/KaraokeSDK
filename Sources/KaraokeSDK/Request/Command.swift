//
//  Command.swift
//  
//
//  Created by devonly on 2021/12/24.
//

import Foundation
import Alamofire

public final class Command: RequestType {
    public typealias ResponseType = Response

    public var method: HTTPMethod = .post
    public var path: String = "DkDamRemoconSendServlet"
    public var parameters: Parameters?

    init(command: DKCommand) {
        self.parameters = [
            "remoconCode": command.rawValue
        ]
    }

    public struct Response: Codable {
        public let QRcode: String
        public let appVer: String
        public let cdmNo: String
        public let deviceId: String
        public let deviceNm: String
        public let lastSendTerm: String
        public let osVer: String
        public let remoconCode: String
        public let remoconFlg: String
        public let result: DKResult
        public let songCertification: String
        public let substituteBoot: String
    }
}

public enum DKCommand: String, CaseIterable {
    case 演奏停止 = "00"
    case スタート = "01"
    case 早戻し = "1A"
    case 一時停止 = "1B"
    case 早送り = "1C"
    case DAM = "1D"
    case 原曲キー = "1E"
    case キープラス = "04"
    case キーマイナス = "05"
    case テンポプラス = "20"
    case テンポマイナス = "21"
    case ワイプ = "0C"
    case ルビ = "06"
    case バックコーラス = "D0"
    case ガイドメロディー = "0D"
    case テロップ表示 = "BB"
    case テロップサイズ = "67"
    case 見えるガイドメロディ = "1F"
    case ガイドボーカル = "26"
}
