//
//  DKError.swift
//  
//
//  Created by devonly on 2022/01/01.
//

import Foundation
import Alamofire

public enum DKError: Error {
    case responseValidationFailed(DKResult)
    case responseDataCorrupted
    case authenticationFailed
    case qrCodeGenerationFailed
    case unknownErrorFailed
    case couldNotFoundResoureFailed
}

extension DKError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .responseValidationFailed(let failure):
            switch failure {
            case .failureLogin:
                return "ログイン失敗"
            case .failureConnect:
                return "ペアリング失敗"
            case .timeoutConnect:
                return "QRコード有効期限切れ"
            case .timeoutPairing:
                return "ペアリング失敗"
            case .failureRemocon:
                return "リクエスト失敗"
            case .failureRequest:
                return "楽曲予約失敗"
            case .failurePicture:
                return "画像転送失敗"
            case .unknown:
                return "不明なエラー"
            case .failureParam:
                return "ログイン失敗"
            default:
                return nil
            }
        case .responseDataCorrupted:
            return "認識できないデータ"
        case .authenticationFailed:
            return "認証失敗"
        case .qrCodeGenerationFailed:
            return "QRコード生成失敗"
        case .unknownErrorFailed:
            return "不明なエラー"
        case .couldNotFoundResoureFailed:
            return "リソースが見つかりませんでした"
        }
    }

    public var failureReason: String? {
        switch self {
        case .responseValidationFailed(let failure):
            switch failure {
            case .failureLogin:
                return "ユーザ名かパスワードまたはその両方が間違っています."
            case .failureConnect:
                return "DAMと接続できませんでした."
            case .timeoutConnect:
                return "DAMと接続できませんでした. サーバーメンテナンスの可能性があります."
            case .timeoutPairing:
                return "ペアリングの有効期限が切れました. 再ペアリングしてください."
            case .failureRemocon:
                return "リモコンの送信に失敗しました."
            case .failureRequest:
                return "楽曲予約に失敗しました."
            case .failurePicture:
                return "画像転送に失敗しました."
            case .unknown:
                return "エラーが発生しました."
            case .failureParam:
                return "ユーザ名またはパスワードが短すぎます. ユーザ名とパスワードは半角英数字8文字以上です."
            default:
                return nil
            }
        case .responseDataCorrupted:
            return "認識できない形式のデータを受け取りました. アプリのアップデートが必要な可能性があります."
        case .authenticationFailed:
            return "認証に失敗しました."
        case .qrCodeGenerationFailed:
            return "QRコードの生成に失敗しました. フォーマットが変更された可能性があります."
        case .unknownErrorFailed:
            return "未知のエラーが発生しました."
        case .couldNotFoundResoureFailed:
            return "指定された楽曲のデータが見つかりませんでした."
        }
    }
}
