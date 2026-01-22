//
//  AffiliatedUsersListViewModel.swift
//  DesynatAdmin
//
//  Created by fluper_mac3 on 21/01/26.
//

import Foundation

class AffiliatedUsersListViewModel {
    
    private var hostVC: AffiliatedUsersListViewController?
    var reasonListData: [DealListManagementList] = []
    var currentPage: Int = 1
    var totalPages: Int = 1
    var searchText: String = ""
    var appliedFilter = UserFilterModel()
    
    init(hostVC: AffiliatedUsersListViewController? = nil) {
        self.hostVC = hostVC
    }
    

    func fetchAffiliatedUsersList() {
        hostVC?.listTableView.reloadData()
//      var params: [String : Any] = [:]
//      params["page"] = currentPage
//        params["type"] = hostVC?.userType.rawValue ?? 1
//  //    params["type"] = hostVC?.type
//      params["limit"] = 2
//      if !searchText.isEmpty {
//        params["search"] = searchText
//      }
//      
//      WebService.shared.getActiveDeals(param: params) { [weak self] response in
//        guard let self = self else { return }
//        
//        // Update page info
//        self.currentPage = response.currentPage ?? 1
//        self.totalPages = response.lastPage ?? 1
//        
//        // Update data
//        self.reasonListData = response.data ?? []
//        
//        DispatchQueue.main.async {
//          self.hostVC?.pageCountLabel.text = String(format: "%02d of %02d", self.currentPage, self.totalPages)
//          self.hostVC?.listTableView.reloadData()
//          self.hostVC?.noDataFoundLabel.isHidden = !self.reasonListData.isEmpty
//          self.hostVC?.updatePaginationButtonImages()
//        }
//      }
    }
    
    
    func goToNextPage(type: Int) {
      guard currentPage < totalPages else { return }
      currentPage += 1
//      if type == 1 {
//          fetchAffiliatedUsersList()
//      } else {
        fetchAffiliatedUsersList()
//      }
      
    }
    
    func goToPreviousPage(type: Int) {
      guard currentPage > 1 else { return }
      currentPage -= 1
//      if type == 1 {
          fetchAffiliatedUsersList()
//      } else {
//        getExpiredDeals()
//      }
    }
}
