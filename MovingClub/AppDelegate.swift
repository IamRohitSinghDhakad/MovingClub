//
//  AppDelegate.swift
//  MovingClub
//
//  Created by Rohit SIngh Dhakad on 06/09/25.
//

import UIKit
import IQKeyboardManagerSwift
import IQKeyboardToolbarManager
import Alamofire
import FirebaseCore
import Firebase

let ObjAppdelegate = UIApplication.shared.delegate as! AppDelegate

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var navController: UINavigationController?
    var launchedFromNotification: Bool = false
    var launchNotificationPayload: [AnyHashable: Any]?

    
    private static var AppDelegateManager: AppDelegate = {
        let manager = UIApplication.shared.delegate as! AppDelegate
        return manager
    }()
    // MARK: - Accessors
    class func AppDelegateObject() -> AppDelegate {
        return AppDelegateManager
    }
    
    var orientationLock = UIInterfaceOrientationMask.portrait
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        //MARK: IQKeyBord Default Settings
        IQKeyboardManager.shared.isEnabled = true
        IQKeyboardManager.shared.resignOnTouchOutside = true
        
        self.applyGlobalFont()
        
//        for family in UIFont.familyNames {
//            print("Family: \(family)")
//            for name in UIFont.fontNames(forFamilyName: family) {
//                print("  Font: \(name)")
//            }
//        }
        
       // FirebaseApp.configure()
        self.registerForRemoteNotification()
        UNUserNotificationCenter.current().delegate = self
        Messaging.messaging().delegate = self
        
        
        // 🔥 Check if launched from a notification
           if let remoteNotification = launchOptions?[.remoteNotification] as? [AnyHashable: Any] {
               self.launchedFromNotification = true
               self.launchNotificationPayload = remoteNotification
           }
        
        //   AuthNavigation()
        return true
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return orientationLock
    }

    
    func applyGlobalFont() {
        // Use PostScript names, not file names
        guard let regularFont = UIFont(name: "CenturyGothic", size: 17),
              let boldFont = UIFont(name: "CenturyGothic-Bold", size: 17) else {
            print("⚠️ Century Gothic fonts not loaded properly. Check font names or Info.plist.")
            return
        }
        
        // Apply global appearance
        UILabel.appearance().font = regularFont
        UITextField.appearance().font = regularFont
        UITextView.appearance().font = regularFont
        
        UIButton.appearance().titleLabel?.font = boldFont
    }

    
    
    
    @available(iOS 10.0, *)
    func userNotificationCenter(center: UNUserNotificationCenter, willPresentNotification notification: UNNotification, withCompletionHandler completionHandler: (UNNotificationPresentationOptions) -> Void) {
        //Handle the notification
        print("User Info = ",notification.request.content.userInfo)
        self.navigateToNotificationTab()
        completionHandler([.sound, .badge, .list])
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(center: UNUserNotificationCenter, didReceiveNotificationResponse response: UNNotificationResponse, withCompletionHandler completionHandler: () -> Void) {
        //Handle the notification
        print("User Info = ",response.notification.request.content.userInfo)
        // Call your navigation method
        self.navigateToNotificationTab()
        completionHandler()
    }
}

extension AppDelegate{
    
    func LoginNavigation(){
        let sb = UIStoryboard(name: "Main", bundle: Bundle.main)
        navController = sb.instantiateViewController(withIdentifier: "HomeNav") as? UINavigationController
        self.window?.rootViewController = navController
        self.window?.makeKeyAndVisible()
    }
    
    func AuthNavigation(){
        let sb = UIStoryboard(name: "Main", bundle: Bundle.main)
        navController = sb.instantiateViewController(withIdentifier: "AuthNav") as? UINavigationController
        self.window?.rootViewController = navController
        self.window?.makeKeyAndVisible()
    }
    
    func settingRootController() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewController") as! ViewController
        appDelegate.window?.rootViewController = vc
    }
    
}

//MARK:- notification setup
extension AppDelegate:UNUserNotificationCenterDelegate{
    
    func registerForRemoteNotification() {
        // iOS 10 support
        if #available(iOS 10, *) {
            let authOptions : UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(options:authOptions){ (granted, error) in
                UNUserNotificationCenter.current().delegate = self as UNUserNotificationCenterDelegate
                Messaging.messaging().delegate = self
                let deafultCategory = UNNotificationCategory(identifier: "CustomSamplePush", actions: [], intentIdentifiers: [], options: [])
                let center = UNUserNotificationCenter.current()
                center.setNotificationCategories(Set([deafultCategory]))
            }
        }else {
            
            let settings: UIUserNotificationSettings =
            UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
        }
        UIApplication.shared.registerForRemoteNotifications()
        NotificationCenter.default.addObserver(self, selector:
                                                #selector(tokenRefreshNotification), name:
                                                Notification.Name.MessagingRegistrationTokenRefreshed, object: nil)
    }
}


