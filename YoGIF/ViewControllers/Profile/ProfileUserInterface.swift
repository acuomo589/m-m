import UIKit

extension ProfileViewController {

    func setupUI() {
        self.view.backgroundColor = AppConstants.colorDarkBlue

        if self.isMe() {
            let settings = UIBarButtonItem(image: #imageLiteral(resourceName: "settings"),
                    style: .plain,
                    target: self,
                    action: #selector(settingsTapped))
            self.navigationItem.rightBarButtonItem = settings
        }

        let navHeader = UIView()
        navHeader.frame = CGRect(x: 0, y: 0, width: 150, height: 30)
        navHeader.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerXAnchor.constraint(equalTo: navHeader.centerXAnchor, constant: 0).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: navHeader.centerYAnchor, constant: 0).isActive = true
        titleLabel.font = UIFont(name: "Helvetica-Bold", size: 20)
        titleLabel.textColor = .white
        titleLabel.text = ""
        self.navigationItem.titleView = navHeader

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

        let background = UIImageView()
        self.view.addSubview(background)
        background.translatesAutoresizingMaskIntoConstraints = false
        background.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        background.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: -5).isActive = true
        background.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 5).isActive = true
        background.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -50).isActive = true
        background.backgroundColor = .lightGray
        background.image = #imageLiteral(resourceName: "loginBg")
        background.contentMode = .scaleAspectFill
        background.clipsToBounds = true

        let screenWidth = UIScreen.main.bounds.width
//        let screenHeight = UIScreen.main.bounds.height
        let cellSize = screenWidth * 0.3333
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: cellSize, height: cellSize)
        layout.scrollDirection          = .vertical
        layout.minimumInteritemSpacing  = 0
        layout.minimumLineSpacing       = 0
        layout.sectionInset             = UIEdgeInsets(top: 0, left: 0, bottom: 80, right: 0)

        self.collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        self.view.addSubview(collectionView)
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false

        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        collectionView.isPagingEnabled = false
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.tag = 1
        self.collectionView.backgroundColor = UIColor(white: 0, alpha: 0)
        self.collectionView.register(GifListCollectionCell.self, forCellWithReuseIdentifier: self.reuseId)
        self.collectionView.register(ProfileHeaderView.self,
                forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
                withReuseIdentifier: self.headerReuseId)
        self.collectionView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
        self.collectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        self.collectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        self.collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true

    }
}
