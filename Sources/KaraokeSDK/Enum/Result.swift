//
//  Result.swift
//  
//
//  Created by devonly on 2022/01/01.
//

import Foundation

public enum Result {
    public enum Login: String, CaseIterable, Codable {
        /// ログイン成功
        case success    = "DAM_CONNECT_OK"
        /// ログイン失敗
        case failure    = "DAM_CONNECT_ERROR"
        /// QRコード有効期限切れ
        case timeout    = "DAM_QR_VALID_TIMEOUT"
        /// ペアリングタイムアウト
        case pairing    = "DAM_PAIRING_TIMEOUT"
    }
    
    public enum Logout: String, CaseIterable, Codable {
        /// ログアウト成功
        case success    = "DAM_SEPARATE_OK"
        /// QRコード有効期限切れ
        case timeout    = "DAM_QR_VALID_TIMEOUT"
        /// ペアリングタイムアウト
        case pairing    = "DAM_PAIRING_TIMEOUT"
    }
    
    public enum Remocon: String, CaseIterable, Codable {
        /// リモコン送信OK
        case success    = "REMOCONSEND_OK"
        /// リモコン送信NG
        case failure    = "REMOCONSEND_TIMEOUT"
    }
    
    public enum Request: String, CaseIterable, Codable {
        /// 予約成功
        case success    = "DAM_CONNECT_OK"
        /// 予約失敗
        case failure    = "DAM_SEND_ERROR"
    }
    
    public enum Picture: String, CaseIterable, Codable {
        /// 画像送信成功
        case success    = "PICTURESEND_OK"
        /// 画像送信失敗
        case failure    = "PICTURESEND_ERROR"
        /// ログイン失敗
        case unknown    = "DAM_CONNECT_ERROR_R"
    }
}
