//
//  AppDelegate.swift
//  DemoProject
//
//  Created by Rakhi Kumari on 22/09/25.
//

import UIKit
import GoogleMaps
import GooglePlaces
import IQKeyboardManagerSwift
import DropDown
import UserNotifications
import FirebaseCore
import FirebaseMessaging
import MFSDK

@main
class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate {
    
    var forOpenFilePickerView = ""
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        IQKeyboardManager.shared.enableAutoToolbar = true
        IQKeyboardManager.shared.isEnabled = true
        UIScrollView.appearance().showsVerticalScrollIndicator = false
        UIScrollView.appearance().showsHorizontalScrollIndicator = false
        GMSServices.provideAPIKey("AIzaSyBlCfJlRuxElolt6l-4erdJPR9ySUB8Jwk")    // Our google map API
        GMSPlacesClient.provideAPIKey("AIzaSyB5LK7zzKS4q9ov0R4LFLgaRyPZdZsTKz4")
        LocationManager.sharedInstance.startUpdatingLocation()
        ImagePickerManager.shared.requestMediaPermissions()
        AppLanguageManager.shared.defaultLanguage = .ar
        UNUserNotificationCenter.current().delegate = self
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        Messaging.messaging().isAutoInitEnabled = true
        confrigNotification(application: application)
        BadgeManager.reset()
        MFSettings.shared.configure(token: "SK_KWT_Xn6nYzfdgF3Lz7TKhrGLhruKiBT5OgesD080ZIJohon0q0CEqCRrwdAsV0qICIsx", country: .kuwait, environment: MFEnvironment.live)
//        MFSettings.shared.configure(token: "SK_KWT_vVZlnnAqu8jRByOWaRPNId4ShzEDNt256dvnjebuyzo52dXjAfRx2ixW5umjWSUx", country: .kuwait, environment: MFEnvironment.test)
        let them = MFTheme(navigationTintColor: .white, navigationBarTintColor: .lightGray, navigationTitle: "Payment", cancelButtonTitle: "Cancel")
        MFSettings.shared.setTheme(theme: them)
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {}
    
    func dropDown(dataSource:[String] , anchorView:UIView , completion: @escaping (  _ index: Int ,  _ item: String) -> ()) -> Void {
        let dropDown = DropDown()
        dropDown.anchorView = anchorView
        dropDown.dataSource = dataSource
        dropDown.backgroundColor = UIColor.white
        dropDown.textColor = .black
        dropDown.direction = .bottom
        dropDown.selectionBackgroundColor = UIColor.white
        dropDown.selectedTextColor = .black
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.dismissMode = .automatic
        dropDown.show()
        dropDown.selectionAction = {(index: Int, item: String) in
//            print("Selected item: \(item) at index: \(index)")
            completion(index,item)
            
        }
    }
    
}

extension AppDelegate:UNUserNotificationCenterDelegate {
    
    func confrigNotification(application:UIApplication) {
        UNUserNotificationCenter.current().delegate = self
        
        let options: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { granted, error in
            guard granted else { return }
            DispatchQueue.main.async {
                application.registerForRemoteNotifications()  // only once
            }
        }
    }
    
    private func registerForPushNotification(_ application: UIApplication) {
        let current = UNUserNotificationCenter.current()
        current.delegate = self
        current.requestAuthorization(options: [.alert, .badge, .sound]) { (flag, error) in
            if error == nil {
                DispatchQueue.main.async {
                    application.registerForRemoteNotifications()
                }
            }
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
        Messaging.messaging().setAPNSToken(deviceToken,type: .unknown)
        let tokenParts = deviceToken.map { data in
                String(format: "%02.2hhx", data)
            }

            print("APNs Token: \(tokenParts.joined())")
        fetchFirebaseToken()
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        kSharedUserDefaults.saveValue(Key: .deviceToken, value: fcmToken)
    }
    
    fileprivate func fetchFirebaseToken() {
        Messaging.messaging().token { token, error in
            if let error = error {
                print("Error fetching remote instange ID: \(error)")
            } else if let result = token {
                print("token=======>\(token)")
                kSharedUserDefaults.saveModelFor(key: .deviceToken, value: token)
            }
        }
    }
    
    func applicationWillTerminate(_ application: UIApplication) {}
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        BadgeManager.increase()
        if #available(iOS 14.0, *) {
            completionHandler([.banner, .badge, .sound])
        } else {
            completionHandler([.alert, .badge, .sound])
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        BadgeManager.increase()
        completionHandler()
    }
    
}
