//
//  ShowViewModel.swift
//  DesynatAdmin
//
//  Created by fluper_mac3 on 20/03/26.
//

import Foundation

class ShowViewModel {
    
    private var hostVC: ShowViewController?
    var countryListData: [GetCountryDataModel] = []
    
    init(hostVC: ShowViewController) {
      self.hostVC = hostVC
    }
    
    func getAllCountry() {
      WebService.shared.getAllCountry(){ [weak self] response in
        guard let self = self else { return }
        countryListData = response
      }
    }
}
