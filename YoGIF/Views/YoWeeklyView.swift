import Foundation
import UIKit

class YoWeeklyView: UIView {
    let container = UIView()
    let logo = UIImageView(image: #imageLiteral(resourceName: "mimLogo"))
    let title = UILabel()
    let topic = UILabel()
    let separator = UIView()
    let prize = UILabel()
    let daysLeft = UILabel()
    let button = UIButton()

    func setup(superview: UIView, topicString: String, prizeString: String, expiresString: String) {
        superview.addSubview(self)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.topAnchor.constraint(equalTo: superview.topAnchor).isActive = true
        self.leftAnchor.constraint(equalTo: superview.leftAnchor).isActive = true
        self.rightAnchor.constraint(equalTo: superview.rightAnchor).isActive = true
        self.bottomAnchor.constraint(equalTo: superview.bottomAnchor).isActive = true
        self.backgroundColor = AppConstants.colorGreen//UIColor(red:0.007, green:0.176, blue:0.254, alpha:1)

        self.addSubview(logo)
        logo.translatesAutoresizingMaskIntoConstraints = false
        logo.topAnchor.constraint(equalTo: self.topAnchor, constant: 64).isActive = true
        logo.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 35).isActive = true
        logo.widthAnchor.constraint(equalToConstant: 125).isActive = true
        logo.heightAnchor.constraint(equalToConstant: 60).isActive = true
        logo.contentMode = .scaleAspectFit

        self.addSubview(separator)
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.topAnchor.constraint(equalTo: logo.topAnchor, constant: -16).isActive = true
        separator.leftAnchor.constraint(equalTo: logo.rightAnchor, constant: 16).isActive = true
        separator.widthAnchor.constraint(equalToConstant: 1).isActive = true
        separator.heightAnchor.constraint(equalToConstant: 100).isActive = true
        separator.backgroundColor = UIColor.white

        self.addSubview(title)
        title.translatesAutoresizingMaskIntoConstraints = false
        title.topAnchor.constraint(equalTo: self.topAnchor, constant: 32).isActive = true
        title.leftAnchor.constraint(equalTo: separator.rightAnchor, constant: 16).isActive = true
        title.heightAnchor.constraint(equalToConstant: 120).isActive = true
        title.numberOfLines = 0
        title.textColor = .white
        title.font = UIFont(name: "Helvetica-Bold", size: 18)
        title.text =
        """
        Weekly
        competitions for
        the funniest
        mīm.
        """

        let topicLabel = UILabel()
        self.addSubview(topicLabel)
        topicLabel.translatesAutoresizingMaskIntoConstraints = false
        topicLabel.topAnchor.constraint(equalTo: logo.bottomAnchor, constant: 60).isActive = true
        topicLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 35).isActive = true
        topicLabel.text = "Topic"
        topicLabel.font = UIFont(name: "Helvetica-Bold", size: 18)
        topicLabel.textColor = .white
        topicLabel.numberOfLines = 0

        let topicContainer = UIView()
        topicContainer.addSubview(topic)

        topicContainer.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(topicContainer)
        topicContainer.topAnchor.constraint(equalTo: topicLabel.bottomAnchor, constant: 10).isActive = true
        topicContainer.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 30).isActive = true
        topicContainer.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -30).isActive = true
        topicContainer.bottomAnchor.constraint(equalTo: topic.bottomAnchor, constant: 15).isActive = true
        topicContainer.layer.cornerRadius = 7
        topicContainer.backgroundColor = .white

        topic.translatesAutoresizingMaskIntoConstraints = false
        topic.topAnchor.constraint(equalTo: topicContainer.topAnchor, constant: 15).isActive = true
        topic.leftAnchor.constraint(equalTo: topicContainer.leftAnchor, constant: 10).isActive = true
        topic.rightAnchor.constraint(equalTo: topicContainer.rightAnchor, constant: -10).isActive = true
        topic.text = topicString
        topic.font = UIFont(name: "Helvetica", size: 18)
        topic.textColor = .black
        topic.numberOfLines = 0

        let prizeLabel = UILabel()
        self.addSubview(prizeLabel)
        prizeLabel.translatesAutoresizingMaskIntoConstraints = false
        prizeLabel.topAnchor.constraint(equalTo: topicContainer.bottomAnchor, constant: 32).isActive = true
        prizeLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 35).isActive = true
        prizeLabel.text = "Prize"
        prizeLabel.font = UIFont(name: "Helvetica-Bold", size: 18)
        prizeLabel.textColor = .white
        prizeLabel.numberOfLines = 0

        let prizeContainer = UIView()
        prizeContainer.addSubview(prize)
        prizeContainer.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(prizeContainer)
        prizeContainer.topAnchor.constraint(equalTo: prizeLabel.bottomAnchor, constant: 5).isActive = true
        prizeContainer.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 30).isActive = true
        prizeContainer.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -30).isActive = true
        prizeContainer.bottomAnchor.constraint(equalTo: prize.bottomAnchor, constant: 15).isActive = true
