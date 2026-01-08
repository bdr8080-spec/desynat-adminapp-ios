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
  
  init(hostVC: LiveRequestListManagementViewController) {
    self.hostVC = hostVC
  }
  
  var countryListData: [GetCountryDataModel] = []
  
  func getAllCountry() {
    WebService.shared.getAllCountry(){ [weak self] response in
      guard let self = self else { return }
      countryListData = response
      hostVC.selectedCountryIndex = response.first?.id ?? 0
      hostVC.selectedCountryLabel.text = response.first?.name
      hostVC.countryTableView.reloadData()
    }
  }
  
  func getAllTimeRequestTimeSlot() {
    WebService.shared.getAllLiveRequestTimeSlot(){ [weak self] response in
      guard let self = self else { return }
      slectedTimeSlot = response
      hostVC.timeSlotsTableView.reloadData()
    }
  }
}
