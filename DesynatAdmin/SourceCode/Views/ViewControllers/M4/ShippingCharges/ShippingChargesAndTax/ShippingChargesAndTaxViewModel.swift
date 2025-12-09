//
//  ShippingChargesAndTaxViewModel.swift
//  DesynatAdmin
//
//  Created by fluper on 09/12/25.
//

import Foundation

class ShippingChargesAndTaxViewModel {
  
  private var hostVC: ShippingChargesAndTaxViewController?
  var shippingTaxDetails: [ShippingChargesList]?
  init(hostVC: ShippingChargesAndTaxViewController) {
    self.hostVC = hostVC
  }
  
  func deleteShippingInfo(param: [String: Any]) {
    WebService.shared.deleteShippingInfo(param: param) { [weak self] response in
      guard let self = self else { return }
      getAllshippingTaxList()
    }
  }
  
  func updateActiveStatus(param: [String: Any], completion: @escaping (Bool) -> Void) {
    WebService.shared.updateStatusOfShippingFees(param: param){ response in
      completion(true)
    }
  }
  
  func getAllshippingTaxList() {
    let param: [String: Any] = ["country_id": hostVC?.countryId ?? 0]
    WebService.shared.getShippingTaxesCountryWise(params: param) { [weak self] response in
      guard let self = self else { return }
      self.shippingTaxDetails = response
      DispatchQueue.main.async {
        self.hostVC?.shippingTableView.reloadData()
        self.hostVC?.populateData()
        self.hostVC?.noDataFoundLabel.isHidden = !(self.shippingTaxDetails?.isEmpty ?? false)
      }
    }
  }
}


