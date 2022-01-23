//
//  Command.swift
//  
//
//  Created by devonly on 2021/12/24.
//

import Foundation
import Alamofire

public final class Command: RequestType {
    typealias ResponseType = Response
    
    var method: HTTPMethod = .post
    var path: String = "DkDamRemoconSendServlet"
    var parameters: Parameters

    init(command: DKCommand) {
        self.parameters = [
            "remoconCode": command.rawValue,
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
        public let result: String
        public let songCertification: String
        public let substituteBoot: String
    }
}

public enum DKCommand: String, CaseIterable {
    /// 演奏中止
    case cancel         = "00"
    /// スタートやり直し
    case start          = "01"
    /// 割り込み転送モード切り替え
    case insert         = "03"
    /// キー+
    case keyplus        = "04"
    /// キー-
    case keyminus       = "05"
    /// ルビ
    case unknown        = "06"
    /// テンポ+
    case tempoplus      = "20"
    /// テンポ-
    case tempominus     = "21"
    /// ガイドボーカル
    case guidevocal     = "26"
    /// 原曲キー
    case orgkey         = "60"
    /// ガイドメロディ
    case guidemelody    = ""
    /// 予約リスト表示
    case reserved       = "0A"
    /// 早送り
    case forward        = "1A"
    /// 一時停止
    case pause          = "1B"
    /// 早戻し
    case backward       = "1C"
    /// DAM
    case dam            = "1D"
    /// 見えるガイドメロディ
    case guidebar       = "B5"
    /// 上
    case up             = "B7"
    /// 下
    case down           = "B8"
    /// 右
    case right          = "B9"
    /// 左
    case left           = "BA"
    /// DAM★ともボーカル
    case damvocal       = "F1"
}
