import UIKit
import AWSCognito
import AWSCognitoAuth
import FBSDKCoreKit
import RealmSwift
import Firebase
import SVProgressHUD
import UserNotifications
import AsyncDisplayKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var credentialsProvider: AWSCognitoCredentialsProvider?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let cache = URLCache(memoryCapacity: 20 * 1024 * 1024, diskCapacity: 100 * 1024 * 1024, diskPath: nil)
        URLCache.shared = cache

        if AppConstants.isProduction {
            FirebaseApp.configure()
        }
        
        setupRealm()
        
//        do {
//            print("Realn DB at: \(try Realm().configuration.fileURL?.absoluteString ?? "N/A")")
//        } catch {
//            print(error.localizedDescription)
//        }
        //print("Realm DB at: \(try! Realm().configuration.fileURL?.absoluteString ?? "N/A")")

//        var myDict: NSDictionary?
//        if let path = Bundle.main.path(forResource: "Info", ofType: "plist") {
//            myDict = NSDictionary(contentsOfFile: path)
//        }
//        if let dict = myDict {
//            // Use your dict here
//            print(dict)
//        }

        FBSDKApplicationDelegate.sharedInstance().application(application,
                                                              didFinishLaunchingWithOptions: launchOptions)

        showViewControllers()
        UIApplication.shared.statusBarStyle = .lightContent
        
        
        
        if let userInfo = launchOptions?[.remoteNotification] as? [AnyHashable : Any] {
            
            let notification = PushNotifications().notification(userInfo: userInfo)
            
            guard let evt = notification.pushEvt else { return true}
            
            if evt == "NEW_CONTEST" {
                openContestScreen()
            } else {
                openYouWonScreen(notification.contestTitle ?? "")
            }
        } else {
            
        }
        
        return true
    }

    func showViewControllers() {
        setupAppeareance()
        let username = UserDefaults.standard.string(forKey: AppConstants.nsudCognitoUsername)
        let password = UserDefaults.standard.string(forKey: AppConstants.nsudUserPassword)
        let fbId = UserDefaults.standard.string(forKey: AppConstants.nsudCognitoFacebookUsername)
        if User.isAuthorized(), let username = username, let password = password {
            SVProgressHUD.show(withStatus: "Restoring session")
            UserDefaults.standard.set(true, forKey: AppConstants.nsudCognitoSessionRefreshing)
            User.login(username: username, password: password, completionHandler: { (user, error) in
                if user != nil {
                    self.restoreUserSession(openAppOnDone: false, continueSignup: false)
                } else {
                    // clear session
                    UserDefaults.standard.set(false, forKey: AppConstants.nsudCognitoSessionRefreshing)
                    User.logout(signupVc: nil)
                    self.showViewControllers()
                }
            })
            openApp(0)
        } else if User.isAuthorized(), let _ = username, let _ = fbId {
            // user is logged in through Facebook
            SVProgressHUD.show(withStatus: "Restoring session")
            UserDefaults.standard.set(true, forKey: AppConstants.nsudCognitoSessionRefreshing)
            restoreUserSession(openAppOnDone: false, continueSignup: false)
            openApp(0)
        } else {
            openAuth()
        }
    }

    func restoreUserSession(openAppOnDone: Bool, continueSignup: Bool) {
        User.restoreSession { error in
            if let error = error {
                UserDefaults.standard.set(false, forKey: AppConstants.nsudCognitoSessionRefreshing)
                SVProgressHUD.dismiss()
                if let vc = self.window?.rootViewController {
                    _ = SimpleAlert.showAlert(alert: "Restore Session Error: " + error, delegate: vc)
                }
                print("failed to restore session: \(error)")
            } else {
                print("restored session")

                guard let username = UserDefaults.standard.string(forKey: AppConstants.nsudCognitoUsername) else {
                    User.logout(signupVc: nil)
                    self.showViewControllers()
                    return
                }
                User.getPersonalS3Access(completionHandler: { (error) in
                    UserDefaults.standard.set(false, forKey: AppConstants.nsudCognitoSessionRefreshing)
                    if let error = error {
                        SVProgressHUD.dismiss()
                        if let vc = self.window?.rootViewController {
                            _ = SimpleAlert.showAlert(alert: "Restore S3 Access Error: " + error, delegate: vc)
                        }
                        print("failed to restore session: \(error)")
                    } else {
                        NotificationCenter.default.post(name: AppConstants.notificationSessionRestored, object: nil)
                        print("got s3 access")
                    }
                })
                User.getProfile(username) { user, error in
                    SVProgressHUD.dismiss()
                    if let user = user {
                        print("Everything is fine, fot user info \(user)")
                        if openAppOnDone && continueSignup {
                            self.openFacebookRegistration()
                        } else if openAppOnDone {
                            self.openApp(0)
                        }
                    } else if let error = error {
                        if let vc = self.window?.rootViewController {
                            _ = SimpleAlert.showAlert(alert: "Get own profile data: " + error, delegate: vc)
                        }
                        print("failed to updated user info \(username)")
                    } else {
                        print("unexpected error when updating user's info")
                    }
                }
            }
        }
    }

    func openFacebookRegistration() {
        OperationQueue.main.addOperation {
            let navController = UINavigationController()
//            let nameVc = UserNameViewController()
//            nameVc.facebookMode = true
            let usernameVc = UserNicknameViewController()
            usernameVc.facebookMode = true

            navController.setViewControllers(
                [SignupViewController(), usernameVc], animated: true)

            self.window = UIWindow(frame: UIScreen.main.bounds)
            self.window!.rootViewController = navController
            self.window?.makeKeyAndVisible()
        }
    }

    func setupAppeareance() {
        SVProgressHUD.setDefaultMaskType(.gradient)
        UINavigationBar.appearance().barTintColor = AppConstants.colorGreen
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().titleTextAttributes = [
            NSAttributedStringKey.foregroundColor: UIColor.white
        ]

        let tabBar = UITabBar.appearance()
        tabBar.barTintColor = AppConstants.colorDarkBlue
        tabBar.tintColor = .white
        let tabBarTitleAttrs = [
            NSAttributedStringKey.foregroundColor: UIColor(red:0.47, green:0.47, blue:0.47, alpha:1.0),
            ]
        let tabBarItem = UITabBarItem.appearance()
        tabBarItem.setTitleTextAttributes(tabBarTitleAttrs, for: .normal)
        tabBarItem.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.white], for: .selected)

    }

