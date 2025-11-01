
//
//  CategoryViewModel.swift
//  DesynatAdmin
//
//  Created by Rakhi Kumari on 01/11/25.
//


import Foundation

class BrandViewModel {
    
    private var hostVC: BrandManagementViewController?
    var brandListData: [GetBrandDataList] = []
    var currentPage: Int = 1
    var totalPages: Int = 1
    var searchText: String = ""
    
    init(hostVC: BrandManagementViewController) {
        self.hostVC = hostVC
    }
    
    func getAllBrands() {
        var params: [String : Any] = [:]
        params["page"] = currentPage
//        params["limit"] = 1
        if !searchText.isEmpty {
            params["search"] = searchText
        }
        
        WebService.shared.getAllBrands(param: params) { [weak self] response in
            guard let self = self else { return }
            
            // Update page info
            self.currentPage = response.currentPage ?? 1
            self.totalPages = response.lastPage ?? 1
            
            // Update data
            self.brandListData = response.data ?? []
            
            DispatchQueue.main.async {
                self.hostVC?.pageCountLabel.text = String(format: "%02d of %02d", self.currentPage, self.totalPages)
                self.hostVC?.brandTableView.reloadData()
                self.hostVC?.noDataFoundLabel.isHidden = !self.brandListData.isEmpty
                self.hostVC?.updatePaginationButtonImages()
            }
        }
    }
    
    func goToNextPage() {
        guard currentPage < totalPages else { return }
        currentPage += 1
        getAllBrands()
    }
    
    func goToPreviousPage() {
        guard currentPage > 1 else { return }
        currentPage -= 1
        getAllBrands()
    }
}
