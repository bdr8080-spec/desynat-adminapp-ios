//
//  StaffDetailsViewModel.swift
//  DesynatAdmin
//
//  Created by fluper_mac3 on 21/04/26.
//

import Foundation
import UIKit

class StaffDetailsViewModel {
    
    private var hostVC: StaffDetailsViewController
    var staffDetails: StaffDetails?
    
    init(hostVC: StaffDetailsViewController) {
        self.hostVC = hostVC
    }
    
    func getStaffDetails() {
        let param: [String:Any] = ["id": hostVC.staffID ?? 0]
        WebService.shared.getSubAdminProfileDetailsService(param: param) { [weak self] response in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.staffDetails = response
                self.hostVC.configUserData()
            }
        }
    }
    
    func upadteStaffStatus(param: [String: Any]) {
        WebService.shared.updateSubAdminStatusService(param: param) { [weak self] response in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.staffDetails?.status = response.status?.description
                if let status = response.status {
                    self.hostVC.isActiveLbl.text = status == 1 ? "Active" : "Inactive"
                    self.hostVC.activeStatusbtn.setImage(UIImage(named: status == 1 ? "toggleOn" : "toggleOff"), for: .normal)
                    CommonUtils.showToast(message: status == 1 ? "Sub Admin Profile Activated Successfully" : "Sub Admin Profile Deactivated Successfully"
                    )
                }
            }
        }
    }
    
    func deleteStaffDetails(param: [String: Any]) {
        WebService.shared.deleteSubAdminService(param: param) { [weak self] response in
            guard let self = self else { return }
            DispatchQueue.main.async {
                CommonUtils.showToast(message: "Profile is deleted successfully")
                self.hostVC.navigationController?.popViewController(animated: true)
            }
        }
    }
}
