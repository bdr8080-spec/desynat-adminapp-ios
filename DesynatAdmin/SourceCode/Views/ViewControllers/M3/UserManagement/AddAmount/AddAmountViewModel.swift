//
//  AddAmountViewModel.swift
//  DesynatAdmin
//
//  Created by fluper on 21/11/25.
//

import Foundation

class AddAmountViewModel {
  
  private var hostVC: AddAmountForUserViewController?
  
  init(hostVC: AddAmountForUserViewController) {
    self.hostVC = hostVC
  }
  
  func addAmountAPI() {
    let params: [String: Any] = ["user_id": hostVC?.userId ?? 0,
                                 "amount": hostVC?.amountTextFiled.text?.trimmed() ?? ""]
      WebService.shared.addAmountUserStatus(param: params){ [weak self] response in
          guard let self = self else { return }
        self.hostVC?.onAmountAdded?()
        self.hostVC?.dismiss(animated: false)
        CommonUtils.showToastForOTP(message: "Amount added in the wallet succesfully")
        self.hostVC?.navigationController?.popViewController(animated: true)
      }
  }
  
  func validFields() -> Bool {
      var errorMessage: AlertConstant = .none
          let input = String.getString(hostVC?.amountTextFiled.text).trimmingCharacters(in: .whitespacesAndNewlines)
          if input.isEmpty {
              errorMessage = .enterAmount
          }
      
      if errorMessage != .none {
        hostVC?.showAlert(msg: errorMessage.rawValue)
      }
      
    hostVC?.view.endEditing(true)
      return errorMessage == .none
  }

}
