//
//  DealsManagementListViewModel.swift
//  DesynatAdmin
//
//  Created by fluper on 07/01/26.
//

import Foundation

class DealsManagementListViewModel {
  
  private var hostVC: DealsManagementListViewController?
  var reasonListData: [ReasonsListModel] = []
  var currentPage: Int = 1
  var totalPages: Int = 1
  var searchText: String = ""
  
  init(hostVC: DealsManagementListViewController) {
    self.hostVC = hostVC
  }
  
  func getAllReasons() {
    var params: [String : Any] = [:]
    params["page"] = currentPage
    params["type"] = hostVC?.type
    params["limit"] = 3
    if !searchText.isEmpty {
      params["search"] = searchText
    }
    
    WebService.shared.getReasonsList(param: params) { [weak self] response in
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
    getAllReasons()
  }
  
  func goToPreviousPage(type: Int) {
    guard currentPage > 1 else { return }
    currentPage -= 1
    getAllReasons()
  }
  
  func updateActiveStatus(param: [String: Any], completion: @escaping (Bool) -> Void) {
    WebService.shared.updateReasonStatus(param: param){ [weak self] response in
      guard let self = self else { return }
      completion(true)
    }
  }
  
  func deleteReason(param: [String: Any]) {
    WebService.shared.deleteReason(param: param){ [weak self] response in
      guard let self = self else { return }
      let type = hostVC?.type ?? 1
      switch type {
      case 1:
        CommonUtils.showToast(message: "Exchange Reason Deleted Succesfully")
      case 2:
        CommonUtils.showToast(message: "Return Reason Deleted Succesfully")
      case 3:
        CommonUtils.showToast(message: "Cancel Reason Deleted Succesfully")
      default:
        CommonUtils.showToast(message: "Reason deleted succesfully")
      }
      self.currentPage = 1 // optional: reset to first page
      self.getAllReasons()
    }
  }
  
}
