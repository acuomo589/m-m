//
// Created by Kyrylo Savytskyi on 10/3/17.
// Copyright (c) 2017 YoGIF. All rights reserved.
//

import Foundation
import FBSDKCoreKit
import FBSDKLoginKit
import AWSCognito
import AWSCore
import AWSCognitoIdentityProvider
import AWSCognitoAuth
import Firebase


extension User {
    static func signUp(data: NSDictionary, completionHandler: @escaping (User?, String?) -> Void) {
        var tokens = [String: String]()

        if let token = FBSDKAccessToken.current().tokenString {
            // facebook login
            tokens = [AWSIdentityProviderFacebook: token]
        }
        let customIdentityProvider = CustomIdentityProvider(tokens: tokens)
        let credentialsProvider = AWSCognitoCredentialsProvider(regionType: AppConstants.cognitoPoolRegion,
                                                                identityPoolId: AppConstants.cognitoIdentityPoolId,
                                                                identityProviderManager: customIdentityProvider)
        let configuration = AWSServiceConfiguration(region: AppConstants.cognitoPoolRegion,
                                                    credentialsProvider: credentialsProvider)
        AWSServiceManager.default().defaultServiceConfiguration = configuration
        credentialsProvider.getIdentityId().continueWith {
            (task) in
            OperationQueue.main.addOperation {
                if let error = task.error {
                    if let error = error as? NSError,
                        let message = error.userInfo["message"] as? String {
                        completionHandler(nil, message)
                    } else {
                        completionHandler(nil, error.localizedDescription)
                    }
                } else {
                    let response = task.result
                    print("response: \(String(describing: response))")
                }
            }
        }
    }

    static func signup(completionHandler: @escaping (String?) -> Void) {
        if let email = UserDefaults.standard.string(forKey: AppConstants.nsudUserEmail),
            let firstName = UserDefaults.standard.string(forKey: AppConstants.nsudUserFirstName),
            let lastName = UserDefaults.standard.string(forKey: AppConstants.nsudUserLastName),
            let birthday = UserDefaults.standard.string(forKey: AppConstants.nsudUserBirthday),
            let password = UserDefaults.standard.string(forKey: AppConstants.nsudUserPassword) {
            let awsConf = AWSServiceConfiguration(region: AppConstants.cognitoPoolRegion,
                                                  credentialsProvider: nil)
            let poolConf = AWSCognitoIdentityUserPoolConfiguration(clientId: AppConstants.cognitoClientId,
                                                                   clientSecret: nil,//AppConstants.cognitoClientSecret,
                poolId: AppConstants.cognitoPoolId)
            AWSCognitoIdentityUserPool.register(with: awsConf,
                                                userPoolConfiguration: poolConf,
                                                forKey: "user_pool")
            
            let awsUserPool = AWSCognitoIdentityUserPool(forKey: "user_pool")

            let emailAttr = AWSCognitoIdentityUserAttributeType()
            emailAttr?.name = "email"
            emailAttr?.value = email

            let phoneAttr = AWSCognitoIdentityUserAttributeType()
            phoneAttr?.name = "phone_number"
            phoneAttr?.value = ""

            let firstNameAttr = AWSCognitoIdentityUserAttributeType()
            firstNameAttr?.name = "given_name"
            firstNameAttr?.value = firstName

            let lastNameAttr = AWSCognitoIdentityUserAttributeType()
            lastNameAttr?.name = "family_name"
            lastNameAttr?.value = lastName

            let birthdayAttr = AWSCognitoIdentityUserAttributeType()
            birthdayAttr?.name = "birthdate"
            birthdayAttr?.value = birthday

            let randomUsername = UUID().uuidString
            awsUserPool.signUp(randomUsername,
                               password: password,
                               userAttributes: [
                                emailAttr!,
//                                phoneAttr!,
                                firstNameAttr!,
                                lastNameAttr!,
//                                birthdayAttr!
                               ],
                               validationData: nil)
                .continueWith(block: { (task) in
                    OperationQueue.main.addOperation {
                        UserDefaults.standard.set(randomUsername, forKey: AppConstants.nsudCognitoUsername)

                        if let error = task.error {
                            if let error = error as? NSError,
                                let message = error.userInfo["message"] as? String {
                                completionHandler(message)
                            } else {
                                completionHandler(error.localizedDescription)
                            }
                        } else {
                            completionHandler(nil)
                        }
                    }
                    return nil
                })
        }

    }

