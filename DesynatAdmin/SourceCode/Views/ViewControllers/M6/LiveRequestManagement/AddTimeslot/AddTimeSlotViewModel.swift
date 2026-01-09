//
//  AddTimeSlotViewModel.swift
//  DesynatAdmin
//
//  Created by fluper on 08/01/26.
//

import Foundation

class AddTimeSlotViewModel {
  
  private var hostVC: AddTimeSlotViewController
  
  init(hostVC: AddTimeSlotViewController) {
    self.hostVC = hostVC
  }
  
  func addTimeSlotRequest(param: [String: Any]) {
    WebService.shared.addTimeSlot(param: param){ [weak self] response in
      guard let self = self else { return }
      DispatchQueue.main.async {
        self.hostVC.onChangesDone?()
        self.hostVC.dismiss(animated: true)
      }
    }
  }
  
  func editTimeSlotRequest(param: [String: Any]) {
    WebService.shared.editTimeSlot(param: param){ [weak self] response in
      guard let self = self else { return }
      DispatchQueue.main.async {
        self.hostVC.onChangesDone?()
        self.hostVC.dismiss(animated: true)
      }
    }
  }
}
