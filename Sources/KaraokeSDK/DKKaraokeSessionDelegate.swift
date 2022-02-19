//
//  DKKaraokeSessionDelegate.swift
//
//
//  Created by devonly on 2021/12/24.
//

import Foundation

public protocol DKKaraokeSessionDelegate: AnyObject {
    func sessionIsRunning()
    func sessionIsTerminated()
    func failedWithDKError(error: DKError)
}
