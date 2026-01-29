//
//  DealDetailsViewModel.swift
//  DesynatAdmin
//
//  Created by fluper on 08/01/26.
//

import Foundation
import UIKit

class DealDetailsViewModel {
  
  private var hostVC: DealDetailsViewController
    let pageSize = 2
    var currentPage: Int = 1

    var totalItems: Int {
        hostVC.dealData?.sellerDealrecords?.count ?? 0
    }

    var totalPages: Int {
        return Int(ceil(Double(totalItems) / Double(pageSize)))
    }

    var paginatedItems: [SellerDealrecord] {
        guard let records = hostVC.dealData?.sellerDealrecords else { return [] }

        let startIndex = (currentPage - 1) * pageSize
        let endIndex = min(startIndex + pageSize, records.count)

        guard startIndex < endIndex else { return [] }
        return Array(records[startIndex..<endIndex])
    }
  init(hostVC: DealDetailsViewController) {
    self.hostVC = hostVC
  }
  
  func getDealDetailsList() {
    let param: [String: Any] = ["deal_id": hostVC.dealId]
    WebService.shared.getDealDetailsList(param: param){ [weak self] response in
      guard let self = self else { return }
      DispatchQueue.main.async {
        self.hostVC.dealData = response
        self.hostVC.bindData()
      }
    }
  }
  
  func upadteDealStatus(param: [String: Any]) {
    WebService.shared.dealDetailsStatusUpdate(param: param) { [weak self] response in
      guard let self = self else { return }
      DispatchQueue.main.async {
        self.hostVC.dealData?.status = response.status
        if let status = response.status {
          self.hostVC.statusLabel.text = status == 1 ? "Active" : "Inactive"
          self.hostVC.statusImageView.image =
          UIImage(named: status == 1 ? "toggleOn" : "toggleOff")
          CommonUtils.showToast(
            message: status == 1 ? "Deal Activated Successfully"
            : "Deal Deactivated Successfully"
          )
        }
      }
    }
  }
  
  func deleteDealDetails(param: [String: Any]) {
    WebService.shared.deleteDealDetails(param: param){ [weak self] response in
      guard let self = self else { return }
      DispatchQueue.main.async {
        CommonUtils.showToast(message: "Deal Deleted Successfully")
        self.hostVC.navigationController?.popViewController(animated: true)
      }
    }
  }
  
}

