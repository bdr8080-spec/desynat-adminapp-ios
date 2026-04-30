//
//  DeliveryBoyViewModel.swift
//  DesynatAdmin
//
//  Created by fluper on 20/11/25.
//

import Foundation

class DeliveryBoyViewModel {
  
  private var hostVC: DeliveryBoyViewController?
  
  var boysListData: [DeliveryBoysList] = []
  var currentPage: Int = 1
  var totalPages: Int = 1
  var searchText: String = ""
  var appliedFilter = DriverFilterModel()
  
  init(hostVC: DeliveryBoyViewController) {
    self.hostVC = hostVC
  }
  
  func getAllDeliveryBoy() {
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
    
    print("FINAL PARAMS →", params)
    
    // API CALL
    WebService.shared.getAllDeliveryBoys(param: params) { [weak self] response in
      guard let self = self else { return }
      
      self.currentPage = response.currentPage ?? 1
      self.totalPages = response.lastPage ?? 1
      
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
    getAllDeliveryBoy()
  }
  
  func goToPreviousPage() {
    guard currentPage > 1 else { return }
    currentPage -= 1
    getAllDeliveryBoy()
  }
  
  func deleteBoy(param: [String: Any]) {
    WebService.shared.deleteBoy(param: param){ [weak self] response in
      guard let self = self else { return }
        CommonUtils.showToast(message: "Profile has been deleted succesfully".localiz())
      self.currentPage = 1 // optional: reset to first page
      self.getAllDeliveryBoy()
    }
  }
  
  func updateActiveStatus(param: [String: Any], completion: @escaping (Bool) -> Void) {
    WebService.shared.updateStatusBoy(param: param){ response in
      completion(true)
    }
  }
}
