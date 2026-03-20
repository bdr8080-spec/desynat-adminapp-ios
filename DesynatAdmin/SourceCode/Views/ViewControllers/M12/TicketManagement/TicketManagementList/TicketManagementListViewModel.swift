//
//  TicketManagementListViewModel.swift
//  DesynatAdmin
//
//  Created by fluper_mac3 on 20/03/26.
//

import Foundation

class TicketManagementListViewModel {
    
    private var hostVC: TicketManagementListViewController
    var affilitaitedUsersList: [AffilitaitedUsersDataModel] = []
    var currentPage: Int = 1
    var totalPages: Int = 1
    var searchText: String = ""
    var newUsersFilter = FullScreenBannerFilterModel()
    var approvedUsersFilter = FullScreenBannerFilterModel()
    var rejectedUsersFilter = FullScreenBannerFilterModel()
    
    init(hostVC: TicketManagementListViewController) {
        self.hostVC = hostVC
    }
    
    // Helper
    func filter(for type: AffiliatedUsersListType) -> FullScreenBannerFilterModel {
        switch type {
        case .newUsers: return newUsersFilter
        case .approvedUsers: return approvedUsersFilter
        case .rejectedUsers: return rejectedUsersFilter
        }
    }
    
    func setFilter(_ filter: FullScreenBannerFilterModel, for type: AffiliatedUsersListType) {
        switch type {
        case .newUsers: newUsersFilter = filter
        case .approvedUsers: approvedUsersFilter = filter
        case .rejectedUsers: rejectedUsersFilter = filter
        }
    }
    
    func fetchNewAffiliatedUsersList() {
        let filter = newUsersFilter
        var params: [String : Any] = [:]
        params["page"] = currentPage
        params["limit"] = 3
        if !searchText.isEmpty {
            params["search"] = searchText
        }
        
        if let country = filter.countryName {
            params["country"] = country
        }
        
        if let fromDate = filter.fromDate {
            params["from_date"] = convertDate(fromDate)
        }
        
        if let toDate = filter.toDate {
            params["to_date"] = convertDate(toDate)
        }
        
        WebService.shared.getNewAffilaitedUsersRequest(param: params) { [weak self] response in
            guard let self = self else { return }
            
            // Update page info
            self.currentPage = response.currentPage ?? 1
            self.totalPages = response.lastPage ?? 1
            
            // Update data
            self.affilitaitedUsersList = response.data ?? []
            DispatchQueue.main.async {
                self.hostVC.pageCountLabel.text = String(format: "%02d of %02d", self.currentPage, self.totalPages)
                self.hostVC.listTableView.reloadData()
                self.hostVC.noDataFoundLabel.isHidden = !self.affilitaitedUsersList.isEmpty
                self.hostVC.updatePaginationButtonImages()
            }
        }
    }
    
    func fetchApprovedAffiliatedUsersList() {
        
        let filter = approvedUsersFilter
        var params: [String : Any] = [:]
        params["page"] = currentPage
        params["limit"] = 3
        if !searchText.isEmpty {
            params["search"] = searchText
        }
        
        if let country = filter.countryName {
            params["country1"] = country
        }
        
        if let fromDate = filter.fromDate {
            params["from_date1"] = convertDate(fromDate)
        }
        
        if let toDate = filter.toDate {
            params["to_date1"] = convertDate(toDate)
        }
        
        WebService.shared.getApprovedAffilaitedUsersRequest(param: params) { [weak self] response in
            guard let self = self else { return }
            
            // Update page info
            self.currentPage = response.currentPage ?? 1
            self.totalPages = response.lastPage ?? 1
            
            // Update data
            self.affilitaitedUsersList = response.data ?? []
            DispatchQueue.main.async {
                self.hostVC.pageCountLabel.text = String(format: "%02d of %02d", self.currentPage, self.totalPages)
                self.hostVC.listTableView.reloadData()
                self.hostVC.noDataFoundLabel.isHidden = !self.affilitaitedUsersList.isEmpty
                self.hostVC.updatePaginationButtonImages()
            }
        }
    }
    
    func fetchRejectedAffiliatedUsersList() {
        let filter = rejectedUsersFilter
        var params: [String : Any] = [:]
        params["page"] = currentPage
        params["limit"] = 3
        if !searchText.isEmpty {
            params["search"] = searchText
        }
        
        if let country = filter.countryName {
            params["country2"] = country
        }
        
        if let fromDate = filter.fromDate {
            params["from_date2"] = convertDate(fromDate)
        }
        
        if let toDate = filter.toDate {
            params["to_date2"] = convertDate(toDate)
        }
        
        WebService.shared.getRejectedAffilaitedUsersRequest(param: params) { [weak self] response in
            guard let self = self else { return }
            
            // Update page info
            self.currentPage = response.currentPage ?? 1
            self.totalPages = response.lastPage ?? 1
            
            // Update data
            self.affilitaitedUsersList = response.data ?? []
            DispatchQueue.main.async {
                self.hostVC.pageCountLabel.text = String(format: "%02d of %02d", self.currentPage, self.totalPages)
                self.hostVC.listTableView.reloadData()
                self.hostVC.noDataFoundLabel.isHidden = !self.affilitaitedUsersList.isEmpty
                self.hostVC.updatePaginationButtonImages()
            }
        }
    }
    
    
    func goToNextPage(type: AffiliatedUsersListType) {
        guard currentPage < totalPages else { return }
        currentPage += 1
        switch type {
        case .newUsers:
            fetchNewAffiliatedUsersList()
        case .approvedUsers:
            fetchApprovedAffiliatedUsersList()
        case .rejectedUsers:
            fetchRejectedAffiliatedUsersList()
        }
    }
    
    func goToPreviousPage(type: AffiliatedUsersListType) {
        guard currentPage > 1 else { return }
        currentPage -= 1
        switch type {
        case .newUsers:
            fetchNewAffiliatedUsersList()
        case .approvedUsers:
            fetchApprovedAffiliatedUsersList()
        case .rejectedUsers:
            fetchRejectedAffiliatedUsersList()
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
