//
//  BannersMangementFilterViewModel.swift
//  DesynatAdmin
//
//  Created by fluper on 16/12/25.
//

import Foundation

class BannersMangementFilterViewModel {
  
  private var hostVC: BannersMangementFilterViewController?
  var countryListData: [GetCountryDataModel] = []
  
  init(hostVC: BannersMangementFilterViewController) {
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
