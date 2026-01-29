//
//  AffiliatedUserFilterViewModel.swift
//  DesynatAdmin
//
//  Created by fluper_mac3 on 29/01/26.
//

import Foundation

class AffiliatedUserFilterViewModel {
  
  private var hostVC: AffiliatedUserFilterViewController?
  var countryListData: [GetCountryDataModel] = []
  
  init(hostVC: AffiliatedUserFilterViewController) {
    self.hostVC = hostVC
  }
  
  func getAllCountry(completion: (() -> Void)? = nil) {
    WebService.shared.getAllCountry(){ [weak self] response in
      guard let self = self else { return }
      countryListData = response
      completion?()
    }
  }
  
}
