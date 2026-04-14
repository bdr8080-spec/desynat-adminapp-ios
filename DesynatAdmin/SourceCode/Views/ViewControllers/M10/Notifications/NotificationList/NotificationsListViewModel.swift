//
//  NotificationsListViewModel.swift
//  DesynatAdmin
//
//  Created by fluper_mac3 on 17/03/26.
//

import Foundation

class NotificationsListViewModel {
    
    private var hostVC: NotificationsListViewController
    var notificationSentList: [NotificationsList] = []
    var currentPage: Int = 1
    var totalPages: Int = 1
    var searchText: String = ""
    var appliedFilter = UserFilterModel()
    
    init(hostVC: NotificationsListViewController) {
        self.hostVC = hostVC
    }
    
    func getAllSentNotificationRequest() {
        var params: [String : Any] = [:]
        params["page"] = currentPage
        params["limit"] = 5
        if !searchText.isEmpty {
            params["search"] = searchText
        }
        
        // Country filter
        if let id = appliedFilter.countryId {
            params["country_id"] = id
        }

        // From Date
        if let fromDate = appliedFilter.fromDate {
            params["from_date"] = convertDate(fromDate)
        }

        // To Date
        if let toDate = appliedFilter.toDate {
            params["to_date"] = convertDate(toDate)
        }
    
        WebService.shared.getSentNotificationsListService(parameter: params) { [weak self] response in
            guard let self = self else { return }
            
            // Update page info
            self.currentPage = response.currentPage ?? 1
            self.totalPages = response.lastPage ?? 1
            
            // Update data
            self.notificationSentList = response.data ?? []
            
            DispatchQueue.main.async {
                self.hostVC.pageCountLabel.text = String(format: "%02d of %02d", self.currentPage, self.totalPages)
                self.hostVC.listTableView.reloadData()
                self.hostVC.noDataFoundLabel.isHidden = !self.notificationSentList.isEmpty
                self.hostVC.updatePaginationButtonImages()
            }
        }
    }
    
    func goToNextPage() {
        guard currentPage < totalPages else { return }
        currentPage += 1
        getAllSentNotificationRequest()
    }
    
    func goToPreviousPage() {
        guard currentPage > 1 else { return }
        currentPage -= 1
        getAllSentNotificationRequest()
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
