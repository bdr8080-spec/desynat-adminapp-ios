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
    
    func saveCSVFile(csvString: String) -> URL? {
        let fileName = "DashboardData".localiz()
        let path = FileManager.default.temporaryDirectory.appendingPathComponent("\(fileName).csv")
        do {
            try csvString.write(to: path, atomically: true, encoding: .utf8)
            return path
        } catch {
            return nil
        }
    }
    
    func generateDashboardCSV() -> String {
        guard let data = adminDashboardData else { return "" }
        var csv = "\"\("Title".localiz())\",\"\("Value".localiz())\"\n"
        csv += "\"\("Total Revenue".localiz())\",\"\(data.totalRevenue ?? "0")\"\n"
        csv += "\"\("By Order".localiz())\",\"\(data.totalOrderRevenue ?? "0")\"\n"
        csv += "\"\("By Subscription".localiz())\",\"\(data.totalSubscriptionPlanRevenue ?? "0")\"\n"
        csv += "\"\("By Affiliate Orders".localiz())\",\"\(data.totalAffiliateOrdersRevenue ?? "0")\"\n"
        csv += "\"\("By Banner".localiz())\",\"\(data.totalBannerRevenue ?? "0")\"\n"
        csv += "\"\("Total Users Registered".localiz())\",\"\(data.totalUsers ?? 0)\"\n"
        csv += "\"\("Active Users".localiz())\",\"\(data.totalActiveUsers ?? 0)\"\n"
        csv += "\"\("Inactive Users".localiz())\",\"\(data.totalInactiveUsers ?? 0)\"\n"
        csv += "\"\("Total Affiliated".localiz())\",\"\(data.totalAffiliateUsers ?? 0)\"\n"
        csv += "\"\("Active Affiliated".localiz())\",\"\(data.totalActiveAffiliateUsers ?? 0)\"\n"
        csv += "\"\("Inactive Affiliated".localiz())\",\"\(data.totalInactiveAffiliateUsers ?? 0)\"\n"
        csv += "\"\("Total Drivers".localiz())\",\"\(data.totalDeliveryBoy ?? 0)\"\n"
        csv += "\"\("Active Drivers".localiz())\",\"\(data.totalActiveDeliveryBoy ?? 0)\"\n"
        csv += "\"\("Inactive Drivers".localiz())\",\"\(data.totalInactiveDeliveryBoy ?? 0)\"\n"
        csv += "\"\("Total Sellers".localiz())\",\"\(data.totalSellers ?? 0)\"\n"
        csv += "\"\("Active Sellers".localiz())\",\"\(data.totalActiveSellers ?? 0)\"\n"
        csv += "\"\("Inactive Sellers".localiz())\",\"\(data.totalInactiveSellers ?? 0)\"\n"
        csv += "\"\("Total Orders".localiz())\",\"\(data.totalOrders ?? 0)\"\n"
        csv += "\"\("Returned Orders".localiz())\",\"\(data.totalReturnedOrders ?? 0)\"\n"
        csv += "\"\("Ongoing Orders".localiz())\",\"\(data.totalOngoingOrders ?? 0)\"\n"
        csv += "\"\("Completed Orders".localiz())\",\"\(data.totalCompletedOrders ?? 0)\"\n"
        csv += "\"\("Cancelled Orders".localiz())\",\"\(data.totalCancelledOrders ?? 0)\"\n"
        csv += "\"\("Total Tickets".localiz())\",\"\(data.totalTickets ?? 0)\"\n"
        csv += "\"\("Resolved Tickets".localiz())\",\"\(data.totalResolvedTickets ?? 0)\"\n"
        csv += "\"\("Unresolved Tickets".localiz())\",\"\(data.totalUnresolvedTickets ?? 0)\"\n"
        csv += "\"\("Total Online Users".localiz())\",\"\(data.totalOnlineUsers ?? 0)\"\n"
        csv += "\"\("App Visitors".localiz())\",\"\(data.totalAppVisitorUsers ?? 0)\"\n"
        csv += "\"\("Website Visitors".localiz())\",\"\(data.totalWebsiteVisitorUsers ?? 0)\"\n"
        return csv
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
