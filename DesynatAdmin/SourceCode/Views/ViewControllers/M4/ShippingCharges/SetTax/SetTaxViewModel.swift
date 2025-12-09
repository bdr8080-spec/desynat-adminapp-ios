//
//  SetTaxViewModel.swift
//  DesynatAdmin
//
//  Created by fluper on 09/12/25.
//

import Foundation

class SetTaxViewModel {
  
  private var hostVC: SetTaxViewController?
  
  init(hostVC: SetTaxViewController?) {
    self.hostVC = hostVC
  }
  
  func addShippingFees(param: [String: Any]) {
    WebService.shared.addShippingFees(param: param){ [weak self] response in
      guard let self = self else { return }
      DispatchQueue.main.async { [weak self] in
        guard let self else { return }
        self.hostVC?.dismiss(animated: true)
        let taxAmount = hostVC?.taxTF.text ?? ""
        self.hostVC?.taxAmountSet?(taxAmount)
      }
    }
  }
}
