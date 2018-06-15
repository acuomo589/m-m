import UIKit
import AWSCore

extension AppConstants {
    static let isProduction = true
    static let colorGreen = UIColor(red:0.04, green:0.77, blue:0.66, alpha:1.0)
    static let cognitoClientId = "45rrkejfjcsrb47882iij7mlnh"
    static let cognitoClientSecret = ""
    static let cognitoPoolId = "us-west-2_1W7r7tVyt"
    static let cognitoPoolRegion = AWSRegionType.USWest2
    static let cognitoIdentityPoolId = "us-west-2:6901fd7f-775e-4c67-aa21-442ac7c2166a"

    static let api = "https://rf7wnlwai8.execute-api.us-west-2.amazonaws.com/prod"
    static let pushApi = "https://9056hhdot8.execute-api.us-west-2.amazonaws.com/prod"
    static let apiXAPIKey = "x8882mjvsq1AAv6cbVQFU8YtZNUcYa5E6kklpjbW"
    static let pushXAPIKey = "lO3P7aghwT4CuOnDfA8yY8R6KdKU9hFq9hdP8YKv"

    static let s3BucketName = "mim-assets"
}

