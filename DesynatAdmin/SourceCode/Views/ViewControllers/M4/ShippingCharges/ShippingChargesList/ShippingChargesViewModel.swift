//
//  ShippingChargesViewModel.swift
//  DesynatAdmin
//
//  Created by fluper on 09/12/25.
//

import Foundation

class ShippingChargesViewModel {
  
  private var hostVC: ShippingChargesListViewController
  var shippingDetails: [ShippingChargesDataModel]?
  
  init(hostVC: ShippingChargesListViewController) {
    self.hostVC = hostVC
  }
  
  func getAllshippingTaxList() {
    WebService.shared.getShippingTaxes { [weak self] response in
      guard let self = self else { return }
      self.shippingDetails = response
      DispatchQueue.main.async {
        self.hostVC.shippingTableView.reloadData()
        self.hostVC.noDataFoundLabel.isHidden = !(self.shippingDetails?.isEmpty ?? false)
      }
    }
  }
  
}
