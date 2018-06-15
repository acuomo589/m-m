import Foundation
import UIKit

class SimpleAlert {
    @discardableResult static func showAlert(title: String? = nil, alert: String, delegate: UIViewController) -> UIAlertController {
        let titleString: String
        if let title = title {
            titleString = title
        } else {
            titleString = ""
        }
        let alertController = UIAlertController(title: titleString, message: alert, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
        delegate.present(alertController, animated: true, completion: nil)
        return alertController
    }

    @discardableResult static func showInviteOffer(_ type: ShareType, title: String? = nil, videoUid: String? = nil, message: String, delegate: UIViewController, dismissAfter: Bool) -> UIAlertController? {
        switch type {
        case .likePost:
            if UserDefaults.standard.bool(forKey: AppConstants.nsudShareAlertLikeMeShown) == true {
                return nil
            } else {
                UserDefaults.standard.set(true, forKey: AppConstants.nsudShareAlertLikeMeShown)
            }
            break;

        case .toStore:
            if UserDefaults.standard.bool(forKey: AppConstants.nsudShareAlertPerfectShown) == true {
                return nil
            } else {
                UserDefaults.standard.set(true, forKey: AppConstants.nsudShareAlertPerfectShown)
            }
        }

        let alertController = UIAlertController(title: message, message: "", preferredStyle: UIAlertControllerStyle.alert)
        let inviteAction = UIAlertAction(title: "Invite", style: .default) { _ in
            UserEngagement.showShareSheet(type, videoUid: videoUid, delegate: delegate, dismissAfter: dismissAfter)
        }
        let rejectAction = UIAlertAction(title: "Close", style: .cancel, handler: {_ in
            delegate.dismiss(animated: true)
        })
        alertController.addAction(inviteAction)
        alertController.addAction(rejectAction)
        delegate.present(alertController, animated: true, completion: nil)
        return alertController
    }
    
    static func showAlert(title: String, alert: String, actionTitles:String... , delegate: UIViewController, callback: @escaping (_ actionNumber: Int) -> Void) {
        let alertController = UIAlertController(title: title, message: alert, preferredStyle: .alert)
        
        for i in 0...actionTitles.count - 1 {
            let actionTitle = actionTitles[i]
            let action = UIAlertAction(title: actionTitle, style: .default, handler: { (action) in
                alertController.dismiss(animated: true, completion: nil)
                callback(i)
                })
            alertController.addAction(action)
        }
        
        delegate.present(alertController, animated: true, completion: nil)
        
    }

}

enum ShareType {
    case likePost
    case toStore
}

class UserEngagement {
    static func showShareSheet(_ type: ShareType, videoUid: String? = nil, delegate: UIViewController?, dismissAfter: Bool) {
        var text: String
        switch type {
        case .likePost:
            if let videoUid = videoUid, let userId = User.me()?.username {
                text = "Like my post on mīm! mim://gif/\(userId)/\(videoUid)"
                print(text)
            } else {
                text = "Like my post on mīm! https://apple.co/2Hm8zk5"
            }

        case .toStore:
            text = "You’re perfect for mīm! https://apple.co/2Hm8zk5"
        }
        let textToShare = [text]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        if let vc = delegate {
            activityViewController.popoverPresentationController?.sourceView = vc.view
        }
        activityViewController.excludedActivityTypes = [UIActivityType.airDrop]
        delegate?.present(activityViewController, animated: true, completion: nil)
        if dismissAfter {
            activityViewController.completionWithItemsHandler = { (activityType, completed:Bool, returnedItems:[Any]?, error: Error?) in
                if completed {
                    delegate?.dismiss(animated: true)
                }
            }
        }
    }
}
