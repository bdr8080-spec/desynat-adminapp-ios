//
//  ManageSellerPayoutViewModel.swift
//  DesynatAdmin
//
//  Created by fluper_mac3 on 19/03/26.
//

import Foundation

class ManageSellerPayoutViewModel {
    
    private var hostVC: ManageSellerPayoutViewController
    
    var historyListData: [PayoutHistory] = []
    var currentPage: Int = 1
    var totalPages: Int = 1
    
    init(hostVC: ManageSellerPayoutViewController) {
      self.hostVC = hostVC
    }
    
    func getSellerPayoutHistory() {
      var params: [String : Any] = [:]
      
      params["page"] = currentPage
      params["limit"] = 3
     params["seller_id"] = hostVC.payoutDetails?.storeInfo?.sellerId ?? 0
      // API CALL
      WebService.shared.getSellerPayoutHistoryRequests(param: params) { [weak self] response in
        guard let self = self else { return }
          self.hostVC.totalPendingAmountLabel.text = CommonUtils.formatPriceStringInput(response.pendingAmount ?? "0.0")
          self.currentPage = response.payoutHistory?.currentPage ?? 1
          self.totalPages = response.payoutHistory?.lastPage ?? 1
        
          self.historyListData = response.payoutHistory?.data ?? []
        
        DispatchQueue.main.async {
          self.hostVC.pageLabel.text = String(format: "%02d of %02d", self.currentPage, self.totalPages)
          self.hostVC.listTableView.reloadData()
          self.hostVC.noDataFoundLabel.isHidden = !self.historyListData.isEmpty
          self.hostVC.updatePaginationButtonImages()
        }
      }
    }
    
    func goToNextPage() {
      guard currentPage < totalPages else { return }
      currentPage += 1
        getSellerPayoutHistory()
    }
    
    func goToPreviousPage() {
      guard currentPage > 1 else { return }
      currentPage -= 1
        getSellerPayoutHistory()
    }

    
}
