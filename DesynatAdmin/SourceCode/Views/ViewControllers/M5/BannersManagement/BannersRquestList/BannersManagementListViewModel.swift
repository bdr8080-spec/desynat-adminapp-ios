//
//  BannersManagementListViewModel.swift
//  DesynatAdmin
//
//  Created by fluper on 16/12/25.
//

import Foundation

class BannersManagementListViewModel {
  
  private var hostVC: BannersManagementListViewController?
  var appliedFilter = UserFilterModel()
  var currentPage: Int = 1
  var totalPages: Int = 1
  var searchText: String = ""
  
  init(hostVC: BannersManagementListViewController? = nil) {
    self.hostVC = hostVC
  }
  
  func getAllBannersList() {
    hostVC?.bannersTableView.reloadData()
  }
  
}
