//
//  SellerPayoutFiltersViewModel.swift
//  DesynatAdmin
//
//  Created by fluper_mac2 on 28/09/26.
//

import Foundation

class SellerPayoutFiltersViewModel {
    
    private var hostVC: SellerPayoutFiltersViewController
    var allCountryListData: [GetCountryDataModel] = []
    
    init(hostVC: SellerPayoutFiltersViewController) {
        self.hostVC = hostVC
    }
    
    func getAllCountryRequest(completion: (() -> Void)? = nil) {
        WebService.shared.getAllCountry(){ [weak self] response in
            guard let self = self else { return }
            allCountryListData = response
            completion?()
        }
    }

}
