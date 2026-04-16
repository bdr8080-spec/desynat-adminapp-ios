//
//  RefundManagementFilterViewModel.swift
//  DesynatAdmin
//
//  Created by fluper_mac3 on 16/04/26.
//

import Foundation

class RefundManagementFilterViewModel {
    
    private var hostVC: RefundManagementFilterViewController
    var countryListData: [GetCountryDataModel] = []
    var allCountryListData: [GetAllUserCountryModel] = []
    
    init(hostVC: RefundManagementFilterViewController) {
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
