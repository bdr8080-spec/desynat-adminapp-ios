//
//  SellerReelsAndHighLightsViewModel.swift
//  DesynatAdmin
//
//  Created by fluper_mac2 on 18/05/26.
//

import Foundation

class SellerReelsAndHighLightsViewModel {
    
    private var hostVC: SellerReelsAndHighLightsViewController
    
    init(hostVC: SellerReelsAndHighLightsViewController) {
        self.hostVC = hostVC
    }
    
    func deleteReel() {
        let param: [String: Any] = ["reel_id": hostVC.reelsData?.id ?? 0]
        WebService.sharedInstance.deleetSellerReelListService(param: param) { [weak self] response in
            guard let self = self else { return }
            CommonUtils.showToast(message: "Reel deleted Successfully".localiz())
            self.hostVC.navigationController?.popViewController(animated: true)
        }
    }
    
    func deleteHighlight() {
//        let param: [String: Any] = ["highlight_id": hostVC.highlights?.id ?? 0]
        let param: [String: Any] = ["highlight_id": hostVC.highlights?.highlights?.first?.id ?? 0]
        WebService.sharedInstance.deleetSellerHighlightListService(param: param) { [weak self] response in
            guard let self = self else { return }
            CommonUtils.showToast(message: "Highlight deleted Successfully".localiz())
            self.hostVC.navigationController?.popViewController(animated: true)
        }
    }
    
    func updateMyReelsStatusRequest() {
//        let param: [String: Any] = ["reel_id": hostVC.reelsData?.id ?? 0]
//        WebService.sharedInstance.updateMyReelsStatusServices(param: param) { [weak self] response in
//            guard let self = self else { return }
//            self.hostVC.reelsData = response
//            self.hostVC.configData()
//            if response.status == 1 {
//                CommonUtils.showToast(message: "Reel activated successfully".localiz())
//            } else {
//                CommonUtils.showToast(message: "Reel deactivated successfully".localiz())
//            }
//        }
    }
    
}

