//
//  Result.swift
//  
//
//  Created by devonly on 2022/01/01.
//

import Foundation

public enum DKResult: String, Codable, CaseIterable {
    /// ログイン成功
    case successLogin       = "LOGIN_OK"
    /// ログイン失敗
    case failureLogin       = "AUTHENTICATE_ERROR"
    /// ログイン成功
    case successConnect     = "DAM_CONNECT_OK"
    /// ログイン失敗
    case failureConnect     = "DAM_CONNECT_ERROR"
    /// QRコード有効期限切れ
    case timeoutConnect     = "DAM_QR_VALID_TIMEOUT"
    /// ペアリングタイムアウト
    case timeoutPairing     = "DAM_PAIRING_TIMEOUT"
    /// ログアウト成功
    case successDisconnect  = "DAM_SEPARATE_OK"
    /// リモコン送信OK
    case successRemocon     = "REMOCONSEND_OK"
    /// リモコン送信NG
    case failureRemocon     = "REMOCONSEND_TIMEOUT"
    /// 予約失敗
    case failureRequest     = "DAM_SEND_ERROR"
    /// 画像送信成功
    case successPicture     = "PICTURESEND_OK"
    /// 画像送信失敗
    case failurePicture     = "PICTURESEND_ERROR"
    /// ログイン失敗
    case unknown            = "DAM_CONNECT_ERROR_R"
}
