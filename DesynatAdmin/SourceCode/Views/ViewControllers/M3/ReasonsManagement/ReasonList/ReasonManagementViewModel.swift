//
//  ReasonManagementViewModel.swift
//  DesynatAdmin
//
//  Created by fluper on 20/11/25.
//

import Foundation

class ReasonManagementViewModel {
  
  private var hostVC: ReasonManagementViewController?
  var reasonListData: [ReasonsListModel] = []
  var currentPage: Int = 1
  var totalPages: Int = 1
  var searchText: String = ""
  
  init(hostVC: ReasonManagementViewController) {
    self.hostVC = hostVC
  }
  
  func getAllReasons() {
    var params: [String : Any] = [:]
    params["page"] = currentPage
    params["type"] = hostVC?.type
    params["limit"] = 4
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
        self.hostVC?.reasonTableView.reloadData()
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
      CommonUtils.showToast(message: "Reason deleted succesfully")
      self.currentPage = 1 // optional: reset to first page
      self.getAllReasons()
    }
  }
  
}
