//
//  AFSessionProgressDelegate.swift
//  
//
//  Created by devonly on 2022/01/25.
//

import Foundation
import Alamofire

public protocol AFSesseionProgressDelegate: AnyObject {
    func sessionIsRunning()
    func sessionIsTerminated()
}

extension AFSesseionProgressDelegate {
    func sessionIsRunning() {
        print("SESSION IS RUNNING")
    }
    
    func sessionIsTerminated() {
        print("SESSION IS TERMINATED")
    }
}
