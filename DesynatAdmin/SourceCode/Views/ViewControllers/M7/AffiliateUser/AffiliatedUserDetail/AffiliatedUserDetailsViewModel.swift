//
//  AffiliatedUserDetailsViewModel.swift
//  DesynatAdmin
//
//  Created by fluper_mac3 on 22/01/26.
//

import Foundation

class AffiliatedUserDetailsViewModel {
    
    private var hostVC: AffiliatedUserDetailsViewController?
    var affilitaitedUsers: AffilitaitedUsersDataModel?
    
    init(hostVC: AffiliatedUserDetailsViewController? = nil) {
        self.hostVC = hostVC
    }
    
    func getAffilitaedUserDetails() {
        let param: [String: Any] = ["user_id": hostVC?.userId ?? 0]
        WebService.shared.getAffilaitedUsersDetailsRequest(param: param) { [weak self] response in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.affilitaitedUsers = response
                self.hostVC?.configUserData(userData: self.affilitaitedUsers)
            }
        }
    }
    
    func upadteUserStatus(param: [String: Any]) {
        WebService.shared.blockUnblockAffilaitedUsersRequest(param: param) { [weak self] response in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if let status = self.affilitaitedUsers?.status {
                    if status == "1" {
                        CommonUtils.showToast(message: "Affiliated User Blocked Successfully".localiz())
                    } else {
                        CommonUtils.showToast(message: "Affiliated User Unblocked Successfully".localiz())
                    }
                }
                self.getAffilitaedUserDetails()
            }
        }
    }
    
    
    func AcceptUserRequest(param: [String: Any]) {
        WebService.shared.acceptAffilaitedUsersRequest(param: param) { [weak self] response in
            guard let self = self else { return }
            DispatchQueue.main.async {
                let vc = RegisterationSuccessViewController.instantiate(fromAppStoryboard: .Main)
                vc.comingReason = .AffiliateUserManagement
                vc.callBackDismiss = {
                    self.hostVC?.userType = .approvedUsers
                    self.hostVC?.initailSetupUI()
                    self.getAffilitaedUserDetails()
                }
                self.hostVC?.navigationController?.present(vc, animated: true)
            }
        }
    }
    
    func RejectUserRequest(param: [String: Any]) {
        WebService.shared.rejectAffilaitedUsersRequest(param: param) { [weak self] response in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.getAffilitaedUserDetails()
            }
        }
    }
}
