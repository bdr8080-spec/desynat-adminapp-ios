//
//  PromocodeFilterViewModel.swift
//  DesynatAdmin
//
//  Created by fluper on 09/12/25.
//

import Foundation

class PromocodeFilterViewModel {
    
    private var hostVC: PromocodeFilterViewController?
    var countryListData: [GetCountryDataModel] = []
    
    init(hostVC: PromocodeFilterViewController) {
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
