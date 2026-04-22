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
    
    // Navigate to Home Vc
    public func navigateToUserHomeVc() {
        let vc = TabBarVC.instantiate(fromAppStoryboard: .Home)
        navigateTo(vc: vc)
    }
    
    public func navigateToSideMenuVc() {
        let vc = SubAdminSideMenuViewController.instantiate(fromAppStoryboard: .SideMenu)
        vc.isNeedToHideBackButton = true
        navigateTo(vc: vc)
    }
    
    // Logout current user and navigate to loginVc
    func logoutUser() {
        Global.shared.user = nil
        kSharedUserDefaults.clearAllData(except: [.deviceToken,.selectedLanguage,.defaultLanguage,.language,])
        UserDefaults.standard.set("no", forKey: "login")
        navigateToLoginVc()
    }
    
    public func navigateToLoginVc() {
        navigateTo(vc: LoginViewController.instantiate(fromAppStoryboard: .Main))
    }
    
    //Pass custom vc to make it root controller
    public func navigateTo(vc:UIViewController) {
        let nc = UINavigationController(rootViewController: vc)
        nc.isNavigationBarHidden = true
        let sceneDelegate = UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate
        sceneDelegate.window!.rootViewController = nc
        sceneDelegate.window!.makeKeyAndVisible()
    }
    
}
