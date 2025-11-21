//
//  UserManagementViewModel.swift
//  DesynatAdmin
//
//  Created by fluper on 21/11/25.
//

import Foundation

class UserManagementViewModel {
  
  private var hostVC: UserManagementViewController?
  var usersListData: [UsersListModel] = []
  var currentPage: Int = 1
  var totalPages: Int = 1
  var searchText: String = ""
  var appliedFilter = UserFilterModel()

  init(hostVC: UserManagementViewController) {
    self.hostVC = hostVC
  }
  
  func getAllUsers() {
      var params: [String : Any] = [:]

      params["page"] = currentPage
      params["limit"] = 3

      // Search
      if !searchText.isEmpty {
          params["search"] = searchText
      }

      // --- APPLY FILTERS ONLY IF SELECTED ---
      
      // Country filter
      if let id = appliedFilter.countryId {
          params["country_id"] = id
      }

      // From Date
      if let fromDate = appliedFilter.fromDate {
          params["from_date"] = fromDate
      }

      // To Date
      if let toDate = appliedFilter.toDate {
          params["to_date"] = toDate
      }

      print("FINAL PARAMS →", params)

      // API CALL
      WebService.shared.getAllUsers(param: params) { [weak self] response in
          guard let self = self else { return }

          self.currentPage = response.currentPage ?? 1
          self.totalPages = response.lastPage ?? 1

          self.usersListData = response.data ?? []

          DispatchQueue.main.async {
              self.hostVC?.pageCountLabel.text = String(format: "%02d of %02d", self.currentPage, self.totalPages)
              self.hostVC?.userTableView.reloadData()
              self.hostVC?.noDataFoundLabel.isHidden = !self.usersListData.isEmpty
              self.hostVC?.updatePaginationButtonImages()
          }
      }
  }

  
  func goToNextPage() {
    guard currentPage < totalPages else { return }
    currentPage += 1
    getAllUsers()
  }
  
  func goToPreviousPage() {
    guard currentPage > 1 else { return }
    currentPage -= 1
    getAllUsers()
  }
  
  func updateActiveStatus(param: [String: Any], completion: @escaping (Bool) -> Void) {
      WebService.shared.updateUserStatus(param: param){ [weak self] response in
          guard let self = self else { return }
          completion(true)
      }
  }
}
