//
//  TimerHelper.swift
//  YoGIF
//
//  Created by Artem Misesin on 2/8/18.
//  Copyright © 2018 YoGIF. All rights reserved.
//

import UIKit
import AWSCognitoAuth
import SVProgressHUD

class TimerHelper {
    
    static let shared = TimerHelper()
    
    func startTimer() {
        let date = Date().addingTimeInterval(30)
        let timer = Timer(fireAt: date, interval: 0, target: self, selector: #selector(inviteOffer), userInfo: nil, repeats: false)
        RunLoop.main.add(timer, forMode: RunLoopMode.commonModes)
    }
    
    @objc func inviteOffer() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if let currentVC = appDelegate.getCurrentViewController() {
            var topController = UIViewController()

            // try to get VC from tab bar
            if let currentVC = currentVC as? YoTabBarController,
                let activeTabBarVC = currentVC.selectedViewController {
                if let activeTabBarVC = activeTabBarVC as? UINavigationController {
                    topController = activeTabBarVC.topViewController ?? UIViewController()
                } else {
                    topController = activeTabBarVC
                }
            } else if let currentVC = currentVC as? UINavigationController {
                topController = currentVC.topViewController ?? UIViewController()
            } else {
                topController = currentVC
            }
            print(String(describing: topController))
            
            guard topController is CaptionViewController || topController is CameraViewController || topController is VideoViewController || topController is MediaSyncViewController else {
                if !SVProgressHUD.isVisible() {
                    if User.isAuthorized() {
                        topController.showEngagement()
                    }
                }
                return
            }
            self.startTimer()
        }
    }
    
    static func isInCurrentWeek(date : Date) -> Bool
    {
        return Calendar.current.isDate(date, equalTo: Date(), toGranularity: .weekOfYear)
    }
    
}
