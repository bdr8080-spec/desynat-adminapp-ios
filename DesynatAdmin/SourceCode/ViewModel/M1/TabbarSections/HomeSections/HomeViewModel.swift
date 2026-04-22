//
//  HomeViewModel.swift
//  DesynatAdmin
//
//  Created by Rakhi Kumari on 01/11/25.
//

import Foundation
import UIKit
import SDWebImage

class HomeViewModel {
    
    private var hostVC: HomeViewController
    var countryListData: [GetCountryDataModel] = []
    var userProfileData: UserModel?
    
    init(hostVC: HomeViewController) {
        self.hostVC = hostVC
    }
    
    func getCountOfNotificationRequest(){
        WebService.sharedInstance.getCountOfNotificationForService { [self] count in
            if count > 0 {
                self.hostVC.notificationCountView.isHidden = false
                self.hostVC.notificationCountLabel.text = count.description
            } else {
                self.hostVC.notificationCountView.isHidden = true
            }
        }
    }
    
    func getAllCountry() {
        WebService.shared.getAllCountry(){ [weak self] response in
            guard let self = self else { return }
            countryListData = response
            hostVC.countryTableView.reloadData()
        }
    }
    
    func getUserProfile(){
        WebService.sharedInstance.getProfileService { [weak self] savedUser in
            guard let self else { return }
            userProfileData = savedUser
            if let imageUrlString = savedUser.profileImage,
               let url = URL(string: imageUrlString) {
                hostVC.userProfileImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
                hostVC.userProfileImageView.sd_imageIndicator?.startAnimatingIndicator()
                hostVC.userProfileImageView.sd_setImage(with: url, placeholderImage: .userProfile)
            } else {
                hostVC.userProfileImageView.image = .userProfile
            }
            hostVC.usernameLabel.text = "Hi \(savedUser.fullName ?? "")"
        }
    }

}
