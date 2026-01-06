//
//  LiveRequestListManagementViewModel.swift
//  DesynatAdmin
//
//  Created by fluper on 06/01/26.
//

import Foundation

class LiveRequestListManagementViewModel {
  
  private var hostVC: LiveRequestListManagementViewController
  
  init(hostVC: LiveRequestListManagementViewController) {
    self.hostVC = hostVC
  }
  
  var countryListData: [GetCountryDataModel] = []
  
  func getAllCountry() {
    WebService.shared.getAllCountry(){ [weak self] response in
      guard let self = self else { return }
      countryListData = response
      hostVC.countryTableView.reloadData()
    }
  }
}
