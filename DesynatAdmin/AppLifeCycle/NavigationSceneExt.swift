////
////  NavigationSceneExt.swift
////  ChorApp
////
////  Created by Developer on 18/12/23.
////
//
import Foundation
import UIKit                 

extension SceneDelegate {
   
    /// Initialize Application (Reset Application)

    // Navigate to Home Vc
    public func navigateToUserHomeVc() {
        let vc = TabBarVC.instantiate(fromAppStoryboard: .Home)
        navigateTo(vc: vc)
    }

//    /// Logout current user and navigate to loginVc
    func logoutUser() {
        Global.shared.user = nil
        kSharedUserDefaults.clearAllData(except: [.deviceToken,.selectedLanguage,.defaultLanguage,.language,])
        UserDefaults.standard.set("no", forKey: "login")
        navigateToLoginVc()
    }
    
    public func navigateToLoginVc() {
        navigateTo(vc: LoginViewController.instantiate(fromAppStoryboard: .Main))
    }
//
//    ///Pass custom vc to make it root controller
    public func navigateTo(vc:UIViewController) {
        let nc = UINavigationController(rootViewController: vc)
        nc.isNavigationBarHidden = true
        let sceneDelegate = UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate
        sceneDelegate.window!.rootViewController = nc
        sceneDelegate.window!.makeKeyAndVisible()
    }
    
    
}

//extension AppDelegate {
//    func makeRootViewController(selectedIndex:Int) {
//        kSharedUserDefaults.setUserLoggedIn(userLoggedIn: true)
//        let vc = TabBarVC.instantiate(fromAppStoryboard: .Home)
//        let navigationController = UINavigationController(rootViewController: vc)
//        navigationController.setNavigationBarHidden(true, animated: true)
//        UIApplication.shared.windows.first?.rootViewController = navigationController
//        UIApplication.shared.windows.first?.makeKeyAndVisible()
//    }
//}
