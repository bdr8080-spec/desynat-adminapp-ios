//
//  DealsManagementListViewModel.swift
//  DesynatAdmin
//
//  Created by fluper on 07/01/26.
//

import Foundation

class DealsManagementListViewModel {
    
    private var hostVC: DealsManagementListViewController?
    var reasonListData: [DealListManagementList] = []
    var currentPage: Int = 1
    var totalPages: Int = 1
    var searchText: String = ""
    
    init(hostVC: DealsManagementListViewController) {
        self.hostVC = hostVC
    }
    
    func getActiveDeals() {
        var params: [String : Any] = [:]
        params["page"] = currentPage
        params["limit"] = 2
        if !searchText.isEmpty {
            params["search"] = searchText
        }
        
        WebService.shared.getActiveDeals(param: params) { [weak self] response in
            guard let self = self else { return }
            
            // Update page info
            self.currentPage = response.currentPage ?? 1
            self.totalPages = response.lastPage ?? 1
            
            // Update data
            self.reasonListData = response.data ?? []
            
            DispatchQueue.main.async {
                self.hostVC?.pageCountLabel.text = String(format: "%02d of %02d", self.currentPage, self.totalPages)
                self.hostVC?.dealsTableview.reloadData()
                self.hostVC?.noDataFoundLabel.isHidden = !self.reasonListData.isEmpty
                self.hostVC?.updatePaginationButtonImages()
            }
        }
    }
    
    func getExpiredDeals() {
        var params: [String : Any] = [:]
        params["page"] = currentPage
        params["limit"] = 2
        if !searchText.isEmpty {
            params["search"] = searchText
        }
        
        WebService.shared.getExpiredDeals(param: params) { [weak self] response in
            guard let self = self else { return }
            
            // Update page info
            self.currentPage = response.currentPage ?? 1
            self.totalPages = response.lastPage ?? 1
            
            // Update data
            self.reasonListData = response.data ?? []
            
            DispatchQueue.main.async {
                self.hostVC?.pageCountLabel.text = String(format: "%02d of %02d", self.currentPage, self.totalPages)
                self.hostVC?.dealsTableview.reloadData()
                self.hostVC?.noDataFoundLabel.isHidden = !self.reasonListData.isEmpty
                self.hostVC?.updatePaginationButtonImages()
            }
        }
    }
    
    func goToNextPage(type: Int) {
        guard currentPage < totalPages else { return }
        currentPage += 1
        if type == 1 {
            getActiveDeals()
        } else {
            getExpiredDeals()
        }
        
    }
    
    func goToPreviousPage(type: Int) {
        guard currentPage > 1 else { return }
        currentPage -= 1
        if type == 1 {
            getActiveDeals()
        } else {
            getExpiredDeals()
        }
    }
    
}
