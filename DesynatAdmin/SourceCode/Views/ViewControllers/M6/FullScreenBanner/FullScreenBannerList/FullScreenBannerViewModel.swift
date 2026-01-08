//
//  FullScreenBannerViewModel.swift
//  DesynatAdmin
//
//  Created by fluper on 08/01/26.
//

import Foundation

class FullScreenBannerViewModel {
  
  private var hostVC: FullScreenBannerViewController?
  var brandListData: [FullScreenBannerDataList] = []
  var currentPage: Int = 1
  var totalPages: Int = 1
  var searchText: String = ""
  var appliedFilter = FullScreenBannerFilterModel()
  
  init(hostVC: FullScreenBannerViewController) {
    self.hostVC = hostVC
  }
  
  func getAllFullScreenBanners() {
    var params: [String : Any] = [:]
    params["page"] = currentPage
    params["limit"] = 2
    
    if !searchText.isEmpty {
      params["search"] = searchText
    }
    
    // From Date
    if let fromDate = appliedFilter.fromDate {
      params["from_date"] = fromDate
    }
    
    // To Date
    if let toDate = appliedFilter.toDate {
      params["to_date"] = toDate
    }
    
    if let countryName = appliedFilter.countryName {
      params["country"] = countryName
    }
    
    WebService.shared.getAllFullScreenBanners(param: params) { [weak self] response in
      guard let self = self else { return }
      
      // Update page info
      self.currentPage = response.currentPage ?? 1
      self.totalPages = response.lastPage ?? 1
      
      // Update data
      self.brandListData = response.data ?? []
      
      DispatchQueue.main.async {
        self.hostVC?.pageCountLabel.text = String(format: "%02d of %02d", self.currentPage, self.totalPages)
        self.hostVC?.bannerTableView.reloadData()
        self.hostVC?.noDataFoundLabel.isHidden = !self.brandListData.isEmpty
        self.hostVC?.updatePaginationButtonImages()
      }
    }
  }
  
  func goToNextPage() {
    guard currentPage < totalPages else { return }
    currentPage += 1
    getAllFullScreenBanners()
  }
  
  func goToPreviousPage() {
    guard currentPage > 1 else { return }
    currentPage -= 1
    getAllFullScreenBanners()
  }
}
