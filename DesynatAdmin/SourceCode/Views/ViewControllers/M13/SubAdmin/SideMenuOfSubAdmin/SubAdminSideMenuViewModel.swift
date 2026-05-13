//
//  SubAdminSideMenuViewModel.swift
//  DesynatAdmin
//
//  Created by fluper_mac3 on 22/04/26.
//

import Foundation

class SubAdminSideMenuViewModel {
    
    private var hostVC: SubAdminSideMenuViewController
    var staffDetails: StaffDetails?
    
    init(hostVC: SubAdminSideMenuViewController) {
        self.hostVC = hostVC
    }
    
    func logoutAPI(){
        WebService.sharedInstance.logoutService() { (response) in
            kSharedSceneDelegate.logoutUser()
        }
    }
    
    func getUserData() {
        if let savedUser: UserModel = kSharedUserDefaults.retrieveModelFor(key: .user, model: UserModel.self) {
            getStaffDetails(userId: savedUser.id ?? 0)
        }
    }
    
    func getStaffDetails(userId: Int) {
        let param: [String:Any] = ["id": userId]
        WebService.shared.getSubAdminProfileDetailsService(param: param) { [weak self] response in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.staffDetails = response
                self.configUserData()
            }
        }
    }
    
    private func configUserData() {
        hostVC.usernameLabel.text = staffDetails?.fullName
        hostVC.emailLabel.text = staffDetails?.email
        if let imageUrlString = staffDetails?.profilePic,
           let url = URL(string: imageUrlString) {
            hostVC.userProfileImageView.sd_setImage(with: url, placeholderImage: .userProfile)
        } else {
            hostVC.userProfileImageView.image = .userProfile
        }
        hostVC.sideMenuTableView.reloadData()
        hostVC.updateTableHeight()
        let hasAccountPermission = staffDetails?.permissionDetails?.contains(where: {($0.moduleID ?? 0) == 30}) ?? false
        hostVC.editPencilButton.isHidden = !hasAccountPermission
    }
}
