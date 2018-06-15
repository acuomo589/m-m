import UIKit

extension GifInfoViewController {
    func setupUI() {
        //self.automaticallyAdjustsScrollViewInsets = false

        if let nav = self.navigationController, nav.viewControllers.count > 1 {
            let yoBackButton = UIButton()
            yoBackButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
            yoBackButton.setImage(#imageLiteral(resourceName: "backArrowWhiteBold"), for: .normal)
            yoBackButton.sizeToFit()
            yoBackButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
            yoBackButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
            yoBackButton.contentHorizontalAlignment = .left
            let myCustomBackButtonItem = UIBarButtonItem(customView: yoBackButton)
            self.navigationItem.leftBarButtonItem  = myCustomBackButtonItem
        }

        if let visual = self.visual, let username = visual.username, let myUsername = User.myUsername() {
            if username == myUsername {
                editButton = UIBarButtonItem(image: #imageLiteral(resourceName: "gifEdit"), style: .plain, target: self, action: #selector(onEditTapped))
                let deleteButton = UIBarButtonItem(image: #imageLiteral(resourceName: "gifDelete"), style: .plain, target: self, action: #selector(onDeleteGifTapped))
                self.navigationItem.rightBarButtonItems = [deleteButton, editButton]
            }
        }

        let navHeader = UIView()
        navHeader.frame = CGRect(x: 0, y: 0, width: 150, height: 30)
        navHeader.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerXAnchor.constraint(equalTo: navHeader.centerXAnchor, constant: 0).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: navHeader.centerYAnchor, constant: 0).isActive = true
        titleLabel.font = UIFont(name: "Helvetica-Bold", size: 20)
        titleLabel.textColor = .white
        self.navigationItem.titleView = navHeader
        
        let background = UIImageView()
        self.view.addSubview(background)
        background.translatesAutoresizingMaskIntoConstraints = false
        background.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        background.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: -5).isActive = true
        background.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 5).isActive = true
        background.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        background.backgroundColor = .lightGray
        background.image = #imageLiteral(resourceName: "loginBg")
        background.contentMode = .scaleAspectFill
        background.clipsToBounds = true

        let scrollView = UIScrollView()
        scrollView.backgroundColor = .clear
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(scrollView)
        scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.bottomLayoutGuide.topAnchor, constant: 0).isActive = true
        scrollView.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor).isActive = true
        scrollView.layer.borderWidth = 1

        gifView.setup(sv: scrollView)
        gifView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16).isActive = true
        self.gifInfoHeightConstraint = gifView.heightAnchor.constraint(equalToConstant: GifView.gifViewHeight() + 50)
        self.gifInfoHeightConstraint.isActive = true
        gifView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        gifView.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 10).isActive = true
        gifView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 20).isActive = true
        gifView.viewController = self
    }
}
