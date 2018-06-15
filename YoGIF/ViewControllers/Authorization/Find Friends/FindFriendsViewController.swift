import UIKit

class FindFriendsViewController: UIViewController {
    
    let photo = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @objc func goBack() {
        self.navigationController?.popViewController(animated: true)
    }

    @objc func nextTapped() {
        let vc = HowItWorksViewController()
        self.navigationController?.pushViewController(vc, animated: true)

    }

    @objc func skipTapped() {
        nextTapped()
    }

    @objc func onPrivacyTap() {
        guard let url = URL(string: "http://www.google.com") else {
            return //be safe
        }

        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
}
