//
//  SubCategoryViewModel.swift
//  DesynatAdmin
//
//  Created by Rakhi Kumari on 01/11/25.
//

import Foundation

class SubcategoryViewModel {
    
    private weak var hostVC: SubCategoryViewController?
    var subCategoryListData: [GetSubCategoryDataList] = []
    var currentPage: Int = 1
    var totalPages: Int = 1
    var searchText: String = ""
    
    init(hostVC: SubCategoryViewController) {
        self.hostVC = hostVC
    }
    
    func getAllsubcategory(param: [String : Any]) {
        var params = param
        params["page"] = currentPage
//        params["limit"] = 1
        if !searchText.isEmpty {
            params["search"] = searchText
        }
        
        WebService.shared.getAllsubcategory(param: params) { [weak self] response in
            guard let self = self else { return }
            
            // Update page info
            self.currentPage = response.currentPage ?? 1
            self.totalPages = response.lastPage ?? 1
            
            // Update data
            self.subCategoryListData = response.data ?? []
            
            DispatchQueue.main.async {
                self.hostVC?.countLabel.text = String(format: "%02d of %02d", self.currentPage, self.totalPages)
                self.hostVC?.subCategoryCollectionView.reloadData()
                self.hostVC?.noDataFoundLabel.isHidden = !self.subCategoryListData.isEmpty
//                self.hostVC?.bottomView.isHidden = self.subCategoryListData.isEmpty
                self.hostVC?.updatePaginationButtonImages()
            }
        }
    }
    
    func goToNextPage(param: [String: Any]) {
        guard currentPage < totalPages else { return }
        currentPage += 1
        getAllsubcategory(param: param)
    }
    
    func goToPreviousPage(param: [String: Any]) {
        guard currentPage > 1 else { return }
        currentPage -= 1
        getAllsubcategory(param: param)
    }
}
