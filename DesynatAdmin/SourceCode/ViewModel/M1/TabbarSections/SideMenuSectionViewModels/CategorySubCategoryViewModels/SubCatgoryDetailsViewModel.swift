//
//  SubCatgoryDetailsViewModel.swift
//  DesynatAdmin
//
//  Created by Rakhi Kumari on 01/11/25.
//

import Foundation

class SubCatgoryDetailsViewModel {
    
    private var hostVC: SubCatgoryDetailsViewController
    
    init(hostVC: SubCatgoryDetailsViewController) {
        self.hostVC = hostVC
    }
    
    func upadteSubcategory(param: [String: Any]) {
        WebService.shared.upadteSubcategoryStatus(param: param){ [weak self] response in
            guard let self = self else { return }
            hostVC.subCategoryData = response
            hostVC.bindData()
            if let status = response.status {
                if status == 1 {
                    CommonUtils.showToast(message: "Category has been activated Successfully")
                } else {
                    CommonUtils.showToast(message: "Category has been Deactivated Successfully")
                }
            }
        }
    }
    
    func deleteSubcategory(param: [String: Any]) {
        WebService.shared.deleteSubCategory(param: param){ [weak self] response in
            guard let self = self else { return }
            DispatchQueue.main.async {
                CommonUtils.showToast(message: "Sub category deleted succesfully")
                self.hostVC.navigationController?.popViewController(animated: true)
            }
        }
    }
    
}
