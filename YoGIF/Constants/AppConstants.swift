import UIKit
import AWSCore

struct AppConstants {
    private init(){}

    static let gifUploadedUD = "gifUploaded"
    
    //
    
    static let colorMimGreen = UIColor(red:0.34, green:0.76, blue:0.66, alpha:1.0)
    // Backgrounds
    static let colorDarkBlue = UIColor(red:0.01, green:0.17, blue:0.25, alpha:1.0)
//    static let colorGreen = UIColor(red:0.04, green:0.77, blue:0.66, alpha:1.0)
    static let colorBlueText = UIColor(red:0.00, green:0.47, blue:1.00, alpha:1.0)
    static let colorPink = UIColor(red:1.00, green:0.52, blue:0.49, alpha:1.0)
    static let colorRed = UIColor(red:1.00, green:0.64, blue:0.62, alpha:1.0)
    static let colorYellow = UIColor(red:0.98, green:0.81, blue:0.26, alpha:1.0)
    static let colorDarkBlueBG = UIColor(red:0.26, green:0.38, blue:0.44, alpha:1.0)
    static let colorGray = UIColor(red:0.55, green:0.67, blue:0.72, alpha:1.0)
    
    static let colorLol = UIColor(red: 0.047, green: 0.769, blue: 0.659, alpha: 1)
    static let colorWtf = UIColor(red: 1, green: 0.518, blue: 0.486, alpha: 0.7)
    static let colorOmg = UIColor(red: 0.976, green: 0.745, blue: 0.008, alpha: 0.7)
    static let colorFml = UIColor(red: 0.027, green: 0.196, blue: 0.271, alpha: 0.7)
    static let colorSmh = UIColor(red: 0.439, green: 0.639, blue: 0.867, alpha: 0.7)
    static let colorYas = UIColor(red: 0.980, green: 0.482, blue: 0.969, alpha: 0.7)
    static let emptyVideoHolder = UIColor(red: 0.008, green: 0.176, blue: 0.255, alpha:1.0)
    static let editNavGrayColor = UIColor(red: 0.847, green: 0.847, blue: 0.847, alpha:1.0)
    static let separatorGrayColor = UIColor(red: 0.467, green: 0.467, blue: 0.467, alpha:1.0)

    static let nsudShareAlertPerfectShown = "nsud_share_alert_perfect_shown"
    static let nsudShareAlertLikeMeShown = "nsud_share_alert_like_me_shown"
    static let nsudCognitoSessionRefreshing = "nsud_cognito_session_refreshing"
    static let nsudCognitoPublicUsername = "nsud_public_username"
    static let nsudCognitoToken = "nsud_cognito_token"
    static let nsudCognitoUsername = "nsud_cognito_username"
    static let nsudCognitoFacebookUsername = "nsud_cognito_facebook_username"
    static let nsudUserFirstName = "nsud_user_first_name"
    static let nsudUserLastName = "nsud_user_last_name"
    static let nsudUserBirthday = "nsud_user_birthday"
    static let nsudUserPassword = "nsud_user_password"
    static let nsudUserEmail = "nsud_user_email"
    static let nsudUserPhone = "nsud_user_phone"
    static let nsudConfirmationSuccesful = "nsud_confirmation_succesful"
    static let nsudYGW = "nsud_YGW_shown"

    static let nsudS3AccessKeyId = "nsud_s3_access_key_id"
    static let nsudS3SecretAccessKey = "nsud_s3_secret_access_key"
    static let nsudS3SessionToken = "nsud_s3_session_token"

    static let notificationSessionRestored = Notification.Name("notification_session_restored")
    static let notificationVisualLoaded = Notification.Name("notification_visual_loaded")

}
