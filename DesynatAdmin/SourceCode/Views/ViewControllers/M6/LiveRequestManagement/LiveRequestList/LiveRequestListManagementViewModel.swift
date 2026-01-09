//
//  LiveRequestListManagementViewModel.swift
//  DesynatAdmin
//
//  Created by fluper on 06/01/26.
//

import Foundation

class LiveRequestListManagementViewModel {
  
  private var hostVC: LiveRequestListManagementViewController
  var slectedTimeSlot: [LiveRequestListDataModel] = []
  var LiveRequestList: [LiveRequestPermissionList] = []
  var countryListData: [GetCountryDataModel] = []
  var searchText: String = ""
  var currentPage: Int = 1
  var totalPages: Int = 1
  
  init(hostVC: LiveRequestListManagementViewController) {
    self.hostVC = hostVC
  }
  
  func getAllCountry() {
    WebService.shared.getAllCountry { [weak self] response in
      guard let self else { return }
      self.countryListData = response
      if let first = response.first {
        hostVC.selectedCountryIndex = first.id ?? 0
        hostVC.selectedCountryLabel.text = first.name
      }
      hostVC.countryTableView.reloadData()
      // Initial API call once country is available
      self.fetchTimeSlotsIfPossible()
    }
  }
  
  /// Centralized fetch method
  func fetchTimeSlotsIfPossible() {
    guard
      let date = hostVC.selectedDateString,
      hostVC.selectedCountryIndex != 0
    else { return }
    
    // CLEAR OLD DATA FIRST
    slectedTimeSlot.removeAll()
    hostVC.timeSlotsTableView.reloadData()
    hostVC.updateTimeSlotTableHeight()
    getAllTimeRequestTimeSlot(
      countryId: hostVC.selectedCountryIndex,
      date: date
    )
  }
  
  func getAllTimeRequestTimeSlot(countryId: Int, date: String) {
    let params: [String: Any] = [
      "country_id": countryId,
      "date": date]
    WebService.shared.getAllLiveRequestTimeSlot(param: params) { [weak self] response in
      guard let self else { return }
      DispatchQueue.main.async {
        self.slectedTimeSlot = response
        self.hostVC.timeSlotsTableView.reloadData()
        self.hostVC.updateTimeSlotTableHeight()
        let shouldShowNoData = self.hostVC.liveRequestTimeslotISSelcted && response.isEmpty
        self.hostVC.noLiveRequestTimeSlotFoundLabel.isHidden = !shouldShowNoData
      }
    }
  }
  
  func updateActiveStatus(param: [String: Any], completion: @escaping (Bool) -> Void) {
    WebService.shared.updateLiveRequestTimeslotStatus(param: param){ [weak self] response in
      guard let self = self else { return }
      completion(true)
    }
  }
  
  func deleteTimeSlots(param: [String: Any]) {
    WebService.shared.deleteTimeSlots(param: param){ [weak self] response in
      guard let self = self else { return }
      CommonUtils.showToast(message: "Live Request Timeslot Deleted Succesfully")
      self.fetchTimeSlotsIfPossible()
    }
  }
  
  func acceptRequest(param: [String: Any]) {
    WebService.shared.acceptLiveRequest(param: param){ [weak self] response in
      guard let self = self else { return }
      let vc = RegisterationSuccessViewController.instantiate(fromAppStoryboard: .Main)
      vc.comingReason = .LiveRequestIsDone
      vc.callBackDismiss = {
        self.getLiveRequest()
      }
      self.hostVC.navigationController?.present(vc, animated: true)
    }
  }
  
  func rejectLiveRequest(param: [String: Any]) {
    WebService.shared.rejectLiveRequest(param: param){ [weak self] response in
      guard let self = self else { return }
      getLiveRequest()
    }
  }
  
  
  
//  func getAllLiveRequest(countryId: Int, date: String) {
//    var params: [String: Any] = [
//      "type": hostVC.selectedTab.rawValue, ////0-new,1-accepted,2-rejected
//      "country_id": hostVC.selectedCountryLabel.text ?? ""]
//    if !searchText.isEmpty {
//      params["search"] = searchText
//    }
//    WebService.shared.getAllLiveRequest(param: params) { [weak self] response in
//      guard let self else { return }
//      DispatchQueue.main.async {
//        self.LiveRequestList = response.data
////        self.hostVC.timeSlotsTableView.reloadData()
////        self.hostVC.updateTimeSlotTableHeight()
////        let shouldShowNoData = self.hostVC.liveRequestTimeslotISSelcted && response.isEmpty
////        self.hostVC.noLiveRequestTimeSlotFoundLabel.isHidden = !shouldShowNoData
//      }
//    }
//  }
  
  func getLiveRequest() {
    var params: [String : Any] = [:]
    params["page"] = currentPage
    params["type"] = hostVC.selectedTab.rawValue ////0-new,1-accepted,2-rejected
    params["country_id"] = hostVC.selectedCountryLabel.text ?? "" ////0-new,1-accepted,2-rejected
//    params["type"] = hostVC?.type
    params["limit"] = 2
    if !searchText.isEmpty {
      params["search"] = searchText
    }
    
    WebService.shared.getAllLiveRequest(param: params) { [weak self] response in
      guard let self = self else { return }
      
      // Update page info
      self.currentPage = response.currentPage ?? 1
      self.totalPages = response.lastPage ?? 1
      
      // Update data
      self.LiveRequestList = response.data ?? []
      
      DispatchQueue.main.async {
        self.hostVC.lblPageCount.text = String(format: "%02d of %02d", self.currentPage, self.totalPages)
        self.hostVC.liveREquestTableView.reloadData()
        self.hostVC.updateLiveRequestTableHeight()
        self.hostVC.noLiveRequestDataFoundLabel.isHidden = !self.LiveRequestList.isEmpty
        self.hostVC.updatePaginationButtonImages()
      }
    }
  }
  
  func goToNextPage() {
    guard currentPage < totalPages else { return }
    currentPage += 1
    getLiveRequest()
  }
  
  func goToPreviousPage() {
    guard currentPage > 1 else { return }
    currentPage -= 1
    getLiveRequest()
  }
}
