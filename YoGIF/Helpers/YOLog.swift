//
//  YOLog.swift
//  YoGIF Staging
//
//  Created by Orphan on 4/23/18.
//  Copyright © 2018 YoGIF. All rights reserved.
//

import UIKit
import os.log

class YOLog: NSObject {
    
    static func Log(error: CVarArg, from: String) { //EXAMPLE: Log(error: error.localized, from: "getUser")
        os_log("%@: %@", type: .error, from , error)
    }
    
    static func Log(info: CVarArg, from: String) {
        os_log("%@: %@", type: .info, from , info)
    }
    
    static func Log(message: CVarArg, from: String, category: String) { //EXAMPLE: Log(error: error.localized, from: "getUser", category: "network")
        let log = OSLog(subsystem: "com.test.plist", category: category)
        os_log("%@: %@", log: log, type: .debug, from , message)
    }
}
