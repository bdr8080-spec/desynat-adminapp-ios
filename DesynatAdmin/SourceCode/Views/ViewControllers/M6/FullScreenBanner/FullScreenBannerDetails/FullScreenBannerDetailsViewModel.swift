//
//  FullScreenBannerDetailsViewModel.swift
//  DesynatAdmin
//
//  Created by fluper on 08/01/26.
//

import Foundation

class FullScreenBannerDetailsViewModel {
    
    private var hostVC: FullScreenBanerDetailsViewController
    
    init(hostVC: FullScreenBanerDetailsViewController) {
        self.hostVC = hostVC
    }
    
    func deleteFullScreenBanner(param: [String: Any]) {
        WebService.shared.deleteFullScreenBanner(param: param){ [weak self] response in
            guard let self = self else { return }
            DispatchQueue.main.async {
                CommonUtils.showToast(message: "Banner Deleted Successfully")
                self.hostVC.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func getFullScreenBannerDetailsList() {
        let param: [String: Any] = ["banner_id": hostVC.bannerId]
        WebService.shared.getFullScreenBannerDetailsList(param: param){ [weak self] response in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.hostVC.giftsListData = response
                self.hostVC.bindData()
            }
        }
    }
    
}
