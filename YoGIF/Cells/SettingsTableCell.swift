import UIKit

class SettingsTableCell: UITableViewCell {
    let arrowImage          = UIImageView(image: #imageLiteral(resourceName: "rightArrowWhite"))
    let settingSwitch       = UISwitch()
    let settingText    = UILabel()

    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.backgroundColor = UIColor(white: 0, alpha: 0)
        self.contentView.backgroundColor = UIColor(white: 0, alpha: 0)

        settingText.translatesAutoresizingMaskIntoConstraints = false
        settingText.font = UIFont(name: "Helvetica", size: 16)
        settingText.numberOfLines = 2
        settingText.text = "Text"
        settingText.textColor = .white
        contentView.addSubview(settingText)
        settingText.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 15).isActive = true
        settingText.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor, constant: 0).isActive = true

        let imageSize = CGFloat(30)
        arrowImage.translatesAutoresizingMaskIntoConstraints = false
        arrowImage.layer.masksToBounds = true
        contentView.addSubview(arrowImage)
        arrowImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15).isActive = true
        arrowImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        arrowImage.heightAnchor.constraint(equalToConstant: imageSize).isActive = true
        arrowImage.widthAnchor.constraint(equalToConstant: imageSize).isActive = true
        arrowImage.contentMode = .scaleAspectFit

        contentView.addSubview(settingSwitch)
        settingSwitch.translatesAutoresizingMaskIntoConstraints = false
        settingSwitch.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 0).isActive = true
        settingSwitch.rightAnchor.constraint(equalTo: arrowImage.rightAnchor, constant: 0).isActive = true
        settingSwitch.addTarget(self, action: #selector(switchChanged), for: .valueChanged)
    }

    @objc func switchChanged() {

    }

    func followButtonTapped() {
        print("tapped")
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
