//
//  PushNotifications.swift
//  YoGIF Staging
//
//  Created by Orphan on 4/24/18.
//  Copyright © 2018 YoGIF. All rights reserved.
//

import UIKit

class PushNotifications: NSObject {

    var pushCategory: String?
    var pushEvt: String?
    var contestTitle: String?
    
    static func send(token: String) {
        
        let path = "device/register"
        guard let uuid = UIDevice.current.identifierForVendor?.uuidString else {
            return
        }
        
        let postData = ["platform": "ios",
                        "device_token": token,
                        "device_id": uuid] as NSDictionary
        let _ = Session().sessionPushNotificationRequest(data: postData, to: path, method: "POST") { (result, error) in
            if let error = error {
                YOLog.Log(error: error.localizedDescription, from: "Save Token Error")
            } else if let res = result {
                YOLog.Log(message: res, from: "Save Token Result", category: "Push Notifications")
            } else {
                YOLog.Log(error: "Unexpected Error", from: "Save Token Error")
            }
        }
    }
    
    static func removeToken() {
        let path = "device/unregister"
        guard let uuid = UIDevice.current.identifierForVendor?.uuidString else {
            return
        }
        
        let _ = Session().sessionPushNotificationRequest(data: ["device_id": uuid], to: path, method: "POST") { (result, error) in
            if let error = error {
                YOLog.Log(error: error.localizedDescription, from: "Remove Token Error")
            } else if let res = result {
                YOLog.Log(message: res, from: "Remove Token Result", category: "Push Notifications")
            } else {
                YOLog.Log(error: "Unexpected Error", from: "Remove Token Error")
            }
        }
    }
    
    func notification(userInfo: [AnyHashable: Any]) -> PushNotifications {
        let notification = self
        guard let aps = userInfo["aps"] as? [String: Any] else {
            return notification
        }
        notification.pushCategory = aps["category"] as? String
        notification.pushEvt = aps["evt"] as? String
        if let ctitle = aps["contest_title"] as? String {
            notification.contestTitle = ctitle
        } else {
            if let pLoad = aps["payload"] as? [String:Any] {
                notification.contestTitle = pLoad["contest_title"] as? String
            }
        }
        
        return notification
    }
    
    static func save(token: String) {
        UserDefaults.standard.set(token, forKey: "DeviceToken")
    }
    
    static func deviceToken() -> String? {
        if let token = UserDefaults.standard.string(forKey: "DeviceToken") {
            return token
        } else {
            return nil
        }
    }
    
}
