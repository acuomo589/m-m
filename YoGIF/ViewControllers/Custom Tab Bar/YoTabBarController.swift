import UIKit

class YoTabBarController: UITabBarController, UITabBarControllerDelegate {
    private let button = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.delegate = self

        button.setImage(UIImage(named: "tabIconYo"), for: .normal)
        button.sizeToFit()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(openCamera), for: .touchUpInside)

        view.addSubview(button)
        if UIScreen.main.nativeBounds.height == 2436 {
            tabBar.centerYAnchor.constraint(equalTo: button.centerYAnchor, constant: 18).isActive = true
        } else {
            tabBar.centerYAnchor.constraint(equalTo: button.centerYAnchor, constant: 2).isActive = true
        }
        tabBar.centerXAnchor.constraint(equalTo: button.centerXAnchor).isActive = true
    }
    func toggleButtonVisibility (){
       button.isHidden = !button.isHidden
    }
    func tabBarController(_ tabBarController: UITabBarController,
                          shouldSelect viewController: UIViewController) -> Bool {
        if self.viewControllers?.index(of: viewController) == 2 {
            return false
        } else {
            return true
        }
    }

    @objc func openCamera() {
        let vc = UINavigationController(rootViewController: CameraViewController())
        self.present(vc, animated: true, completion: nil)
    }

}
