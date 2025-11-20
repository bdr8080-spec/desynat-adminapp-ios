//
//  ReasonManagementViewModel.swift
//  DesynatAdmin
//
//  Created by fluper on 20/11/25.
//

import Foundation

class ReasonManagementViewModel {
    
    private var hostVC: ReasonManagementViewController?
    var reasonListData: [GetBrandDataList] = []
    var currentPage: Int = 1
    var totalPages: Int = 1
    var searchText: String = ""
    
    init(hostVC: ReasonManagementViewController) {
        self.hostVC = hostVC
    }
    
    func getAllReasons() {
        var params: [String : Any] = [:]
        params["page"] = currentPage
        params["limit"] = 3
        if !searchText.isEmpty {
            params["search"] = searchText
        }
        
        WebService.shared.getAllBrands(param: params) { [weak self] response in
            guard let self = self else { return }
            
            // Update page info
            self.currentPage = response.currentPage ?? 1
            self.totalPages = response.lastPage ?? 1
            
            // Update data
            self.reasonListData = response.data ?? []
            
            DispatchQueue.main.async {
                self.hostVC?.pageCountLabel.text = String(format: "%02d of %02d", self.currentPage, self.totalPages)
                self.hostVC?.reasonTableView.reloadData()
                self.hostVC?.noDataFoundLabel.isHidden = !self.reasonListData.isEmpty
                self.hostVC?.updatePaginationButtonImages()
            }
        }
    }
    
    func goToNextPage() {
        guard currentPage < totalPages else { return }
        currentPage += 1
      getAllReasons()
    }
    
    func goToPreviousPage() {
        guard currentPage > 1 else { return }
        currentPage -= 1
      getAllReasons()
    }
}
