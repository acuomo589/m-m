import UIKit

extension GifsListViewController: UICollectionViewDelegateFlowLayout,
        UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.gifs.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.reuseId,
                for: indexPath) as! GifListCollectionCell
        let gif = self.gifs[indexPath.row]
        if self.previewImages.count > indexPath.row {
            cell.photo.image = self.previewImages[indexPath.row]
        } else {
            if let username = gif.username {
                GeneralMethods.loadImage(visual: gif, username: username, callback: { (image) in
                    cell.photo.image = image
                })
            }
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = GifInfoViewController()
//        vc.titleValue = moodTag
        vc.titleLabel.text = moodTag
        vc.visual = self.gifs[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
