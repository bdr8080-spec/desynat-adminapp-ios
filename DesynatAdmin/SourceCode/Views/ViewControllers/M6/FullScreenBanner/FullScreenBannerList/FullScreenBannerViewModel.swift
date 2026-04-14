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
    var promotionalListData: [GetPromotionalBannersList] = []
    var currentPage: Int = 1
    var totalPages: Int = 1
    var searchText: String = ""
    var fullScreenFilter = FullScreenBannerFilterModel()
    var promotionalFilter = FullScreenBannerFilterModel()
    
    var appliedFilter: FullScreenBannerFilterModel {
        get {
            return hostVC?.bannerType == .fullScreen ? fullScreenFilter : promotionalFilter
        }
        set {
            if hostVC?.bannerType == .fullScreen {
                fullScreenFilter = newValue
            } else {
                promotionalFilter = newValue
            }
        }
    }
    
    
    init(hostVC: FullScreenBannerViewController) {
        self.hostVC = hostVC
    }
    
    func convertDateString(
        _ dateString: String,
        from inputFormat: String = "dd/MM/yyyy",
        to outputFormat: String = "yyyy-MM-dd"
    ) -> String? {
        
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = inputFormat
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = outputFormat
        outputFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        guard let date = inputFormatter.date(from: dateString) else {
            return nil
        }
        
        return outputFormatter.string(from: date)
    }
    
    
    func getAllFullScreenBanners() {
        var params: [String : Any] = [:]
        params["page"] = currentPage
        params["limit"] = 2
        
        if !searchText.isEmpty {
            params["search"] = searchText
        }
        
        
        
        if let bannerType = appliedFilter.bannerType, bannerType > 0 {
            params["type"] = bannerType
        }
        
        if let toDate = appliedFilter.toDate,
           let formattedToDate = convertDateString(toDate) {
            params["to_date"] = formattedToDate
        }
        
        // From Date
        if let fromDate = appliedFilter.fromDate,
           let formattedFromDate = convertDateString(fromDate) {
            params["from_date"] = formattedFromDate
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
    
    func getPromotionalBanners() {
        var params: [String : Any] = [:]
        params["page"] = currentPage
        params["limit"] = 2
        
        if !searchText.isEmpty {
            params["search"] = searchText
        }
        
        if let bannerType = appliedFilter.bannerType {
            params["banner_position"] = bannerType + 1
        }
        
        
        if let toDate = appliedFilter.toDate,
           let formattedToDate = convertDateString(toDate) {
            params["end_date"] = formattedToDate
        }
        
        // From Date
        if let fromDate = appliedFilter.fromDate,
           let formattedFromDate = convertDateString(fromDate) {
            params["start_date"] = formattedFromDate
        }
        
        WebService.shared.getAllPromotionalBanners(param: params) { [weak self] response in
            guard let self = self else { return }
            
            // Update page info
            self.currentPage = response.currentPage ?? 1
            self.totalPages = response.lastPage ?? 1
            
            // Update data
            self.promotionalListData = response.data ?? []
            
            DispatchQueue.main.async {
                self.hostVC?.pageCountLabel.text = String(format: "%02d of %02d", self.currentPage, self.totalPages)
                self.hostVC?.bannerTableView.reloadData()
                self.hostVC?.noDataFoundLabel.isHidden = !self.promotionalListData.isEmpty
                self.hostVC?.updatePaginationButtonImages()
            }
        }
    }
    
    func goToNextPage() {
        guard currentPage < totalPages else { return }
        currentPage += 1
        if hostVC?.bannerType == .fullScreen {
            getAllFullScreenBanners()
        } else {
            getPromotionalBanners()
        }
    }
    
    func goToPreviousPage() {
        guard currentPage > 1 else { return }
        currentPage -= 1
        if hostVC?.bannerType == .fullScreen {
            getAllFullScreenBanners()
        } else {
            getPromotionalBanners()
        }
    }
}
