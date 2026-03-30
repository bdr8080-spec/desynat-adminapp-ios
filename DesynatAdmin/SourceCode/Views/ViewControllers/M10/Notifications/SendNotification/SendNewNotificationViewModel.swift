//
//  SendNewNotificationViewModel.swift
//  DesynatAdmin
//
//  Created by fluper_mac3 on 17/03/26.
//

import Foundation

class SendNewNotificationViewModel {
    
    private var hostVC: SendNewNotificationViewController
    var boysListData: [DeliveryBoysList] = []
    var usersListData: [UsersListModel] = []
    var sellersListData: [SellerDataModel] = []
    var affilitaitedUsersListData: [AffilitaitedUsersDataModel] = []
    
    init(hostVC: SendNewNotificationViewController) {
        self.hostVC = hostVC
    }
    
    func validFields() -> Bool {
        var errorMessage: AlertConstant = .none
        
        //Title
        let titleInEng = String.getString(hostVC.titleInEnglishTF.text)
            .trimmingCharacters(in: .whitespacesAndNewlines)
        
        if errorMessage == .none && titleInEng.isEmpty {
            errorMessage = .enterNotificationTitleInEng
        }
        
        let titleInArabic = String.getString(hostVC.titleInArabicTF.text)
            .trimmingCharacters(in: .whitespacesAndNewlines)
        
        if errorMessage == .none && titleInArabic.isEmpty {
            errorMessage = .enterNotificationTitleInArabic
        }
        
        //Description
        let descInEng = String.getString(hostVC.decriptionInEnglishTF.text)
            .trimmingCharacters(in: .whitespacesAndNewlines)
        
        if errorMessage == .none && descInEng.isEmpty {
            errorMessage = .enterNotificationDescInEng
        }
        
        let descInArabic = String.getString(hostVC.decriptionInArabicTF.text)
            .trimmingCharacters(in: .whitespacesAndNewlines)
        
        if errorMessage == .none && descInArabic.isEmpty {
            errorMessage = .enterNotificationDescInArabic
        }
        
        //Country
        //        if errorMessage == .none && hostVC.selectedRoleIndex == 0 {
        //            errorMessage = .selectRoleForNotification
        //        }
        
        if errorMessage != .none {
            hostVC.showAlert(msg: errorMessage.rawValue)
            hostVC.view.endEditing(true)
            return false
        }
        
        hostVC.view.endEditing(true)
        return true
    }
    
    func sendNotificationsRequest() {
        
        var param: [String: Any] = [
            "title_english": hostVC.titleInEnglishTF.text?.trimmed() ?? "",
            "title_arabic": hostVC.titleInArabicTF.text?.trimmed() ?? "",
            "description_english": hostVC.decriptionInEnglishTF.text?.trimmed() ?? "",
            "description_arabic": hostVC.decriptionInArabicTF.text?.trimmed() ?? "",
            "sender_type": 1
        ]
        
        switch hostVC.selectedRoleIndex {
            
        case 0:
            // 👉 ALL → send everything
            param["user_id"] = hostVC.selecteUserId
            param["seller_id"] = hostVC.selecteDealerId
            param["driver_id"] = hostVC.selecteDriverId
            param["affiliate_id"] = hostVC.selecteAffilatedId
            
        case 1:
            param["user_id"] = hostVC.selecteUserId
            
        case 2:
            param["seller_id"] = hostVC.selecteDealerId
            
        case 3:
            param["driver_id"] = hostVC.selecteDriverId
            
        case 4:
            param["affiliate_id"] = hostVC.selecteAffilatedId
            
        default:
            break
        }
        
        hitSendNotificationAPI(param: param)
    }
    
    private func hitSendNotificationAPI(param: [String: Any]) {
        print("param===>\(param)")
        WebService.shared.sendNotificationsService(parameter: param) { [weak self] response in
            guard let self = self else { return }
            CommonUtils.showToast(message: "New Notification sent successfully")
            self.hostVC.navigationController?.popViewController(animated: true)
        }
    }
    
    private func fetchAllIdsAndSend(param: [String: Any]) {
        
        let group = DispatchGroup()
        
        var allUserIds: [Int] = []
        var allSellerIds: [Int] = []
        var allDriverIds: [Int] = []
        var allAffiliateIds: [Int] = []
        
        // Users
        group.enter()
        getAllUsers {
            allUserIds = self.usersListData.compactMap { $0.id }
            group.leave()
        }
        
        // Sellers
        group.enter()
        getApprovedSellers {
            allSellerIds = self.sellersListData.compactMap { $0.id }
            group.leave()
        }
        
        // Drivers
        group.enter()
        getAllDeliveryBoy {
            allDriverIds = self.boysListData.compactMap { $0.id }
            group.leave()
        }
        
        // Affiliates
        group.enter()
        fetchApprovedAffiliatedUsersList {
            allAffiliateIds = self.affilitaitedUsersListData.compactMap { $0.id }
            group.leave()
        }
        
        group.notify(queue: .main) {
            var updatedParam = param
            updatedParam["user_id"] = allUserIds
            updatedParam["seller_id"] = allSellerIds
            updatedParam["driver_id"] = allDriverIds
            updatedParam["affiliate_id"] = allAffiliateIds
            
            self.hitSendNotificationAPI(param: updatedParam)
        }
    }
    
    func getAllUsers(completion: @escaping () -> Void) {
        WebService.shared.getAllUsersListWithoutPagination { [weak self] response in
            guard let self = self else { return }
            self.usersListData = response
            completion()
        }
    }
    
    func getAllDeliveryBoy(completion: @escaping () -> Void) {
        WebService.shared.getAllDeliveryBoysWithoutPagination { [weak self] response in
            guard let self = self else { return }
            self.boysListData = response
            completion()
        }
    }

    func getApprovedSellers(completion: @escaping () -> Void) {
        WebService.shared.getApprovedSellersWithoutPagination { [weak self] response in
            guard let self = self else { return }
            self.sellersListData = response
            completion()
        }
    }

    func fetchApprovedAffiliatedUsersList(completion: @escaping () -> Void) {
        WebService.shared.getApprovedAffilaitedUsersRequestWithputPagination{ [weak self] response in
            guard let self = self else { return }
            self.affilitaitedUsersListData = response
            completion()
        }
    }
    
    func getUsersForSelectedRole(roleIndex: Int, completion: @escaping ([SelectableUser]) -> Void) {
        
        switch roleIndex {
            
        case 1: // Customer
            getAllUsers {
                let data = self.usersListData.map {
                    SelectableUser(id: $0.id ?? 0, name: $0.fullName ?? "")
                }
                completion(data)
            }
            
        case 2: // Seller
            getApprovedSellers {
                let data = self.sellersListData.map {
                    SelectableUser(id: $0.id ?? 0, name: ($0.firstName ?? "") + ($0.lastName ?? ""))
                }
                completion(data)
            }
            
        case 3: // Driver
            getAllDeliveryBoy {
                let data = self.boysListData.map {
                    SelectableUser(id: $0.id ?? 0, name: $0.fullNameEnglish ?? "")
                }
                completion(data)
            }
            
        case 4: // Affiliate
            fetchApprovedAffiliatedUsersList {
                let data = self.affilitaitedUsersListData.map {
                    SelectableUser(id: $0.id ?? 0, name: $0.fullName ?? "")
                }
                completion(data)
            }
        default:
            print("all")
        }
    }
}