@discardableResult func openAuth() -> UIViewController {
        var navController = UINavigationController()
        if UserDefaults.standard.string(forKey: AppConstants.nsudUserFirstName) == nil &&
            UserDefaults.standard.string(forKey: AppConstants.nsudUserLastName) == nil {
            navController = UINavigationController(rootViewController: SignupViewController())
        } else if UserDefaults.standard.string(forKey: AppConstants.nsudUserFirstName) == nil ||
            UserDefaults.standard.string(forKey: AppConstants.nsudUserLastName) == nil {
            navController.setViewControllers([SignupViewController(),
                                              UserNameViewController()], animated: true)
        } else if UserDefaults.standard.object(forKey: AppConstants.nsudUserBirthday) == nil {
            navController.setViewControllers([SignupViewController(),
                                              UserNameViewController(),
                                              UserBirthdayViewController()], animated: true)
        } else if UserDefaults.standard.string(forKey: AppConstants.nsudUserEmail) == nil ||
            UserDefaults.standard.string(forKey: AppConstants.nsudUserPhone) == nil {
            navController.setViewControllers([SignupViewController(),
                                              UserNameViewController(),
                                              UserBirthdayViewController(),
                                              UserEmailViewController(),
                                              ], animated: true)
        } else if UserDefaults.standard.object(forKey: AppConstants.nsudUserPassword) == nil {
            navController.setViewControllers([SignupViewController(),
                                              UserNameViewController(),
                                              UserBirthdayViewController(),
                                              UserEmailViewController(),
                                              UserPasswordViewController()], animated: true)
        } else if UserDefaults.standard.bool(forKey: AppConstants.nsudConfirmationSuccesful) != true {
            navController.setViewControllers([SignupViewController(),
                                              UserNameViewController(),
                                              UserBirthdayViewController(),
                                              UserEmailViewController(),
                                              UserPasswordViewController(),
                                              EmailConfirmationViewController()], animated: true)
        } else if UserDefaults.standard.object(forKey: AppConstants.nsudCognitoUsername) == nil {
            navController.setViewControllers([SignupViewController(),
                                              UserNameViewController(),
                                              UserBirthdayViewController(),
                                              UserEmailViewController(),
                                              UserPasswordViewController(),
                                              UserNicknameViewController()], animated: true)
        } else {
            navController = UINavigationController(rootViewController: SignupViewController())
        }
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window!.rootViewController = navController
        self.window?.makeKeyAndVisible()
        return navController.visibleViewController!
    }

    func openApp(_ index: Int?) {
        let imageInset = UIEdgeInsets(top: 3.0, left: 0, bottom: -3.0, right: 0)

        // Real search
        let search = UINavigationController(rootViewController: SearchViewController())

        // Random Screen
        //let search = UINavigationController(rootViewController: FindFriendsViewController())


        // Screen with Video
               // let vc = VideoViewController()
               // vc.videoUrl = Bundle.main.url(forResource: "sample", withExtension: "mp4")
               // let search = UINavigationController(rootViewController: vc)

//        let vc = CaptionViewController()
//            vc.audioUrl = nil
//            vc.videoUrl = Bundle.main.url(forResource: "sample", withExtension: "mp4")
//            vc.textDelay = 0
//            vc.videoViewController = nil
//            vc.videoTitle = "title"
//            let search = UINavigationController(rootViewController: vc)

        search.tabBarItem = UITabBarItem(title: "",
                                         image: #imageLiteral(resourceName: "tabIconSearchInactive").withRenderingMode(.alwaysOriginal),
                                         selectedImage: #imageLiteral(resourceName: "tabIconSearchActive"))
        search.tabBarItem.imageInsets = imageInset

        let notifications = UINavigationController(rootViewController: NotificationsViewController())
        notifications.tabBarItem = UITabBarItem(title: "",
                                                image: #imageLiteral(resourceName: "tabIconNotificationsInactive").withRenderingMode(.alwaysOriginal),
                                                selectedImage: #imageLiteral(resourceName: "tabIconNotificationsActive"))
        notifications.tabBarItem.imageInsets = imageInset

        let camera = UINavigationController(rootViewController: UIViewController())
        camera.tabBarItem = UITabBarItem(title: "",
                                         image: nil,
                                         selectedImage: nil)
        camera.tabBarItem.imageInsets = imageInset

        let feed = UINavigationController(rootViewController: FeedViewController())
        feed.tabBarItem = UITabBarItem(title: "",
                                       image: #imageLiteral(resourceName: "tabIconFeedInactive").withRenderingMode(.alwaysOriginal),
                                       selectedImage: #imageLiteral(resourceName: "tabIconFeedActive").withRenderingMode(.alwaysOriginal))
        feed.tabBarItem.imageInsets = imageInset

        //        let profile = UINavigationController(rootViewController: SettingsViewController())
        let profile = UINavigationController(rootViewController: ProfileViewController())
        profile.tabBarItem = UITabBarItem(title: "",
                                          image: #imageLiteral(resourceName: "tabIconProfileInactive").withRenderingMode(.alwaysOriginal),
                                          selectedImage: #imageLiteral(resourceName: "tabIconProfileActive"))
        profile.tabBarItem.imageInsets = imageInset

        let tabController = YoTabBarController()
        tabController.viewControllers = [
            search,
            notifications,
            camera,
            feed,
            profile
        ]
        self.window = UIWindow(frame: UIScreen.main.bounds)
        if UserDefaults.standard.bool(forKey: AppConstants.gifUploadedUD) == true {
            TimerHelper.shared.startTimer()
        }
        if let idx = index {
            tabController.selectedIndex = idx
        } else {
            tabController.selectedIndex = 0
        }
        
        self.window!.rootViewController = tabController//UINavigationController(rootViewController: MediaSyncViewController()) //tabController
        self.window?.makeKeyAndVisible()
        
        if let token = PushNotifications.deviceToken() {
            PushNotifications.send(token: token)
        } else {
            registerForPushNotifications()
        }
    }

    func configureCognito() {
        self.credentialsProvider = AWSCognitoCredentialsProvider(
            regionType: AppConstants.cognitoPoolRegion,
            identityPoolId: AppConstants.cognitoPoolId)
        let configuration = AWSServiceConfiguration(
            region: AppConstants.cognitoPoolRegion,
            credentialsProvider: credentialsProvider)
        AWSServiceManager.default().defaultServiceConfiguration = configuration
        // AWS Cognito : Warn user if configuration not updated
        //        if (CognitoIdentityUserPoolId == "YOUR_USER_POOL_ID") {
        //            let alertController = UIAlertController(title: "Invalid Configuration",
        //                    message: "Please configure user pool constants in Constants.swift file.",
        //                    preferredStyle: .alert)
        //            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        //            alertController.addAction(okAction)
        //
        //            self.window?.rootViewController!.present(alertController, animated: true, completion:  nil)
        //        }
        //
        //        // AWS Cognito : setup logging
        //        AWSLogger.default().logLevel = .verbose
        //
        //        // AWS Cognito : setup service configuration
        //        let serviceConfiguration = AWSServiceConfiguration(
        //                region: CognitoIdentityUserPoolRegion,
        //                credentialsProvider: nil)
        //
        //        // AWS Cognito : create pool configuration
        //        let poolConfiguration = AWSCognitoIdentityUserPoolConfiguration(
        //                clientId: CognitoIdentityUserPoolAppClientId,
        //                clientSecret: CognitoIdentityUserPoolAppClientSecret,
        //                poolId: CognitoIdentityUserPoolId)
        //
        //        // AWS Cognito : initialize user pool client
        //        AWSCognitoIdentityUserPool.register(
        //                with: serviceConfiguration,
        //                userPoolConfiguration: poolConfiguration,
        //                forKey: AWSCognitoUserPoolsSignInProviderKey)
        //
        //        // AWS Cognito : fetch the user pool client we initialized in above step
        //        let pool = AWSCognitoIdentityUserPool(forKey: AWSCognitoUserPoolsSignInProviderKey)
        //        pool.delegate = self
    }

    func getCurrentViewController() -> UIViewController? {
        
        // If the root view is a navigation controller, we can just return the visible ViewController
        if let navigationController = getNavigationController() {
            
            return navigationController.visibleViewController
        }
        
        // Otherwise, we must get the root UIViewController and iterate through presented views
        if let rootController = UIApplication.shared.keyWindow?.rootViewController {
            
            var currentController: UIViewController! = rootController
            
            // Each ViewController keeps track of the view it has presented, so we
            // can move from the head to the tail, which will always be the current view
            while( currentController.presentedViewController != nil ) {
                
                currentController = currentController.presentedViewController
            }
            return currentController
        }
        return nil
    }
    
    private func getNavigationController() -> UINavigationController? {
        
        if let navigationController = UIApplication.shared.keyWindow?.rootViewController  {
            
            return navigationController as? UINavigationController
        }
        return nil
    }
    
    func configureGoogleAnalytics() {
        //        // Configure tracker from GoogleService-Info.plist.
        //        var configureError: NSError?
        //        GGLContext.sharedInstance().configureWithError(&configureError)
        //        assert(configureError == nil, "Error configuring Google services: \(String(describing: configureError))")
        //
        //        // Optional: configure GAI options.
        //        guard let gai = GAI.sharedInstance() else {
        //            assert(false, "Google Analytics not configured correctly")
        //            return
        //        }
        //        gai.trackUncaughtExceptions = true  // report uncaught exceptions
        //        gai.logger.logLevel = GAILogLevel.verbose  // remove before app release

    }
    //    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
    //
    //        let appId = FBSDKSettings.appID
    //        if url.scheme != nil && url.scheme!.hasPrefix("fb\(appId)") && url.host ==  "authorize" {
    //            return FBSDKApplicationDelegate.sharedInstance().application(app, open: url, options: options)
    //        }
    //
    //        return false
    //    }


    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state.
        // This can occur for certain types of temporary interruptions (such as
        // an incoming phone call or SMS message) or when the user quits the
        // application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers,
        // and invalidate graphics rendering callbacks.
        // Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        GifViewSingle.shared.gifView.muted = true
        //try? AVAudioSession.sharedInstance().setActive(false)
        // Use this method to release shared resources, save user data,
        // invalidate timers, and store enough application state information to
        // restore your application to its current state in case it is terminated later.
        // If your application supports background execution,
        // this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        //try? AVAudioSession.sharedInstance().setActive(true)
        // Called as part of the transition from the background
        // to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            User.getWonContest { (isWon, title) in
                if isWon {
                    self.openYouWonScreen(title ?? "")
                }
            }
        }
        // Restart any tasks that were paused (or not yet started)
        // while the application was inactive. If the application was
        // previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate.
        // Save data if appropriate. See also applicationDidEnterBackground:.
        UserDefaults.standard.set(false, forKey: AppConstants.nsudYGW)
    }

    func application(_ application: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        print(url)
        if let range = url.absoluteString.range(of: "mim://") {
            guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true), let host = components.host else {
                return true
            }
            var pathComponents = components.path.components(separatedBy: "/")
            // the first component is empty
            pathComponents.removeFirst()
            switch host {
            case "gif":
                if let userId = pathComponents[0] as? String, let gifId = pathComponents[1] as? String {
                    let realm = try! Realm()
                    var v: Visual?
                    if let visual = realm.objects(Visual.self).filter("filename = %@", gifId).first {
                        v = visual
                    } else {
                        v = Visual.toRealm(data: ["filename": gifId, "username": userId])
                    }
                    if User.isAuthorized(), let v = v {
                        var nav: UINavigationController?
                        if let vc = self.window?.rootViewController as? YoTabBarController {
                            if let navOptional = vc.selectedViewController as? UINavigationController {
                                nav = navOptional
                            }
                        } else if let vc = self.window?.rootViewController as? UINavigationController {
                            nav = vc
                        }
                        if let nav = nav {
                            let vc = GifInfoViewController()
                            vc.visual = v
                            nav.pushViewController(vc, animated: true)
                        }
                    }
//                    return DeeplinkType.messages(.details(id: messageId))
                }
                break
            default:
                break
            }
            return true
        } else {
            return AWSCognitoAuth.default().application(application, open: url, options: options)
        }
    }

    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application,
                                                                     open: url as URL!,
                                                                     sourceApplication: sourceApplication,
                                                                     annotation: annotation)
    }
    
    func setupRealm() {
        let config = Realm.Configuration(
            schemaVersion: 1,
            migrationBlock: { migration, oldSchemaVersion in
                
                if oldSchemaVersion < 1 {
                    migration.enumerateObjects(ofType: Visual.className(), { oldObject, newObject in
                        
                    })
                }
            }
        )
        Realm.Configuration.defaultConfiguration = config
        
    }
    
    //MARK: Push Notifictions
    
    func registerForPushNotifications() {
        //SimpleAlert.showAlert(alert: "registerForPushNotifications", delegate: self.getCurrentViewController()!)
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            guard granted else { return }
            self.getNotificationSettings()
        }
    }
    
    func getNotificationSettings() {
       // SimpleAlert.showAlert(alert: "getNotificationSettings", delegate: self.getCurrentViewController()!)
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            guard settings.authorizationStatus == .authorized else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        //SimpleAlert.showAlert(alert: "didRegisterForRemoteNotificationsWithDeviceToken", delegate: self.getCurrentViewController()!)
        let tokenParts = deviceToken.map { data -> String in
            return String(format: "%02.2hhx", data)
        }
        //SimpleAlert.showAlert(alert: tokenParts.joined(), delegate: self.getCurrentViewController()!)
        let token = tokenParts.joined()
        YOLog.Log(message: token, from: "token", category: "Push Notifications")
        
        PushNotifications.save(token: token)
        PushNotifications.send(token: token)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        openPushNotification(userInfo: userInfo)
        
    }
    
    func openPushNotification(userInfo: [AnyHashable : Any]) {
        
        let notification = PushNotifications().notification(userInfo: userInfo)

        guard let evt = notification.pushEvt else { return }
        
        if evt == "NEW_CONTEST" {
            openContestScreen()
        } else {
            openYouWonScreen(notification.contestTitle ?? "")
        }
    }
    
    func openYouWonScreen(_ title: String) {
        
        
        if let token = UserDefaults.standard.object(forKey: "nsud_cognito_token") as? String {
            if token.count > 1 {
                let vc = HowItWorksViewController()
                vc.isYouWon = true
                vc.wonContestTitle = title
                let nav = UINavigationController(rootViewController: vc)
                if let curVC = getCurrentViewController() as? HowItWorksViewController {
                    return
                } else {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.window?.rootViewController = nav
                    }
                }
            }
        }
        
    }
    
    func openContestScreen() {
        openApp(3)
    }
    
    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
    }
    
}
