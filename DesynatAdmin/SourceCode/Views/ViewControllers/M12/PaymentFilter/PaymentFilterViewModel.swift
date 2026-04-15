//
//  PaymentFilterViewModel.swift
//  DesynatAdmin
//
//  Created by  shailendra singh on 07/04/26.
//

import Foundation

class PaymentFilterViewModel{
    
    private var hostVC: PaymentFilterViewController?
    var countryListData: [GetCountryDataModel] = []
    var allCountryListData: [GetAllUserCountryModel] = []
    
    init(hostVC: PaymentFilterViewController) {
        self.hostVC = hostVC
    }
    
    func getCountryRequest(completion: (() -> Void)? = nil) {
        WebService.shared.getAllCountry(){ [weak self] response in
            guard let self = self else { return }
            countryListData = response
            completion?()
        }
    }
    
    func getAllCountryRequest(completion: (() -> Void)? = nil) {
        WebService.shared.getAllUsersCountryList(){ [weak self] response in
            guard let self = self else { return }
            allCountryListData = response
            completion?()
        }
    }
}
