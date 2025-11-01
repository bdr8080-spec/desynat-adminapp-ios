//
//  HomeViewModel.swift
//  DesynatAdmin
//
//  Created by Rakhi Kumari on 01/11/25.
//

import Foundation
import UIKit

class HomeViewModel {
    
    private var hostVC: HomeViewController
    var countryListData: [GetCountryDataModel] = []
    
    init(hostVC: HomeViewController) {
        self.hostVC = hostVC
    }
    
    func getAllCountry() {
        WebService.shared.getAllCountry(){ [weak self] response in
            guard let self = self else { return }
            countryListData = response
            hostVC.countryTableView.reloadData()
        }
    }
    
    func getUserData() {
        if let savedUser: UserModel = kSharedUserDefaults.retrieveModelFor(key: .user, model: UserModel.self) {
            hostVC.usernameLabel.text = savedUser.fullName
            if let imageUrlString = savedUser.profileImage,
               let url = URL(string: imageUrlString) {
                hostVC.userProfileImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"))
            } else {
                hostVC.userProfileImageView.image = UIImage(named: "placeholder")
            }
        }
    }

}
