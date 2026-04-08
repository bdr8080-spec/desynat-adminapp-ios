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
    
    init(hostVC: PaymentFilterViewController) {
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
