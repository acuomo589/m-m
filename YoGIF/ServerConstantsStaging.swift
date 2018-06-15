import UIKit
import AWSCore

extension AppConstants {
    static let isProduction = false
    static let colorGreen = UIColor(red:0.80, green:0.1, blue:0.1, alpha:1.0)
    static let cognitoClientId = "2jrkcj9oknv5u9t0natoffer0g"
    static let cognitoClientSecret = ""
    static let cognitoPoolId = "us-west-2_ZvyndrXMg"
    static let cognitoPoolRegion = AWSRegionType.USWest2
    static let cognitoIdentityPoolId = "us-west-2:9c7c7a50-4a4b-437d-8604-fd91e2dc25b1"

    static let api = "https://r4klqy8v1f.execute-api.us-west-2.amazonaws.com/test"
    static let pushApi = "https://seyuqq5gyf.execute-api.us-west-2.amazonaws.com/test"
    static let apiXAPIKey = "yuT0DuN3fb9HQdvq9Lxfr8vBFGDz8olzaEl7cuHQ"
    static let pushXAPIKey = "buxmbOMtdva5Ui4bIpXVd8GuxDYTmAVM7Y1S3lRm"

    static let s3BucketName = "yogif-us-west-2-bucket1"

}