//MARK: - FireBase Methods / FCM Token
extension AppDelegate : MessagingDelegate{
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(String(describing: fcmToken))")
        objAppShareData.strFirebaseToken = fcmToken ?? ""
        
    }
    
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        objAppShareData.strFirebaseToken = fcmToken
        ConnectToFCM()
    }
    
    @objc func tokenRefreshNotification(_ notification: Notification) {
        
        Messaging.messaging().token  { (token, error) in
            if let error = error {
                print("Error fetching remote instange ID: \(error)")
            }else if let token = token {
                print("Remote instance ID token: \(token)")
                // objAppShareData.strFirebaseToken = result.token
                print("objAppShareData.firebaseToken = \(token)")
            }
        }
        // Connect to FCM since connection may have failed when attempted before having a token.
        ConnectToFCM()
    }
    
    func ConnectToFCM() {
        
        Messaging.messaging().token { token, error in
            
            if let error = error {
                print("Error fetching remote instange ID: \(error)")
            }else if let token = token {
                print("Remote instance ID token: \(token)")
                //   objAppShareData.strFirebaseToken = result.token
                print("objAppShareData.firebaseToken = \(token)")
            }
        }
    }
    
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        if let userInfo = notification.request.content.userInfo as? [String : Any]{
            print(userInfo)
            
            // Increment the badge count when a notification is received while the app is in the foreground
            // badgeCount += 1
            // NotificationCenter.default.post(name: Notification.Name("BadgeCountUpdated"), object: nil)
            self.navigateToNotificationTab()
            
        }
        
        completionHandler([.badge,.sound,.banner,.list])
    }
    
    func navWithNotification(type:String,bookingID:String){
        
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        //NotificationCenter.default.post(name: Notification.Name("BadgeCountUpdated"), object: nil)
        // badgeCount = 0
    }
    
    //TODO: called When you tap on the notification in background
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: () -> Void) {
        print(response)
        switch response.actionIdentifier {
        case UNNotificationDismissActionIdentifier:
            print("Dismiss Action")
        case UNNotificationDefaultActionIdentifier:
            print("Open Action")
            // Reset the badge count when the user opens the app by tapping on the notification
            //   badgeCount = 0
            //   NotificationCenter.default.post(name: Notification.Name("BadgeCountUpdated"), object: nil)
            if let userInfo = response.notification.request.content.userInfo as? [String : Any]{
                print(userInfo)
                self.navigateToNotificationTab()
               // self.handleNotificationWithNotificationData(dict: userInfo)
            }
           
        case "Snooze":
            print("Snooze")
        case "Delete":
            print("Delete")
        default:
            print("default")
        }
        completionHandler()
    }
    
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        debugPrint("Received: \(userInfo)")
        completionHandler(.newData)
    }
    
    //
    
    
    
    func handleNotificationWithNotificationData(dict:[String:Any]){
        print(dict)
        let userID = dict["gcm.notification.user_request_id"]as? String ?? ""
        print(userID)
    }
}


extension AppDelegate{
    
    func topViewController(controller: UIViewController? = {
        // Get the connected scenes
        return UIApplication.shared
            .connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }?.rootViewController
    }()) -> UIViewController? {
        
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
    
    func navigateToNotificationTab() {
        // Check if root is UINavigationController
        if let navController = window?.rootViewController as? UINavigationController {
            
            // Check if TabBarViewController is the first view controller in the navigation stack
            if let tabBarController = navController.viewControllers.first as? UITabBarController {
                
                // Ensure index 1 exists
                if tabBarController.viewControllers?.indices.contains(1) == true {
                    tabBarController.selectedIndex = 1
                    
                    // Access the NotificationViewController if embedded in UINavigationController
                    if let notificationNav = tabBarController.viewControllers?[1] as? UINavigationController,
                       let notificationVC = notificationNav.viewControllers.first as? NotificationViewController {
                        
                        // Call your method
                      //  notificationVC.refreshDataIfNeeded()
                    }
                } else {
                    print("⚠️ TabBar does not have a view controller at index 1")
                }
            } else {
                print("⚠️ UINavigationController does not contain a UITabBarController")
            }
        } else if let tabBarController = window?.rootViewController as? UITabBarController {
            // Fallback if root is TabBarController directly
            if tabBarController.viewControllers?.indices.contains(1) == true {
                tabBarController.selectedIndex = 1
                
                if let notificationNav = tabBarController.viewControllers?[1] as? UINavigationController,
                   let notificationVC = notificationNav.viewControllers.first as? NotificationViewController {
                  //  notificationVC.refreshDataIfNeeded()
                }
            }
        } else {
            print("⚠️ rootViewController is neither UINavigationController nor UITabBarController")
        }
    }


    
}

