import UIKit

extension SignupViewController {
    func setupUI() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)

        self.view.backgroundColor = .white

        let background = UIImageView()
        self.view.addSubview(background)
        background.translatesAutoresizingMaskIntoConstraints = false
        background.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        background.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: -5).isActive = true
        background.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 5).isActive = true
        background.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -50).isActive = true
        background.backgroundColor = .lightGray
        //        background.image = #imageLiteral(resourceName@objc : "loginBg")
        background.backgroundColor = AppConstants.colorMimGreen
        background.contentMode = .scaleAspectFill
        background.clipsToBounds = true

        let logo = UIImageView()
        self.view.addSubview(logo)
        logo.translatesAutoresizingMaskIntoConstraints = false
        logo.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 90).isActive = true
        logo.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 70).isActive = true
        logo.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -70).isActive = true
        logo.heightAnchor.constraint(equalToConstant: 120).isActive = true
        logo.backgroundColor = UIColor(white: 0, alpha: 0)
        logo.contentMode = .scaleAspectFit
//        logo.image = #imageLiteral(resourceName: "loginLogo")
        logo.image = #imageLiteral(resourceName: "mimLogo")

        let facebookButton = UIButton()
        self.view.addSubview(facebookButton)
        facebookButton.translatesAutoresizingMaskIntoConstraints = false
        facebookButton.topAnchor.constraint(equalTo: logo.bottomAnchor, constant: 34).isActive = true
        facebookButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        facebookButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        facebookButton.contentMode = .scaleAspectFit
//        facebookButton.backgroundColor =
        facebookButton.setImage(#imageLiteral(resourceName: "facebookSignup"), for: .normal)
        facebookButton.addTarget(self, action: #selector(facebookTapped), for: .touchUpInside)

        let orLabel = UILabel()
        self.view.addSubview(orLabel)
        orLabel.translatesAutoresizingMaskIntoConstraints = false
        orLabel.topAnchor.constraint(equalTo: facebookButton.bottomAnchor, constant: 16).isActive = true
        orLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        orLabel.text = "OR"
        orLabel.textColor = .white
        orLabel.font = UIFont(name: "Helvetica", size: 16)

        let emailButton = UIButton()
        self.view.addSubview(emailButton)
        emailButton.translatesAutoresizingMaskIntoConstraints = false
        let privacyLabel = UILabel()
        self.view.addSubview(privacyLabel)
        privacyLabel.translatesAutoresizingMaskIntoConstraints = false
        emailButton.topAnchor.constraint(equalTo: orLabel.bottomAnchor, constant: 0).isActive = true
        emailButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
//        emailButton.bottomAnchor.constraint(equalTo: privacyLabel.topAnchor, constant: 0).isActive = true
        emailButton.contentMode = .scaleAspectFit
        emailButton.setTitleColor(AppConstants.colorBlueText, for: .normal)
        emailButton.setTitleColor(UIColor(red:0.97, green:0.91, blue:0.11, alpha:1.0), for: .normal)
        emailButton.setTitle("Sign Up with Phone or Email", for: .normal)
        emailButton.addTarget(self, action: #selector(signupWithEmail), for: .touchUpInside)

        privacyLabel.bottomAnchor.constraint(equalTo: background.bottomAnchor, constant: -20).isActive = true
        privacyLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        privacyLabel.text = "By signing up, you agree to our\nTerms & Privacy Policy"
        privacyLabel.textColor = .white
        privacyLabel.font = UIFont(name: "Helvetica", size: 16)
        privacyLabel.numberOfLines = 2
        privacyLabel.textAlignment = .center

        let signinString = "Already have an account? Sign in"
        let signinText = NSMutableAttributedString(string: signinString)
        // black font
        signinText.addAttributes([
            NSAttributedStringKey.foregroundColor: UIColor.black,
            NSAttributedStringKey.font: (UIFont(name: "Helvetica", size: 15) ?? UIFont.systemFont(ofSize: 15))
        ], range: NSRange(location: 0, length: signinString.count))

        // blue font
        signinText.addAttributes([
            NSAttributedStringKey.foregroundColor: AppConstants.colorBlueText
        ], range: NSRange(location: 24, length: 8))

        let signinLabel = UIButton()
        self.view.addSubview(signinLabel)
        signinLabel.translatesAutoresizingMaskIntoConstraints = false
        signinLabel.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -10).isActive = true
        signinLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        signinLabel.setAttributedTitle(signinText, for: .normal)
        signinLabel.addTarget(self, action: #selector(signInTapped), for: .touchUpInside)

    }
}
