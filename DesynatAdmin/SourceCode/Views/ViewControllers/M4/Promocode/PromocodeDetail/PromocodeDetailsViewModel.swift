//
//  PromocodeDetailsViewModel.swift
//  DesynatAdmin
//
//  Created by fluper on 09/12/25.
//

import Foundation
import UIKit

class PromocodeDetailsViewModel {
    
    private var hostVC: PromocodeDetailsViewController
    
    init(hostVC: PromocodeDetailsViewController) {
        self.hostVC = hostVC
    }
    
    func upadtePromocodeStatus(param: [String: Any]) {
        WebService.shared.upadtePromocodeStatus(param: param) { [weak self] response in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                
                // Update model
                self.hostVC.promocodeDetails?.status = response.status
                
                // Update ONLY toggle image + label
                if let status = response.status {
                    self.hostVC.statusLabel.text = status == 1 ? "Active" : "Inactive"
                    self.hostVC.statusToggleImageView.image =
                    UIImage(named: status == 1 ? "toggleOn" : "toggleOff")
                    
                    CommonUtils.showToast(
                        message: status == 1 ? "Promocode Activated Successfully"
                        : "Promocode Deactivated Successfully"
                    )
                }
            }
        }
    }
    
    func deletePromocode(param: [String: Any]) {
        WebService.shared.deletePromoCode(param: param){ [weak self] response in
            guard let self = self else { return }
            DispatchQueue.main.async {
                CommonUtils.showToast(message: "Promocode Deleted Successfully")
                self.hostVC.navigationController?.popViewController(animated: true)
            }
        }
    }
    
}