    static func confirm(username: String, code: String, completionHandler: @escaping (String?) -> Void) {
        let awsConf = AWSServiceConfiguration(region: AppConstants.cognitoPoolRegion,
                                              credentialsProvider: nil)
        let poolConf = AWSCognitoIdentityUserPoolConfiguration(clientId: AppConstants.cognitoClientId,
                                                               clientSecret: nil,//AppConstants.cognitoClientSecret,
            poolId: AppConstants.cognitoPoolId)
        AWSCognitoIdentityUserPool.register(with: awsConf,
                                            userPoolConfiguration: poolConf,
                                            forKey: "user_pool")
        let awsUserPool = AWSCognitoIdentityUserPool(forKey: "user_pool")

        let user: AWSCognitoIdentityUser = awsUserPool.getUser(username)
        let confirm = user.confirmSignUp(code)
        confirm.continueWith(block: { (task: AWSTask<AWSCognitoIdentityUserConfirmSignUpResponse>) in
            OperationQueue.main.addOperation {
                if let error = task.error {
                    if let error = error as? NSError,
                        let message = error.userInfo["message"] as? String {
                        completionHandler(message)
                    } else {
                        completionHandler(error.localizedDescription)
                    }
                } else {
                    completionHandler(nil)
                }
            }
            return nil
        })
    }

    static func getCognitoPrefferedUserame(username: String, completionHandler: @escaping (String?, String?) -> Void) {
        let awsConf = AWSServiceConfiguration(region: AppConstants.cognitoPoolRegion,
            credentialsProvider: nil)
        let poolConf = AWSCognitoIdentityUserPoolConfiguration(clientId: AppConstants.cognitoClientId,
            clientSecret: nil,
            poolId: AppConstants.cognitoPoolId)

        AWSCognitoIdentityUserPool.register(with: awsConf,
                                            userPoolConfiguration: poolConf,
                                            forKey: "user_pool")
        let awsUserPool = AWSCognitoIdentityUserPool(forKey: "user_pool")
        let user = awsUserPool.getUser(username)
        user.getDetails().continueWith { (task) -> Any? in
            OperationQueue.main.addOperation {
                if let error = task.error {
                    print(error)
                    if let error = error as? NSError,
                        let message = error.userInfo["message"] as? String {
                        completionHandler(nil, message)
                    } else {
                        completionHandler(nil, error.localizedDescription)
                    }
                } else if let result = task.result?.userAttributes {
                    print("Result:")
                    print(result)
                    var username: String?
                    for attr in result {
                        print(attr.name)
                        print(attr.value)
                        if let name = attr.name, let value = attr.value, name == "preferred_username" {
                            username = attr.value
                            YoAnalytics.setUserData(value, forName: "preferred_username")
                        }
                    }
                    completionHandler(username, nil)
                } else {
                    completionHandler(nil, "Unexpected error")
                }
            }
            return nil
        }
    }

    static func login(username: String, password: String, completionHandler: @escaping (User?, String?) -> Void) {
        let awsConf = AWSServiceConfiguration(region: AppConstants.cognitoPoolRegion,
                                              credentialsProvider: nil)
        let poolConf = AWSCognitoIdentityUserPoolConfiguration(clientId: AppConstants.cognitoClientId,
                                                               clientSecret: nil,//AppConstants.cognitoClientSecret,
            poolId: AppConstants.cognitoPoolId)
        AWSCognitoIdentityUserPool.register(with: awsConf,
                                            userPoolConfiguration: poolConf,
                                            forKey: "user_pool")
        let awsUserPool = AWSCognitoIdentityUserPool(forKey: "user_pool")

        //        let emailAttr = AWSCognitoIdentityUserAttributeType()
        //        emailAttr?.name = "email"
        //        emailAttr?.value = email
        let user = awsUserPool.getUser(username)
        // Having a user created we can now login with this credentials
        let awsTask = user.getSession(username, password: password, validationData: [])
        //        let awsTask = user.getSession(email, password: password, validationData: [emailAttr!])
        awsTask.continueWith(block: { (task) in
            OperationQueue.main.addOperation {
                if let error = task.error {
                    print(error)
                    if let error = error as? NSError,
                        let message = error.userInfo["message"] as? String {
                        completionHandler(nil, message)
                    } else {
                        completionHandler(nil, error.localizedDescription)
                    }
                } else if let result = task.result, let sessionToken = result.idToken?.tokenString {
                    print("Token:")
                    print(sessionToken)
                    
                    UserDefaults.standard.set(sessionToken, forKey: AppConstants.nsudCognitoToken)
                    UserDefaults.standard.set(password, forKey: AppConstants.nsudUserPassword)
                    UserDefaults.standard.set(username, forKey: AppConstants.nsudCognitoPublicUsername)
                    completionHandler(User(), nil)
                }
            }
            return nil
        })
    }

