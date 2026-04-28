//
//  SceneDelegate.swift
//  DemoProject
//
//  Created by Rakhi Kumari on 22/09/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        if kSharedUserDefaults.isUserLoggedIn() {
            if let savedUser: UserModel = kSharedUserDefaults.retrieveModelFor(key: .user, model: UserModel.self) {
                if savedUser.type == "2" {
                    self.getStaffDetails()
                } else {
                    kSharedSceneDelegate.navigateToUserHomeVc()
                }
            }
        }
        guard let _ = (scene as? UIWindowScene) else { return }
    }
    
    func getStaffDetails() {
        if kSharedUserDefaults.isSubAdminUserHasDashboardAccess() {
//            kSharedSceneDelegate.navigateToUserHomeVc()
            kSharedSceneDelegate.navigateToDashboardHomeVc()
        } else {
            kSharedSceneDelegate.navigateToSideMenuVc()
        }
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {}
    
    func sceneWillResignActive(_ scene: UIScene) {}
    
    func sceneWillEnterForeground(_ scene: UIScene) {}
    
    func sceneDidEnterBackground(_ scene: UIScene) {}
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        BadgeManager.reset()
    }
}

