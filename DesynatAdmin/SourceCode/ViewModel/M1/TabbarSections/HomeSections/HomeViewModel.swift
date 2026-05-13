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
    var countryListData: [GetAllUserCountryModel] = []
    var userProfileData: UserModel?
    var dashboardFilter = AdminDashboardFilterModel()
    var adminDashboardData: AdminHomeDashboardDataModel?
    
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
        WebService.shared.getAllUsersCountryList(){ [weak self] response in
            guard let self = self else { return }
            countryListData = response
            hostVC.countryTableView.reloadData()
            self.hostVC.setDefaultSelection()
            self.hostVC.callDashboardAPI()
        }
    }
    
    func getUserData() {
        if let savedUser: UserModel = kSharedUserDefaults.retrieveModelFor(key: .user, model: UserModel.self) {
            userProfileData = savedUser
            if savedUser.type == "2" {
                getSubAdminProfile(userId: savedUser.id ?? 0)
            } else {
                getAdminProfile()
            }
        }
    }
    
    func getSubAdminProfile(userId: Int) {
        let param: [String:Any] = ["id": userId]
        WebService.shared.getSubAdminProfileDetailsService(param: param) { [weak self] response in
            guard let self = self else { return }
            if response.permissionDetails?.first?.moduleID == 1 {
                kSharedUserDefaults.setSubAdminUserHasDashboardAccess(hasDashboardAccess: true)
                if response.permissionDetails?.first?.moduleID == 1 && response.permissionDetails?.first?.canAction == 1 {
                    kSharedUserDefaults.setSubAdminActionDashboardAccess(hasActionDashboardAccess: true)
                }
            } else {
                kSharedSceneDelegate.navigateToSideMenuVc()
            }
            DispatchQueue.main.async {
                if let imageUrlString = response.profilePic,
                   let url = URL(string: imageUrlString) {
                    self.hostVC.userProfileImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
                    self.hostVC.userProfileImageView.sd_imageIndicator?.startAnimatingIndicator()
                    self.hostVC.userProfileImageView.sd_setImage(with: url, placeholderImage: .userProfile)
                } else {
                    self.hostVC.userProfileImageView.image = .userProfile
                }
                let isArabic = AppLanguageManager.shared.currentLanguage == .ar
                let showNameText = isArabic ? "\("Hi".localiz()) \(response.fullNameInArabic ?? "")" : "\("Hi".localiz()) \(response.fullName ?? "")"
                self.hostVC.usernameLabel.text = showNameText
            }
        }
    }
    
    
    func getAdminProfile(){
        WebService.sharedInstance.getProfileService { [weak self] savedUser in
            guard let self else { return }
            kSharedUserDefaults.setSubAdminActionDashboardAccess(hasActionDashboardAccess: true)
            if let imageUrlString = savedUser.profileImage,
               let url = URL(string: imageUrlString) {
                hostVC.userProfileImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
                hostVC.userProfileImageView.sd_imageIndicator?.startAnimatingIndicator()
                hostVC.userProfileImageView.sd_setImage(with: url, placeholderImage: .userProfile)
            } else {
                hostVC.userProfileImageView.image = .userProfile
            }
            self.hostVC.usernameLabel.text = "\("Hi".localiz()) \(savedUser.fullName ?? "")"
        }
    }
    
    func getDashboardData(filterIndex: Int?,
                          countryId: Int?,
                          fromDate: String?,
                          toDate: String?) {
        
        var params: [String: Any] = [:]
        
        // ✅ ONLY send filter if user selected it
        if let filterIndex {
            params["filter"] = filterIndex + 1 //1-today,2-this week,3-this month,4-this year
        }
        
        //        if let countryId {
        //            params["country_id"] = countryId
        //        }
        
        if let fromDate, let toDate,
           !fromDate.isEmpty, !toDate.isEmpty {
            params["from_date"] = fromDate
            params["to_date"] = toDate
        }
        
        WebService.sharedInstance.getDashboardDataService(param: params) { data in
            self.adminDashboardData = data
            self.hostVC.configData()
        }
    }
}

struct AdminDashboardFilterModel {
    var fromDate: String?
    var toDate: String?
    var filter: Int?
    var countryId: Int?
    
    var isEmpty: Bool {
        return fromDate == nil && toDate == nil && filter == nil && countryId == nil
    }
}
