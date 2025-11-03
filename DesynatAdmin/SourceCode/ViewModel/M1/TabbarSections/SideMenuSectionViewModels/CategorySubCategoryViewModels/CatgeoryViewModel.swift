//
//  GetCatgeoryViewModel.swift
//  DesynatAdmin
//
//  Created by Rakhi Kumari on 01/11/25.
//

import Foundation

class CategoryViewModel {
    
    private var hostVC: CategoryViewController
    var categoryListData: [GetCategoryModel] = []
    
    init(hostVC: CategoryViewController) {
        self.hostVC = hostVC
    }
    
    func getAllCategory() {
        WebService.shared.getAllCategory(){ [weak self] response in
            guard let self = self else { return }
            categoryListData = response
            hostVC.categoryTableView.reloadData()
            hostVC.noDataFoundLabel.isHidden = !self.categoryListData.isEmpty
        }
    }
    
    func upadteCategory(param: [String: Any], completion: @escaping (Bool) -> Void) {
        WebService.shared.upadteCategory(param: param){ [weak self] response in
            guard let self = self else { return }
            completion(true)
        }
    }
    
}
