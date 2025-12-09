//
//  PromodeListViewModel.swift
//  DesynatAdmin
//
//  Created by fluper on 09/12/25.
//

import Foundation

class PromodeListViewModel {
  
  private var hostVC: PromodeListViewController?
  
  init(hostVC: PromodeListViewController) {
    self.hostVC = hostVC
  }
  
  var promocodeListData: [PromocodeList] = []
  var currentPage: Int = 1
  var totalPages: Int = 1
  var searchText: String = ""
  var appliedFilter = UserFilterModel()
  
  func getAllPromocode() {
    var params: [String : Any] = [:]
    
    params["page"] = currentPage
    params["limit"] = 3
    
    // Search
    if !searchText.isEmpty {
      params["search"] = searchText
    }
    
    // From Date
    if let fromDate = appliedFilter.fromDate {
      params["from_date"] = fromDate
    }
    
    // To Date
    if let toDate = appliedFilter.toDate {
      params["to_date"] = toDate
    }
    
    if let countryId = appliedFilter.countryId {
      params["country_id"] = countryId
    }

    // API CALL
    WebService.shared.getAllPromoCode(param: params) { [weak self] response in
      guard let self = self else { return }
      
      self.currentPage = response.currentPage ?? 1
      self.totalPages = response.lastPage ?? 1
      
      self.promocodeListData = response.data ?? []
      
      DispatchQueue.main.async {
        self.hostVC?.pageCountLabel.text = String(format: "%02d of %02d", self.currentPage, self.totalPages)
        self.hostVC?.promocdeTableView.reloadData()
        self.hostVC?.noDataFoundLabel.isHidden = !self.promocodeListData.isEmpty
        self.hostVC?.updatePaginationButtonImages()
      }
    }
  }
  
  func goToNextPage() {
    guard currentPage < totalPages else { return }
    currentPage += 1
    getAllPromocode()
  }
  
  func goToPreviousPage() {
    guard currentPage > 1 else { return }
    currentPage -= 1
    getAllPromocode()
  }
  
}
