//
//  PromotionalBannerDetailsViewModel.swift
//  DesynatAdmin
//
//  Created by fluper_mac3 on 05/02/26.
//

import Foundation

class PromotionalBannerDetailsViewModel {
    
    private var hostVC: PromotionalBannerDetaislViewController
    
    init(hostVC: PromotionalBannerDetaislViewController) {
        self.hostVC = hostVC
    }
    
    func deletePromtoionalBanner(param: [String: Any]) {
        WebService.shared.deletePromtoionalBanner(param: param){ [weak self] response in
            guard let self = self else { return }
            DispatchQueue.main.async {
                CommonUtils.showToast(message: "Banner Deleted Successfully".localiz())
                self.hostVC.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func getPromotionalScreenBannerDetailsList() {
        let param: [String: Any] = ["banner_id": hostVC.bannerId]
        WebService.shared.getPromotionalScreenBannerDetailsList(param: param){ [weak self] response in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.hostVC.bannerListData = response
                self.hostVC.bindData()
            }
        }
    }
    
    func upadteBannerStatus(
        param: [String: Any],
        completion: @escaping (Bool) -> Void
    ) {
        WebService.shared.upadtePromtoionalBannerRequestStatus(param: param) { response in
            // Assuming API returns success flag
            
            completion(true)
        }
    }
    
}
