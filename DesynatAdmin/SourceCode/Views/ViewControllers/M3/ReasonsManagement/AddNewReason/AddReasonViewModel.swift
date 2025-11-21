//
//  AddReasonViewModel.swift
//  DesynatAdmin
//
//  Created by fluper on 20/11/25.
//

import Foundation
import UIKit

class AddReasonViewModel: NSObject {
  private var hostVC: AddReasonViewController
  
  init(hostVC: AddReasonViewController) {
    self.hostVC = hostVC
  }
  
  func validFields() -> Bool {
    var errorMessage: AlertConstant = .none
    
    let englishName = String.getString(hostVC.englishReasonTF.text).trimmingCharacters(in: .whitespacesAndNewlines)
    if errorMessage == .none {
      if englishName.isEmpty {
        errorMessage = .EnterReasonEnglish
      }
    }
    
    let arabicName = String.getString(hostVC.arabicReasonTF.text).trimmingCharacters(in: .whitespacesAndNewlines)
    if errorMessage == .none {
      if arabicName.isEmpty {
        errorMessage = .EnterReasonArabic
      }
    }
    
    if errorMessage != .none {
      hostVC.showAlert(msg: errorMessage.rawValue)
    }
    
    hostVC.view.endEditing(true)
    return errorMessage == .none
  }
  
  
  func addReasonApi() {
    let params: [String:Any] = [
      "type":hostVC.type ?? 1,
      "reason_english": hostVC.englishReasonTF.text?.trimmed() ?? "",
      "reason_arabic": hostVC.arabicReasonTF.text?.trimmed() ?? ""]
    WebService.sharedInstance.addNewBrand(param: params) { (response) in
      DispatchQueue.main.async {
        CommonUtils.showToast(message: "Reason Added Succesfully")
        self.hostVC.onUpdate?()
        self.hostVC.dismiss(animated: true)
      }
    }
  }
  
  func editReasonApi() {
    let params: [String:Any] = [
      "reason_id": hostVC.reasonId ?? 0,
      "reason_english": hostVC.englishReasonTF.text?.trimmed() ?? "",
      "reason_arabic": hostVC.arabicReasonTF.text?.trimmed() ?? ""]
    WebService.sharedInstance.editReason(param: params) { (response) in
      DispatchQueue.main.async {
        CommonUtils.showToast(message: "Reason updated Succesfully ")
        self.hostVC.onUpdate?()
        self.hostVC.dismiss(animated: true)
      }
    }
  }
  
}

