import UIKit
import QuartzCore
import AsyncDisplayKit

class MoodCollectionCell: UICollectionViewCell {
    let title = UILabel()
    let background = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(container)
        container.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10).isActive = true
        container.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10).isActive = true
        container.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 10).isActive = true
        container.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -10).isActive = true
        container.backgroundColor = .clear
//        container.layer.cornerRadius = 15
        container.clipsToBounds = true

        background.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(background)
        background.topAnchor.constraint(equalTo: container.topAnchor, constant: 0).isActive = true
        background.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 0).isActive = true
        background.rightAnchor.constraint(equalTo: container.rightAnchor, constant: 0).isActive = true
        background.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: 0).isActive = true
        background.backgroundColor = .clear
        background.contentMode = .scaleAspectFill

        title.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(title)
        title.centerXAnchor.constraint(equalTo: container.centerXAnchor, constant: 0).isActive = true
        title.centerYAnchor.constraint(equalTo: container.centerYAnchor, constant: 0).isActive = true
        title.font = UIFont(name: "Helvetica-Bold", size: 32)
        title.textColor = .white
        title.text = "Title"
    }

//    func showImage(newUrl: String) {
////        self.url = newUrl
////        self.loadImage(urlString: url)
//    }
//
//    func loadImage(urlString: String) {
////        if urlString != "" {
////            FileDownloader().downloadImage(url: URL(string: "\(urlString)")!) { (image, error) in
////                if error == nil {
////                    if urlString == self.url {
////                        self.mainImage.image = image
////                    }
////
////                } else {
////                    NSLog("download failed")
////                }
////            }
////        }
//    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }

}
