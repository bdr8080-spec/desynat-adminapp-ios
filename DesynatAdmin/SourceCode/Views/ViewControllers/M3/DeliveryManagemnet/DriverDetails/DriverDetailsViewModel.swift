//
//  DriverDetailsViewModel.swift
//  DesynatAdmin
//
//  Created by Rakhi Kumari on 23/11/25.
//

import Foundation

class DriverDetailsViewModel {
  
  private var hostVC: DriverDetailsViewController?
  
  init(hostVC: DriverDetailsViewController) {
    self.hostVC = hostVC
  }
  
  func getDriverDetails() {
    let params: [String : Any] = ["user_id": hostVC?.userId ?? 0]
    WebService.shared.getDriverDetails(param: params) { [weak self] response in
      guard let self = self else { return }
      DispatchQueue.main.async {
        self.hostVC?.configData(data: response)
      }
    }
  }
    
    func deleteBoy(param: [String: Any]) {
      WebService.shared.deleteBoy(param: param){ [weak self] response in
        CommonUtils.showToast(message: "Driver deleted succesfully")
        guard let self = self else { return }
        DispatchQueue.main.async {
          self.hostVC?.navigationController?.popViewController(animated: true)
        }
      }
    }
  
}
