//
//  AffiliatedWithdrawalRequestListViewModel.swift
//  DesynatAdmin
//
//  Created by fluper_mac3 on 25/02/26.
//

import Foundation

class AffiliatedWithdrawalRequestListViewModel {
    
    private var hostVC: AffiliatedWithdrawalRequestListViewController
    
    var affilitaitedUsersList: [AffiliatedWithdrawalList] = []
    var currentPage: Int = 1
    var totalPages: Int = 1
    var searchText: String = ""
    var newUsersFilter = FullScreenBannerFilterModel()
    var approvedUsersFilter = FullScreenBannerFilterModel()
    var rejectedUsersFilter = FullScreenBannerFilterModel()
    
    init(hostVC: AffiliatedWithdrawalRequestListViewController) {
        self.hostVC = hostVC
    }
    
    // Helper
    func filter(for type: AffiliatedWithdrawalListType) -> FullScreenBannerFilterModel {
        switch type {
        case .newRequest: return newUsersFilter
        case .approvedRequest: return approvedUsersFilter
        case .rejectedRequest: return rejectedUsersFilter
        }
    }
    
    func setFilter(_ filter: FullScreenBannerFilterModel, for type: AffiliatedWithdrawalListType) {
        switch type {
        case .newRequest: newUsersFilter = filter
        case .approvedRequest: approvedUsersFilter = filter
        case .rejectedRequest: rejectedUsersFilter = filter
        }
    }
    
    func fetchNewAffiliatedUsersList() {
        let filter = newUsersFilter
        var params: [String : Any] = [:]
        params["req_type"] = 0//0-pending,1-approved,2-rejected
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
        
        WebService.shared.getWithdrawalRequestOfAffilaitedUsersRequest(param: params) { [weak self] response in
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
        params["req_type"] = 1//0-pending,1-approved,2-rejected
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
        
        WebService.shared.getWithdrawalRequestOfAffilaitedUsersRequest(param: params) { [weak self] response in
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
        params["req_type"] = 2//0-pending,1-approved,2-rejected
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
        
        WebService.shared.getWithdrawalRequestOfAffilaitedUsersRequest(param: params) { [weak self] response in
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
    
    func goToNextPage(type: AffiliatedWithdrawalListType) {
        guard currentPage < totalPages else { return }
        currentPage += 1
        switch type {
        case .newRequest:
            fetchNewAffiliatedUsersList()
        case .approvedRequest:
            fetchApprovedAffiliatedUsersList()
        case .rejectedRequest:
            fetchRejectedAffiliatedUsersList()
        }
    }
    
    func goToPreviousPage(type: AffiliatedWithdrawalListType) {
        guard currentPage > 1 else { return }
        currentPage -= 1
        switch type {
        case .newRequest:
            fetchNewAffiliatedUsersList()
        case .approvedRequest:
            fetchApprovedAffiliatedUsersList()
        case .rejectedRequest:
            fetchRejectedAffiliatedUsersList()
        }
    }
    
    func AcceptUserRequest(param: [String: Any]) {
        WebService.shared.approvedAffilatedWithdrwalRequestRequest(param: param) { [weak self] response in
            guard let self = self else { return }
            DispatchQueue.main.async {
                let vc = RegisterationSuccessViewController.instantiate(fromAppStoryboard: .Main)
                vc.comingReason = .AffiliateUserManagement
                vc.callBackDismiss = {
                    self.currentPage = 1
                    self.hostVC.handleApprovedSelection()
                }
                self.hostVC.navigationController?.present(vc, animated: true)
            }
        }
    }
    
    func RejectUserRequest(param: [String: Any]) {
        WebService.shared.rejectAffilatedWithdrwalRequestRequest(param: param) { [weak self] response in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.currentPage = 1
                self.hostVC.handleRejectedSelection()
            }
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