    static func restoreSession(completionHandler: @escaping (String?) -> Void) {
        let awsConf = AWSServiceConfiguration(region: AppConstants.cognitoPoolRegion,
                                              credentialsProvider: nil)
        let poolConf = AWSCognitoIdentityUserPoolConfiguration(clientId: AppConstants.cognitoClientId,
                                                               clientSecret: nil,//AppConstants.cognitoClientSecret,
            poolId: AppConstants.cognitoPoolId)
        AWSCognitoIdentityUserPool.register(with: awsConf,
                                            userPoolConfiguration: poolConf,
                                            forKey: "user_pool")
        let awsUserPool = AWSCognitoIdentityUserPool(forKey: "user_pool")

        if let user = awsUserPool.currentUser() {
            if let username = user.username {
                YoAnalytics.setUserId(username)
                UserDefaults.standard.set(username, forKey: AppConstants.nsudCognitoUsername)
            }

            // Try to restore prev. sessionxc
            user.getSession().continueWith(block: { (task) in
                OperationQueue.main.addOperation {
                    if let session = task.result {
                        if let token = task.result?.idToken?.tokenString {
                            print(token)
                            UserDefaults.standard.set(token, forKey: AppConstants.nsudCognitoToken)
                            if let username = user.username {
                                UserDefaults.standard.set(username, forKey: AppConstants.nsudCognitoUsername)
                                User.getProfile(username) { user, error in
                                }
                            }
                        }
                        completionHandler(nil)
                    } else if let error = task.error {
                        if let error = error as? NSError,
                            let message = error.userInfo["message"] as? String {
                            completionHandler(message)
                        } else {
                            completionHandler(error.localizedDescription)
                        }
                    }
                }
                return nil
            })
        } else {
            completionHandler("Unexpected Error")
        }
    }

    static func loginWithFacebook(completionHandler: @escaping (User?, String?) -> Void) {
        // name, email address, location (city and country), gender and age.
        let parameters = ["fields": "email,first_name,last_name,birthday,gender,id,picture.type(large),location"]
        FBSDKGraphRequest(graphPath: "me", parameters: parameters).start { (connection, result, error) -> Void in

            if let error = error {
                print(error)
                completionHandler(nil, String(describing: error))
            } else if let dataDict = result as? [String:AnyObject] {

                let facebookId = (dataDict["id"] as? String)!

                let data = [
                    "facebookId": facebookId,
                    "firstName": (dataDict["first_name"] as? String)!,
                    "lastName": (dataDict["last_name"] as? String)!
                    ] as NSMutableDictionary
                if let email = dataDict["email"] as? String {
                    data["email"] = email
                    data["emailConfirmed"] = true
                }
                print(dataDict)
                if let gender = dataDict["gender"] as? String {
                    if gender == "male" {
                        data["gender"] = 1
                    } else if gender == "female" {
                        data["gender"] = 2
                    }
                }
                if let birthday = dataDict["birthday"] as? String {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "MM/dd/yyyy"

                    if let date = dateFormatter.date(from: birthday) {
                        let dateFormatterServer = DateFormatter()
                        dateFormatterServer.dateFormat = "yyyy-MM-dd"
                        data["birthday"] = dateFormatterServer.string(from: date)
                    }
                }
                if let location = dataDict["location"] as? NSDictionary {
                    if let locationName = location["name"] as? String {
                        data["location"] = locationName
                    }
                }

                UserDefaults.standard.setValue(facebookId, forKey: "facebookID")

                // get user's photo in a given resolution:
                let params =  ["redirect": false, "height": 600, "width": 600] as [String : Any]
                FBSDKGraphRequest(graphPath: "\(facebookId)/picture", parameters: params).start{ (connection, result, error) -> Void in
                    // handle result

                    if let error = error {
                        completionHandler(nil, String(describing: error))
                    } else if let pictureDataDict = result as? [String:AnyObject] {
                        var noPicture = true
                        if let data = pictureDataDict["data"] as? NSDictionary,
                            let isSil = data["is_silhouette"] as? Bool {
                            if isSil == false {
                                noPicture = false
                            }
                        }

                        if  noPicture {
                            // user does not have any photo
                        } else {
                            // user has photo set, save the url
                            let photoUrl = (pictureDataDict["data"]?["url"] as? String)!
                            data["photoUrl"] = photoUrl
                        }
                        if let token = UserDefaults.standard.string(forKey: "deviceToken") {
                            data["pushToken"] = token
                        }
                        data["platform"] = "ios"
                        self.signUp(data: data as NSDictionary, completionHandler: { (user, error) in
                            if let error = error {
                                completionHandler(nil, error)
                            } else if let user = user {
                                completionHandler(user, nil)
                            }
                        })
                    } else {
                        print(result!)
                    }
                }
            } else {
                completionHandler(nil, "Something went wrong")
            }
        }
    }

