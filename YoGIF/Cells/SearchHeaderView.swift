import UIKit
import QuartzCore
import AsyncDisplayKit

class SearchHeaderView: UICollectionReusableView, UITextFieldDelegate {
    let searchBar = UITextField()
    var mode = 0
    weak var delegate: SearchViewController?

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.setup()
    }

    func setup() {
        self.backgroundColor = UIColor(white: 0, alpha: 0)

        let header = UIView()
        header.layer.cornerRadius = 5
        header.backgroundColor = .white
        self.addSubview(header)
        header.translatesAutoresizingMaskIntoConstraints = false
        header.heightAnchor.constraint(equalToConstant: 36).isActive = true
        header.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        header.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
        header.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        header.clipsToBounds = true

        header.addSubview(searchBar)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.topAnchor.constraint(equalTo: header.topAnchor).isActive = true
        searchBar.leftAnchor.constraint(equalTo: header.leftAnchor).isActive = true
        searchBar.rightAnchor.constraint(equalTo: header.rightAnchor).isActive = true
        searchBar.bottomAnchor.constraint(equalTo: header.bottomAnchor).isActive = true
        searchBar.placeholder = "Search"
        searchBar.autocorrectionType = .no
        searchBar.autocapitalizationType = .none
        searchBar.clearButtonMode = .always

        let icon = UIImageView(image: #imageLiteral(resourceName: "search"))
        icon.frame = CGRect(x: 10, y: -5, width: 30, height: 15)
        icon.contentMode = .scaleAspectFit
        searchBar.leftView = icon
        searchBar.leftViewMode = .always
        searchBar.returnKeyType = .search
        searchBar.delegate = self
    }

    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        if let delegate = delegate {
            delegate.onSearch("")
        }
        return true
    }

    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        if mode == 0 {
            return true
        }
        if let text = textField.text {
            var clearText = text
            if string == "" {
                // user has removed something
                if text.characters.count >= 1 {
                    clearText = text.substring(to: text.index(before: text.endIndex))
                }
            } else {
                clearText = text + string
            }

            if let delegate = delegate {
                delegate.onSearch(clearText)
            }
        }
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let delegate = delegate, let text = textField.text {
            delegate.onSearch(text)
            textField.resignFirstResponder()
        }
        return true
    }
}
