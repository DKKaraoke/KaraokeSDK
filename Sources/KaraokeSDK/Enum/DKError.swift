//
//  DKError.swift
//
//
//  Created by devonly on 2022/01/01.
//

import Alamofire
import Foundation

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
            case let .responseValidationFailed(failure):
                switch failure {
                    case .failureLogin:
                        "ログイン失敗"
                    case .failureConnect:
                        "ペアリング失敗"
                    case .timeoutConnect:
                        "QRコード有効期限切れ"
                    case .timeoutPairing:
                        "ペアリング失敗"
                    case .failureRemocon:
                        "リクエスト失敗"
                    case .failureRequest:
                        "楽曲予約失敗"
                    case .failurePicture:
                        "画像転送失敗"
                    case .unknown:
                        "不明なエラー"
                    case .failureParam:
                        "ログイン失敗"
                    default:
                        nil
                }
            case .responseDataCorrupted:
                "認識できないデータ"
            case .authenticationFailed:
                "認証失敗"
            case .qrCodeGenerationFailed:
                "QRコード生成失敗"
            case .unknownErrorFailed:
                "不明なエラー"
            case .couldNotFoundResoureFailed:
                "リソースが見つかりませんでした"
        }
    }

    public var failureReason: String? {
        switch self {
            case let .responseValidationFailed(failure):
                switch failure {
                    case .failureLogin:
                        "ユーザ名かパスワードまたはその両方が間違っています."
                    case .failureConnect:
                        "DAMと接続できませんでした."
                    case .timeoutConnect:
                        "DAMと接続できませんでした. サーバーメンテナンスの可能性があります."
                    case .timeoutPairing:
                        "ペアリングの有効期限が切れました. 再ペアリングしてください."
                    case .failureRemocon:
                        "リモコンの送信に失敗しました."
                    case .failureRequest:
                        "楽曲予約に失敗しました."
                    case .failurePicture:
                        "画像転送に失敗しました."
                    case .unknown:
                        "エラーが発生しました."
                    case .failureParam:
                        "ユーザ名またはパスワードが短すぎます. ユーザ名とパスワードは半角英数字8文字以上です."
                    default:
                        nil
                }
            case .responseDataCorrupted:
                "認識できない形式のデータを受け取りました. アプリのアップデートが必要な可能性があります."
            case .authenticationFailed:
                "認証に失敗しました."
            case .qrCodeGenerationFailed:
                "QRコードの生成に失敗しました. フォーマットが変更された可能性があります."
            case .unknownErrorFailed:
                "未知のエラーが発生しました."
            case .couldNotFoundResoureFailed:
                "指定された楽曲のデータが見つかりませんでした."
        }
    }
}
