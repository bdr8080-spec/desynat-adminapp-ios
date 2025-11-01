//
//  BrandDetailsViewModel.swift
//  DesynatAdmin
//
//  Created by Rakhi Kumari on 01/11/25.
//

import Foundation

class BrandDetailsViewModel {
    
    private var hostVC: BrandDetailsViewController
    
    init(hostVC: BrandDetailsViewController) {
        self.hostVC = hostVC
    }
    
    func upadteBrandStatus(param: [String: Any]) {
        WebService.shared.upadteBrandStatus(param: param){ [weak self] response in
            guard let self = self else { return }
            hostVC.brandData = response
            hostVC.bindData()
        }
    }
    
    func deleteBrand(param: [String: Any]) {
        WebService.shared.deleteBrand(param: param){ [weak self] response in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.hostVC.navigationController?.popViewController(animated: true)
            }
        }
    }
    
}
