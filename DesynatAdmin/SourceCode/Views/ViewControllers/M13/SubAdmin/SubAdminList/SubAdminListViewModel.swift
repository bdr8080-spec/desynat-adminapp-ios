//
//  SubAdminListViewModel.swift
//  DesynatAdmin
//
//  Created by fluper_mac3 on 26/03/26.
//

import Foundation

class SubAdminListViewModel {
    
    private var hostVC: SubAdminListViewController?
    var subAdminUsersList: [StaffDetails] = []
    var currentPage: Int = 1
    var totalPages: Int = 1
    var searchText: String = ""
    var newUsersFilter = FullScreenBannerFilterModel()
    var approvedUsersFilter = FullScreenBannerFilterModel()
    var rejectedUsersFilter = FullScreenBannerFilterModel()
    
    init(hostVC: SubAdminListViewController? = nil) {
        self.hostVC = hostVC
    }
    
    // Helper
    func filter(for type: SubAdminListType) -> FullScreenBannerFilterModel {
        switch type {
        case .all: return newUsersFilter
        case .active: return approvedUsersFilter
        case .inactive: return rejectedUsersFilter
        }
    }
    
    func setFilter(_ filter: FullScreenBannerFilterModel, for type: SubAdminListType) {
        switch type {
        case .all: newUsersFilter = filter
        case .active: approvedUsersFilter = filter
        case .inactive: rejectedUsersFilter = filter
        }
    }
    
    func fetchAllSubAdminUsersList() {
        let filter = newUsersFilter
        var params: [String : Any] = [:]
        params["page"] = currentPage
        params["limit"] = 3
        
        if !searchText.isEmpty {
            params["search"] = searchText
        }
        
        if let country = filter.countryID {
            params["country_id"] = country
        }
        
        if let fromDate = filter.fromDate {
            params["from_date"] = convertDate(fromDate)
        }
        
        if let toDate = filter.toDate {
            params["to_date"] = convertDate(toDate)
        }
        
        WebService.shared.getSubAdminService(param: params) { [weak self] response in
            guard let self = self else { return }
            
            // Update page info
            self.currentPage = response.list?.currentPage ?? 1
            self.totalPages = response.list?.lastPage ?? 1
            
            // Update data
            self.subAdminUsersList = response.list?.data ?? []
            DispatchQueue.main.async {
                self.hostVC?.pageCountLabel.text = String(format: "%02d of %02d", self.currentPage, self.totalPages)
                self.hostVC?.listTableView.reloadData()
                self.hostVC?.noDataFoundLabel.isHidden = !self.subAdminUsersList.isEmpty
                self.hostVC?.updatePaginationButtonImages()
            }
        }
    }
    
    func fetchActiveSubAdminsList() {
        let filter = approvedUsersFilter
        var params: [String : Any] = [:]
        params["page"] = currentPage
        params["limit"] = 3
        if !searchText.isEmpty {
            params["search"] = searchText
        }
        
        if let country = filter.countryID {
            params["country_id"] = country
        }
        
        if let fromDate = filter.fromDate {
            params["from_date"] = convertDate(fromDate)
        }
        
        if let toDate = filter.toDate {
            params["to_date"] = convertDate(toDate)
        }
        
        WebService.shared.getSubAdminService(param: params) { [weak self] response in
            guard let self = self else { return }
            
            // Update page info
            self.currentPage = response.list?.currentPage ?? 1
            self.totalPages = response.list?.lastPage ?? 1
            
            // Update data
            self.subAdminUsersList = response.list?.data ?? []
            DispatchQueue.main.async {
                self.hostVC?.pageCountLabel.text = String(format: "%02d of %02d", self.currentPage, self.totalPages)
                self.hostVC?.listTableView.reloadData()
                self.hostVC?.noDataFoundLabel.isHidden = !self.subAdminUsersList.isEmpty
                self.hostVC?.updatePaginationButtonImages()
            }
        }
    }
    
    func fetchInactiveSubAdminList() {
        let filter = rejectedUsersFilter
        var params: [String : Any] = [:]
        params["page"] = currentPage
        params["limit"] = 3
        if !searchText.isEmpty {
            params["search"] = searchText
        }
        
        if let country = filter.countryID {
            params["country_id"] = country
        }
        
        if let fromDate = filter.fromDate {
            params["from_date"] = convertDate(fromDate)
        }
        
        if let toDate = filter.toDate {
            params["to_date"] = convertDate(toDate)
        }
        
        WebService.shared.getSubAdminService(param: params) { [weak self] response in
            guard let self = self else { return }
            
            // Update page info
            self.currentPage = response.list?.currentPage ?? 1
            self.totalPages = response.list?.lastPage ?? 1
            
            // Update data
            self.subAdminUsersList = response.list?.data ?? []
            DispatchQueue.main.async {
                self.hostVC?.pageCountLabel.text = String(format: "%02d of %02d", self.currentPage, self.totalPages)
                self.hostVC?.listTableView.reloadData()
                self.hostVC?.noDataFoundLabel.isHidden = !self.subAdminUsersList.isEmpty
                self.hostVC?.updatePaginationButtonImages()
            }
        }
    }
    
    func goToNextPage(type: SubAdminListType) {
        guard currentPage < totalPages else { return }
        currentPage += 1
        switch type {
        case .all:
            fetchAllSubAdminUsersList()
        case .active:
            fetchActiveSubAdminsList()
        case .inactive:
            fetchInactiveSubAdminList()
        }
    }
    
    func goToPreviousPage(type: SubAdminListType) {
        guard currentPage > 1 else { return }
        currentPage -= 1
        switch type {
        case .all:
            fetchAllSubAdminUsersList()
        case .active:
            fetchActiveSubAdminsList()
        case .inactive:
            fetchInactiveSubAdminList()
        }
    }
    
    func convertDate(
        _ dateString: String,
        from inputFormat: String = "dd/MM/yyyy",
        to outputFormat: String = "yyyy-MM-dd"
    ) -> String? {
        
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = inputFormat
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        guard let date = inputFormatter.date(from: dateString) else {
            return nil
        }
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = outputFormat
        outputFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        return outputFormatter.string(from: date)
    }
    
}
