import UIKit
import BMPlayer
import AsyncDisplayKit
import MessageUI

class HowItWorksViewController : UIViewController, BMPlayerDelegate, ASVideoNodeDelegate, MFMailComposeViewControllerDelegate {
    let asPlayer = ASVideoNode()

    let player = BMPlayer()
    let skipButton = UIButton()
    let playButton = UIButton()
    let isModal = false
    var isYouWon = false
    var wonContestTitle = ""
    
    override func viewDidLoad() {
        setupUI()
    }

    @objc func hide() {
        asPlayer.muted = true
        asPlayer.asset = nil
        if isYouWon {
            openMain()
        } else {
            if isModal {
                self.dismiss(animated: true, completion: nil)
            } else {
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.openApp(0)
            }
        }
    }

    func openMain() {
        if MFMailComposeViewController.canSendMail() {
            let composeVC = MFMailComposeViewController()
            composeVC.mailComposeDelegate = self
            composeVC.setToRecipients(["info@mim-app.com"])
            composeVC.setSubject("Contest Winner")
            composeVC.setMessageBody("Congrats on winning the contest! You are now forever a Mīm champion. We deliver contests prizes directly via PayPal. Please fill out the below information and we will process your payment within 5-7 business days.\nName:\nDate of Birth:\nPhone Number:\nPayPal Username:\nSincerely,\nThe Mīm Team", isHTML: false)
            
            // Present the view controller modally.
            self.present(composeVC, animated: true, completion: nil)
            
        } else {
            show(failure: "Can't send email from this device", with: "eMail Error")
        }
    }
    
    @objc func playVideo() {
//        guard let path = Bundle.main.path(forResource: "howTo", ofType:"mov") else {
//            debugPrint("video.m4v not found")
//            return
//        }
//        let asset = BMPlayerResource(url: URL(fileURLWithPath: path), name: "")
//        player.setVideo(resource: asset)

//        skipButton.isHidden = true
        skipButton.alpha = 0.3
        playButton.isHidden = true
        self.navigationController?.setNavigationBarHidden(true, animated: true)
//        player.play()
//        player.autoPlay()
        asPlayer.play()
    }

    func bmPlayer(player: BMPlayer, playerStateDidChange state: BMPlayerState) {
        print("did change")
    }

    func bmPlayer(player: BMPlayer, loadedTimeDidChange loadedDuration: TimeInterval, totalDuration: TimeInterval) {
        print("loaded time did change")
    }

    func bmPlayer(player: BMPlayer, playTimeDidChange currentTime: TimeInterval, totalTime: TimeInterval) {
        print("play time did change")
        if currentTime == totalTime {
            player.pause()
            hide()
        }
    }

    func bmPlayer(player: BMPlayer, playerIsPlaying playing: Bool) {
        print("is playing")
    }

    func bmPlayer(player: BMPlayer, playerOrientChanged isFullscreen: Bool) {
        print("orientation changed")
    }

    func videoDidPlay(toEnd videoNode: ASVideoNode) {
        hide()
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        User.postWinnerSendCollectPrize(title: self.wonContestTitle)
        controller.dismiss(animated: true, completion: nil)
        if isModal {
            self.dismiss(animated: true, completion: nil)
        } else {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.openApp(0)
        }
    }
}
