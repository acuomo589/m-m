import UIKit
import QuartzCore
import AsyncDisplayKit

class GifListCollectionCell: UICollectionViewCell {
    let photo = UIImageView(image: #imageLiteral(resourceName: "emptyUser"))

    override init(frame: CGRect) {
        super.init(frame: frame)

        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(container)
        container.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 1).isActive = true
        container.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -1).isActive = true
        container.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 1).isActive = true
        container.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -1).isActive = true
        container.backgroundColor = .white
        container.clipsToBounds = true

        photo.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(photo)
        photo.image = nil
        photo.topAnchor.constraint(equalTo: container.topAnchor, constant: 0).isActive = true
        photo.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 0).isActive = true
        photo.rightAnchor.constraint(equalTo: container.rightAnchor, constant: 0).isActive = true
        photo.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: 0).isActive = true
        photo.backgroundColor = AppConstants.emptyVideoHolder
        photo.contentMode = .scaleAspectFill
    }

    func showImage(newUrl: String) {
        //        self.url = newUrl
        //        self.loadImage(urlString: url)
    }

    func loadImage(visual: Visual, username: String) {
        
        // TODO: copied code. Refactor
        let filename = visual.filename
        if let file = visual.file() {
            let asset = AVURLAsset(url: file, options: nil)
            let imgGenerator = AVAssetImageGenerator(asset: asset)
            if let cgImage = try? imgGenerator.copyCGImage(at: CMTimeMake(0, 1), actualTime: nil) {
                photo.image = UIImage(cgImage: cgImage)
            } else {
                photo.image = nil
            }
            // !! check the error before proceeding
        } else {
            let fd = FileDownloader()
            fd.downloadAwsVideo(username: username, filename: filename, isPublic: visual.isPublic) { error in
                if let error = error {
                    print(error)
                } else {
                    self.loadImage(visual: visual, username: username)
                }
             }
        }
    }
    override func prepareForReuse() {
        photo.image = nil
        super.prepareForReuse()
    }
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }

}
