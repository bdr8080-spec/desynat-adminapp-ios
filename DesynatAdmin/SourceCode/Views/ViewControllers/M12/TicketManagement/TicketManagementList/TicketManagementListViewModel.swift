//
//  TicketManagementListViewModel.swift
//  DesynatAdmin
//
//  Created by fluper_mac3 on 20/03/26.
//

import Foundation

class TicketManagementListViewModel {
    
    private var hostVC: TicketManagementListViewController
    var ticketsList: [TicketManagementList] = []
    var currentPage: Int = 1
    var totalPages: Int = 1
    var searchText: String = ""
    var newListFilter = UserFilterModel()
    var ongoingListFilter = UserFilterModel()
    var pastListFilter = UserFilterModel()
    
    init(hostVC: TicketManagementListViewController) {
        self.hostVC = hostVC
    }
    
    // Helper
    func filter(for type: TiketListType) -> UserFilterModel {
        switch type {
        case .newList: return newListFilter
        case .ongoingList: return ongoingListFilter
        case .pastList: return pastListFilter
        }
    }
    
    func setFilter(_ filter: UserFilterModel, for type: TiketListType) {
        switch type {
        case .newList: newListFilter = filter
        case .ongoingList: ongoingListFilter = filter
        case .pastList: pastListFilter = filter
        }
    }
    
    func fetchNewTicketsList() {
        let filter = newListFilter
        var params: [String : Any] = [:]
        params["page"] = currentPage
        params["limit"] = 3
        if !searchText.isEmpty {
            params["search"] = searchText
        }
        
        //        if let country = filter.countryName {
        //            params["country"] = country
        //        }
        
        if let fromDate = filter.fromDate {
            params["from_date"] = convertDate(fromDate)
        }
        
        if let toDate = filter.toDate {
            params["to_date"] = convertDate(toDate)
        }
        
        WebService.shared.getNewTicketsService(param: params) { [weak self] response in
            guard let self = self else { return }
            
            // Update page info
            self.currentPage = response.currentPage ?? 1
            self.totalPages = response.lastPage ?? 1
            
            // Update data
            self.ticketsList = response.data ?? []
            DispatchQueue.main.async {
                self.hostVC.pageCountLabel.text = String(format: "%02d of %02d", self.currentPage, self.totalPages)
                self.hostVC.listTableView.reloadData()
                self.hostVC.noDataFoundLabel.isHidden = !self.ticketsList.isEmpty
                self.hostVC.updatePaginationButtonImages()
            }
        }
    }
    
    func fetchOngoingList() {
        
        let filter = ongoingListFilter
        var params: [String : Any] = [:]
        params["page"] = currentPage
        params["limit"] = 3
        if !searchText.isEmpty {
            params["search"] = searchText
        }
        
        //        if let country = filter.countryName {
        //            params["country1"] = country
        //        }
        
        if let fromDate = filter.fromDate {
            params["from_date"] = convertDate(fromDate)
        }
        
        if let toDate = filter.toDate {
            params["to_date"] = convertDate(toDate)
        }
        
        WebService.shared.getOngoingTicketsService(param: params) { [weak self] response in
            guard let self = self else { return }
            
            // Update page info
            self.currentPage = response.currentPage ?? 1
            self.totalPages = response.lastPage ?? 1
            
            // Update data
            self.ticketsList = response.data ?? []
            DispatchQueue.main.async {
                self.hostVC.pageCountLabel.text = String(format: "%02d of %02d", self.currentPage, self.totalPages)
                self.hostVC.listTableView.reloadData()
                self.hostVC.noDataFoundLabel.isHidden = !self.ticketsList.isEmpty
                self.hostVC.updatePaginationButtonImages()
            }
        }
    }
    
    func fetchPastList() {
        let filter = pastListFilter
        var params: [String : Any] = [:]
        params["page"] = currentPage
        params["limit"] = 3
        if !searchText.isEmpty {
            params["search"] = searchText
        }
        
        //        if let country = filter.countryName {
        //            params["country2"] = country
        //        }
        
        if let fromDate = filter.fromDate {
            params["from_date"] = convertDate(fromDate)
        }
        
        if let toDate = filter.toDate {
            params["to_date"] = convertDate(toDate)
        }
        
        WebService.shared.getPastTicketsService(param: params) { [weak self] response in
            guard let self = self else { return }
            
            // Update page info
            self.currentPage = response.currentPage ?? 1
            self.totalPages = response.lastPage ?? 1
            
            // Update data
            self.ticketsList = response.data ?? []
            DispatchQueue.main.async {
                self.hostVC.pageCountLabel.text = String(format: "%02d of %02d", self.currentPage, self.totalPages)
                self.hostVC.listTableView.reloadData()
                self.hostVC.noDataFoundLabel.isHidden = !self.ticketsList.isEmpty
                self.hostVC.updatePaginationButtonImages()
            }
        }
    }
    
    
    func goToNextPage(type: TiketListType) {
        guard currentPage < totalPages else { return }
        currentPage += 1
        switch type {
        case .newList:
            fetchNewTicketsList()
        case .ongoingList:
            fetchOngoingList()
        case .pastList:
            fetchPastList()
        }
    }
    
    func goToPreviousPage(type: TiketListType) {
        guard currentPage > 1 else { return }
        currentPage -= 1
        switch type {
        case .newList:
            fetchNewTicketsList()
        case .ongoingList:
            fetchOngoingList()
        case .pastList:
            fetchPastList()
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


enum TiketListType: Int {
    case newList = 1
    case ongoingList = 2
    case pastList = 3
}
