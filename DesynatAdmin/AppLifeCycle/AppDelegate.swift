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

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var forOpenFilePickerView = ""
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        IQKeyboardManager.shared.enableAutoToolbar = true
        IQKeyboardManager.shared.isEnabled = true
        UIScrollView.appearance().showsVerticalScrollIndicator = false
        UIScrollView.appearance().showsHorizontalScrollIndicator = false
        GMSServices.provideAPIKey("AIzaSyBlCfJlRuxElolt6l-4erdJPR9ySUB8Jwk")    // Our google map API
        GMSPlacesClient.provideAPIKey("AIzaSyAekJV3oxQlPy_OWHCxPYfFw5CnrD-Wzkg")
        LocationManager.sharedInstance.startUpdatingLocation()
        ImagePickerManager.shared.requestMediaPermissions()
        UNUserNotificationCenter.current().delegate = self
        requestNotificationPermission()
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
            print("Selected item: \(item) at index: \(index)")
            completion(index,item)
            
        }
    }
    
}

// MARK: - Permissions
extension AppDelegate {
    
    func requestNotificationPermission() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Notification permission error: \(error.localizedDescription)")
            } else {
                print("Notification permission granted: \(granted)")
                if granted {
                    DispatchQueue.main.async {
                        UIApplication.shared.registerForRemoteNotifications()
                    }
                }
            }
        }
    }
}

extension AppDelegate {
    
    func requestPushPermission(_ application: UIApplication) {
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                DispatchQueue.main.async {
                    application.registerForRemoteNotifications()
                }
            } else {
                print("Permission denied")
            }
        }
    }
    
    // Called when APNs registration succeeds
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        kSharedUserDefaults.saveModelFor(key: .deviceToken, value: token)
        print("Device Token: \(token)")
    }
    
    // Called when APNs registration fails
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register for remote notifications: \(error.localizedDescription)")
    }
}


extension AppDelegate: UNUserNotificationCenterDelegate {
    
    // When app is in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler:
                                @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound, .badge])
    }
    
    // When user taps notification
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        print("Notification Data: \(userInfo)")
        completionHandler()
    }
    
}
