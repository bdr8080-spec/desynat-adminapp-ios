//
//  AddEditShippingChargesViewModel.swift
//  DesynatAdmin
//
//  Created by fluper on 09/12/25.
//

import Foundation


class AddEditShippingChargesViewModel {
  
  private var hostVC: AddEditShippingChargesViewController?
  
  init(hostVC: AddEditShippingChargesViewController) {
    self.hostVC = hostVC
  }
  
  func editShippingInfo(param: [String: Any]) {
    WebService.shared.editShippingInfo(param: param) { [weak self] response in
      guard let self = self else { return }
      DispatchQueue.main.async {
        CommonUtils.showToast(message: "Delivery charge updated successfully")
        self.hostVC?.changesAreDone?()
        self.hostVC?.dismiss(animated: true)
      }
    }
  }
  
  func addShippingInfo(param: [String: Any]) {
    WebService.shared.addNewShippingCharge(param: param) { [weak self] response in
      guard let self = self else { return }
      DispatchQueue.main.async {
        CommonUtils.showToast(message: "Delivery charge added successfully")
        self.hostVC?.changesAreDone?()
        self.hostVC?.dismiss(animated: true)
      }
    }
  }
  
}
