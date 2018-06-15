//
//  Analytics.swift
//  YoGIF
//
//  Created by Artem Misesin on 2/8/18.
//  Copyright © 2018 YoGIF. All rights reserved.
//

import Foundation
import Firebase

struct AnalyticsConstants {
    
    static let nameKey = "name"
    static let screenOpened = "Screen Opened"
    // MARK: More to come
    
}

class YoAnalytics {

    
    static func trackEvent(_ name: String, properties: [String: String]) {
        //Mixpanel.track(event: name, properties: properties)
    }
    
    static func timeEvent(_ name: String) {
        //Mixpanel.time(event: name)
    }

    static func setUserId(_ id: String) {
        Analytics.setUserID(id)
    }

    static func setUserData(_ data: String, forName: String) {
        Analytics.setUserProperty(data, forName: forName)
    }
    
}