//        prizeContainer.heightAnchor.constraint(equalToConstant: 55).isActive = true
        prizeContainer.layer.cornerRadius = 7
        prizeContainer.backgroundColor = .white

        prizeContainer.addSubview(prize)
        prize.translatesAutoresizingMaskIntoConstraints = false
        prize.topAnchor.constraint(equalTo: prizeContainer.topAnchor, constant: 15).isActive = true
        prize.leftAnchor.constraint(equalTo: prizeContainer.leftAnchor, constant: 10).isActive = true
        prize.rightAnchor.constraint(equalTo: prizeContainer.rightAnchor, constant: 10).isActive = true
        prize.text = prizeString
        prize.font = UIFont(name: "Helvetica", size: 18)
        prize.textColor = .black
        prize.numberOfLines = 0

        let expiresLabel = UILabel()
        self.addSubview(expiresLabel)
        expiresLabel.translatesAutoresizingMaskIntoConstraints = false
        expiresLabel.topAnchor.constraint(equalTo: prizeContainer.bottomAnchor, constant: 32).isActive = true
        expiresLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 35).isActive = true
        expiresLabel.text = "Expires"
        expiresLabel.font = UIFont(name: "Helvetica-Bold", size: 18)
        expiresLabel.textColor = .white
        expiresLabel.numberOfLines = 0

        let expiresContainer = UIView()
        expiresContainer.addSubview(daysLeft)

        expiresContainer.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(expiresContainer)
        expiresContainer.topAnchor.constraint(equalTo: expiresLabel.bottomAnchor, constant: 5).isActive = true
        expiresContainer.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 30).isActive = true
        expiresContainer.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -30).isActive = true
        expiresContainer.bottomAnchor.constraint(equalTo: daysLeft.bottomAnchor, constant: 15).isActive = true
//        expiresContainer.heightAnchor.constraint(equalToConstant: 55).isActive = true
        expiresContainer.layer.cornerRadius = 7
        expiresContainer.backgroundColor = .white

        expiresContainer.addSubview(daysLeft)
        daysLeft.translatesAutoresizingMaskIntoConstraints = false
        daysLeft.topAnchor.constraint(equalTo: expiresContainer.topAnchor, constant: 15).isActive = true
        daysLeft.leftAnchor.constraint(equalTo: expiresContainer.leftAnchor, constant: 10).isActive = true
        daysLeft.rightAnchor.constraint(equalTo: expiresContainer.rightAnchor, constant: -20).isActive = true
        daysLeft.text = expiresString
        daysLeft.font = UIFont(name: "Helvetica", size: 18)
        daysLeft.textColor = .black
        daysLeft.numberOfLines = 0

        let onTap = UITapGestureRecognizer()
        onTap.addTarget(self, action: #selector(close))
        self.addGestureRecognizer(onTap)

        let closeButton = UIButton()
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(closeButton)
        closeButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 32).isActive = true
        closeButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
        closeButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        closeButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        closeButton.setImage(#imageLiteral(resourceName: "weeklyClose"), for: .normal)
        closeButton.addTarget(self, action: #selector(close), for: .touchUpInside)
        closeButton.contentMode = .scaleAspectFit

        self.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true
        button.topAnchor.constraint(equalTo: expiresContainer.bottomAnchor, constant: 50).isActive = true
        button.heightAnchor.constraint(equalToConstant: 58).isActive = true
        button.widthAnchor.constraint(equalToConstant: 148).isActive = true
        button.setTitleColor(AppConstants.colorGreen, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 15
        button.setTitle("GO!", for: .normal)
        button.titleLabel?.font = UIFont(name: "Helvetica-Bold", size: 32)
    }

    @objc func close() {
        self.alpha = 0
        self.isHidden = true
        self.removeFromSuperview()
    }
}
