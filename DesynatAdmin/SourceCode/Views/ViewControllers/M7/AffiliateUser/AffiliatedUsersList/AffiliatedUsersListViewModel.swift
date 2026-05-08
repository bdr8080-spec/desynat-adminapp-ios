//
//  AffiliatedUsersListViewModel.swift
//  DesynatAdmin
//
//  Created by fluper_mac3 on 21/01/26.
//

import Foundation

class AffiliatedUsersListViewModel {
    
    private var hostVC: AffiliatedUsersListViewController?
    var affilitaitedUsersList: [AffilitaitedUsersDataModel] = []
    var currentPage: Int = 1
    var totalPages: Int = 1
    var searchText: String = ""
    var newUsersFilter = FullScreenBannerFilterModel()
    var approvedUsersFilter = FullScreenBannerFilterModel()
    var rejectedUsersFilter = FullScreenBannerFilterModel()
    
    init(hostVC: AffiliatedUsersListViewController? = nil) {
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
                self.hostVC?.pageCountLabel.text = String(format: "%02d of %02d", self.currentPage, self.totalPages)
                self.hostVC?.listTableView.reloadData()
                self.hostVC?.noDataFoundLabel.isHidden = !self.affilitaitedUsersList.isEmpty
                self.hostVC?.updatePaginationButtonImages()
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
                self.hostVC?.pageCountLabel.text = String(format: "%02d of %02d", self.currentPage, self.totalPages)
                self.hostVC?.listTableView.reloadData()
                self.hostVC?.noDataFoundLabel.isHidden = !self.affilitaitedUsersList.isEmpty
                self.hostVC?.updatePaginationButtonImages()
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
                self.hostVC?.pageCountLabel.text = String(format: "%02d of %02d", self.currentPage, self.totalPages)
                self.hostVC?.listTableView.reloadData()
                self.hostVC?.noDataFoundLabel.isHidden = !self.affilitaitedUsersList.isEmpty
                self.hostVC?.updatePaginationButtonImages()
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
    
    func AcceptUserRequest(param: [String: Any]) {
        WebService.shared.acceptAffilaitedUsersRequest(param: param) { [weak self] response in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                let vc = RegisterationSuccessViewController.instantiate(fromAppStoryboard: .Main)
                vc.comingReason = .AffiliateUserManagement
                vc.callBackDismiss = {
                    self.currentPage = 1
                    self.fetchNewAffiliatedUsersList()
                }
                self.hostVC?.navigationController?.present(vc, animated: true)
            }
        }
    }
    
    func RejectUserRequest(param: [String: Any]) {
        WebService.shared.rejectAffilaitedUsersRequest(param: param) { [weak self] response in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.currentPage = 1
                self.fetchNewAffiliatedUsersList()
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
//        inputFormatter.locale = Locale(identifier: "en_US_POSIX")
        if AppLanguageManager.shared.currentLanguage == .ar {
            inputFormatter.locale = Locale(identifier: "ar")
           } else {
               inputFormatter.locale = Locale(identifier: "en_US")
           }
        guard let date = inputFormatter.date(from: dateString) else {
            return nil
        }
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = outputFormat
//        outputFormatter.locale = Locale(identifier: "en_US_POSIX")
        if AppLanguageManager.shared.currentLanguage == .ar {
            outputFormatter.locale = Locale(identifier: "ar")
           } else {
               outputFormatter.locale = Locale(identifier: "en_US")
           }
        return outputFormatter.string(from: date)
    }
    
}
