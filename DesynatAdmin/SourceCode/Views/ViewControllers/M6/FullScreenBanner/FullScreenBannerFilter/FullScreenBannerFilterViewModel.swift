//
//  FullScreenBannerViewModel.swift
//  DesynatAdmin
//
//  Created by fluper on 08/01/26.
//

import Foundation

class FullScreenBannerFilterViewModel {
  
  private var hostVC: FullScreenBannerFilterViewController?
  var countryListData: [GetAllUserCountryModel] = []
  
  init(hostVC: FullScreenBannerFilterViewController) {
    self.hostVC = hostVC
  }
  
  func getAllCountry(completion: (() -> Void)? = nil) {
    WebService.shared.getAllUsersCountryList(){ [weak self] response in
      guard let self = self else { return }
      countryListData = response
      completion?()
    }
  }
  
}
