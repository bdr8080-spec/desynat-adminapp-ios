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
        var param: [String: Any] = ["title_english": hostVC.titleInEnglishTF.text?.trimmed() ?? "",
                                    "title_arabic": hostVC.titleInArabicTF.text?.trimmed() ?? "",
                                    "description_english": hostVC.decriptionInEnglishTF.text?.trimmed() ?? "",
                                    "description_arabic": hostVC.decriptionInArabicTF.text?.trimmed() ?? "",
                                    "sender_type":1 ]//1-admin,2-user,3-seller,4-affiliate,5-driver
        switch hostVC.selectedRoleIndex {
        case 0:
            param["user_id"] = hostVC.selecteUserId
        case 1:
            param["seller_id"] = hostVC.selecteDealerId
        case 2:
            param["driver_id"] = hostVC.selecteDriverId
        default:
            param["affiliate_id"] = hostVC.selecteDriverId
        }
        WebService.shared.sendNotificationsService(parameter: param) { [weak self] response in
            guard let self = self else { return }
            CommonUtils.showToast(message: "New Notification sent successfully")
            self.hostVC.navigationController?.popViewController(animated: true)
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
            
        case 0: // Customer
            getAllUsers {
                let data = self.usersListData.map {
                    SelectableUser(id: $0.id ?? 0, name: $0.fullName ?? "")
                }
                completion(data)
            }
            
        case 1: // Seller
            getApprovedSellers {
                let data = self.sellersListData.map {
                    SelectableUser(id: $0.id ?? 0, name: ($0.firstName ?? "") + ($0.lastName ?? ""))
                }
                completion(data)
            }
            
        case 2: // Driver
            getAllDeliveryBoy {
                let data = self.boysListData.map {
                    SelectableUser(id: $0.id ?? 0, name: $0.fullNameEnglish ?? "")
                }
                completion(data)
            }
            
        default: // Affiliate
            fetchApprovedAffiliatedUsersList {
                let data = self.affilitaitedUsersListData.map {
                    SelectableUser(id: $0.id ?? 0, name: $0.fullName ?? "")
                }
                completion(data)
            }
        }
    }
}
