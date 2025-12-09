//
//  BannerPerDayListViewModel.swift
//  DesynatAdmin
//
//  Created by fluper on 09/12/25.
//

import Foundation

class BannerPerDayListViewModel {
  
  private var hostVC: BannerPerDayListViewController?
  var bannersListData: [BannersPerDayListDataModel] = []
  
  init(hostVC: BannerPerDayListViewController) {
    self.hostVC = hostVC
  }
  
  func getAllBannersPerDay() {
    var params: [String : Any] = [:]
    params["type"] = hostVC?.type
    WebService.shared.getBannersPerDay(param: params) { [weak self] response in
      guard let self = self else { return }
      self.bannersListData = response
      DispatchQueue.main.async {
        self.hostVC?.bannersTableView.reloadData()
        self.hostVC?.noDataFoundLabel.isHidden = !self.bannersListData.isEmpty
      }
    }
  }

}