    static func deactivateAccount(completionHandler: @escaping (String?) -> Void) {
        _ = Session().sessionRequest(data: [:] as NSDictionary,
                                     to: "deleteAccount",
                                     method: "DELETE", completionHandler: {(result, error) in
                                        print(result)
                                        print(error)
                                        if let result = result as? NSDictionary {
                                            if let message = result["message"] as? String {
                                                completionHandler(message)
                                            } else {
                                                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                                if let signupVc = appDelegate.openAuth() as? SignupViewController {
                                                    User.logout(signupVc: signupVc)
                                                } else {
                                                    User.logout(signupVc: nil)
                                                }

                                                completionHandler(nil)
                                            }
                                        } else if let error = error {
                                            completionHandler(error.localizedDescription)
                                        } else {
                                            completionHandler("Unexpected error")
                                        }
        })
    }

    static func logout(signupVc: SignupViewController?) {
        PushNotifications.removeToken()
        UserDefaults.standard.set(nil, forKey: AppConstants.nsudShareAlertLikeMeShown)
        UserDefaults.standard.set(nil, forKey: AppConstants.nsudShareAlertPerfectShown)
        UserDefaults.standard.set(nil, forKey: AppConstants.nsudCognitoToken)
        UserDefaults.standard.set(nil, forKey: AppConstants.nsudCognitoUsername)
        UserDefaults.standard.set(nil, forKey: AppConstants.nsudCognitoPublicUsername)
        UserDefaults.standard.set(nil, forKey: AppConstants.nsudCognitoFacebookUsername)
        UserDefaults.standard.set(nil, forKey: AppConstants.nsudUserFirstName)
        UserDefaults.standard.set(nil, forKey: AppConstants.nsudUserLastName)
        UserDefaults.standard.set(nil, forKey: AppConstants.nsudUserBirthday)
        UserDefaults.standard.set(nil, forKey: AppConstants.nsudUserPassword)
        UserDefaults.standard.set(nil, forKey: AppConstants.nsudUserEmail)
        UserDefaults.standard.set(nil, forKey: AppConstants.nsudUserPhone)
        UserDefaults.standard.set(nil, forKey: AppConstants.nsudConfirmationSuccesful)
        
        

        let awsConf = AWSServiceConfiguration(region: AppConstants.cognitoPoolRegion,
                                              credentialsProvider: nil)
        let poolConf = AWSCognitoIdentityUserPoolConfiguration(clientId: AppConstants.cognitoClientId,
                                                               clientSecret: nil,//AppConstants.cognitoClientSecret,
            poolId: AppConstants.cognitoPoolId)
        AWSCognitoIdentityUserPool.register(with: awsConf,
                                            userPoolConfiguration: poolConf,
                                            forKey: "user_pool")
        let awsUserPool = AWSCognitoIdentityUserPool(forKey: "user_pool")

        if let user = awsUserPool.currentUser() {
            user.signOutAndClearLastKnownUser()
        }
        let loginManager = FBSDKLoginManager()
        loginManager.logOut()

        // facebook
        
        if let signupVc = signupVc {
            let auth: AWSCognitoAuth = AWSCognitoAuth.default()
            auth.delegate = signupVc
            auth.signOut { (error:Error?) in
                print("DONE")
                if let error = error as? NSError {
                    print(error)
                } else {
                    print("success")
                }
            }
            print(auth)

        }
    }

    static func isAuthorized() -> Bool {
        let awsConf = AWSServiceConfiguration(region: AppConstants.cognitoPoolRegion,
                                              credentialsProvider: nil)
        let poolConf = AWSCognitoIdentityUserPoolConfiguration(clientId: AppConstants.cognitoClientId,
                                                               clientSecret: nil,//AppConstants.cognitoClientSecret,
            poolId: AppConstants.cognitoPoolId)
        AWSCognitoIdentityUserPool.register(with: awsConf,
                                            userPoolConfiguration: poolConf,
                                            forKey: "user_pool")
        let awsUserPool = AWSCognitoIdentityUserPool(forKey: "user_pool")

        if let username = UserDefaults.standard.string(forKey: AppConstants.nsudCognitoUsername),
            let currentUser = awsUserPool.currentUser(),
            currentUser.isSignedIn == true {
            let user: AWSCognitoIdentityUser = awsUserPool.getUser(username)
            print(user.isSignedIn)
            return true
        } else {
            return false
        }
    }
}

class CustomIdentityProvider: NSObject, AWSIdentityProviderManager {
    var tokens: [String : String]?

    init(tokens: [String : String]?) {
        self.tokens = tokens
    }

    func logins() -> AWSTask<NSDictionary> {
        let logins: NSDictionary = NSDictionary(dictionary: tokens ?? [:])
        return AWSTask(result: logins)
    }
}
