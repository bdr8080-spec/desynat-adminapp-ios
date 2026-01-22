//
//  AffiliatedUserDetailsViewModel.swift
//  DesynatAdmin
//
//  Created by fluper_mac3 on 22/01/26.
//

import Foundation

class AffiliatedUserDetailsViewModel {
    
    private var hostVC: AffiliatedUserDetailsViewController?
    
    init(hostVC: AffiliatedUserDetailsViewController? = nil) {
        self.hostVC = hostVC
    }
    
//    func upadteBrandStatus(param: [String: Any]) {
//        WebService.shared.upadteBrandStatus(param: param) { [weak self] response in
//            guard let self = self else { return }
//            
//            DispatchQueue.main.async {
//                self.hostVC.brandData = response
//                self.hostVC.bindData()
//                if let status = response.status {
//                    if status == 1 {
//                        CommonUtils.showToast(message: "Affiliated User Activated Successfully")
//                    } else {
//                        CommonUtils.showToast(message: "Affiliated Deactivated Successfully")
//                    }
//                }
//            }
//        }
//    }
}
