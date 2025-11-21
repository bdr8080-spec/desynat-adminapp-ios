//
//  UserManagementDetailViewModel.swift
//  DesynatAdmin
//
//  Created by fluper on 21/11/25.
//

import Foundation

class UserManagementDetailViewModel {
  
  private var hostVC: UserManagementDetailsViewController?
  var userDetail: UsersListModel?
  
  init(hostVC: UserManagementDetailsViewController) {
    self.hostVC = hostVC
  }
  
  func getAUserDetails() {
    let params: [String : Any] = ["user_id": hostVC?.userId ?? 0]
    WebService.shared.getUserDetails(param: params) { [weak self] response in
      guard let self = self else { return }
      DispatchQueue.main.async {
        self.userDetail = response
        self.hostVC?.configData(data: response)
      }
    }
  }
  
  func updateActiveStatus(param: [String: Any], completion: @escaping (Bool) -> Void) {
      WebService.shared.updateUserStatus(param: param){ [weak self] response in
          guard let self = self else { return }
          completion(true)
      }
  }
  
}
