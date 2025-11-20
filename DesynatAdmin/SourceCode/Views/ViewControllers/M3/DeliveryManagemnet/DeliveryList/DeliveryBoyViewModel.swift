//
//  DeliveryBoyViewModel.swift
//  DesynatAdmin
//
//  Created by fluper on 20/11/25.
//

import Foundation

class DeliveryBoyViewModel {
    
    private var hostVC: DeliveryBoyViewController?
  
    var boysListData: [GetBrandDataList] = []
    var currentPage: Int = 1
    var totalPages: Int = 1
    var searchText: String = ""
    
    init(hostVC: DeliveryBoyViewController) {
        self.hostVC = hostVC
    }
    
    func getAllDeliveryBoys() {
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
            self.boysListData = response.data ?? []
            
            DispatchQueue.main.async {
                self.hostVC?.pageCountLabel.text = String(format: "%02d of %02d", self.currentPage, self.totalPages)
                self.hostVC?.deliveryTableView.reloadData()
                self.hostVC?.noDataFoundLabel.isHidden = !self.boysListData.isEmpty
                self.hostVC?.updatePaginationButtonImages()
            }
        }
    }
    
    func goToNextPage() {
        guard currentPage < totalPages else { return }
        currentPage += 1
      getAllDeliveryBoys()
    }
    
    func goToPreviousPage() {
        guard currentPage > 1 else { return }
        currentPage -= 1
      getAllDeliveryBoys()
    }
}
