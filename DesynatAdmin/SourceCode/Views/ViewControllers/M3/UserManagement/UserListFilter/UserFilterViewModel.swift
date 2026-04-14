//
//  UserFilterViewModel.swift
//  DesynatAdmin
//
//  Created by fluper on 21/11/25.
//

import Foundation

class UserFilterViewModel {
  
  private var hostVC: UserListFilterViewController?
  var countryListData: [GetCountryDataModel] = []
  
  init(hostVC: UserListFilterViewController) {
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
