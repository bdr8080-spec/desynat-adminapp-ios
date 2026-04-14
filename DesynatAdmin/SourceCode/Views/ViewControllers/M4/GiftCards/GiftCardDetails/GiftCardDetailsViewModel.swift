//
//  GiftCardDetailsViewModel.swift
//  DesynatAdmin
//
//  Created by fluper on 09/12/25.
//

import Foundation

class GiftCardDetailsViewModel {
    
    private var hostVC: GiftCardDetailsViewController
    
    init(hostVC: GiftCardDetailsViewController) {
        self.hostVC = hostVC
    }
    
    func upadteCardStatus(param: [String: Any]) {
        WebService.shared.upadteGiftCardStatus(param: param) { [weak self] response in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.hostVC.giftsListData = response
                self.hostVC.bindData()
                if let status = response.status {
                    if status == 1 {
                        CommonUtils.showToast(message: "Gift Card Activated Successfully")
                    } else {
                        CommonUtils.showToast(message: "Gift Card Deactivated Successfully")
                    }
                }
            }
        }
    }
    
    func deleteCard(param: [String: Any]) {
        WebService.shared.deleteCard(param: param){ [weak self] response in
            guard let self = self else { return }
            DispatchQueue.main.async {
                CommonUtils.showToast(message: "Gift Card Category Deleted Successfully")
                self.hostVC.navigationController?.popViewController(animated: true)
            }
        }
    }
    
}
