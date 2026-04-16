//
//  SideMenuViewModel.swift
//  DesynatAdmin
//
//  Created by Rakhi Kumari on 01/11/25.
//

import Foundation
import UIKit

class SideMenuViewModel {
    
    private var hostVC: SideMenuViewController
    
    init(hostVC: SideMenuViewController) {
        self.hostVC = hostVC
    }
    
    func logoutAPI(){
        WebService.sharedInstance.logoutService() { (response) in
            kSharedSceneDelegate.logoutUser()
        }
    }
    
    func getUserData() {
        if let savedUser: UserModel = kSharedUserDefaults.retrieveModelFor(key: .user, model: UserModel.self) {
            hostVC.usernameLabel.text = savedUser.fullName
            hostVC.emailLabel.text = savedUser.email
            if let imageUrlString = savedUser.profileImage,
               let url = URL(string: imageUrlString) {
                hostVC.userProfileImageView.sd_setImage(with: url, placeholderImage: .userProfile)
            } else {
                hostVC.userProfileImageView.image = .userProfile
            }
        }
    }

}
