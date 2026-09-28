//
//  SellerPayoutListViewModel.swift
//  DesynatAdmin
//
//  Created by fluper_mac3 on 19/03/26.
//

import Foundation

class SellerPayoutListViewModel {
    
    var hostVC: SellerPayoutListViewController
    var searchText: String = ""
    var sellerPayoutList: [SellerPayoutListDataList] = []
    var currentPage: Int = 1
    var isLoading = false
    var hasMoreData = true
    let limit = 10
    var appliedFilter = SellerPayoutFilterModel()
    
    init(hostVC: SellerPayoutListViewController) {
        self.hostVC = hostVC
    }
    
    func getSellerPayoutList() {
        guard !isLoading else { return }
        guard hasMoreData else { return}
        isLoading = true
        let filter = appliedFilter
        var params: [String: Any] = [:]
        params["page"] = currentPage
        params["limit"] = limit
        if !searchText.isEmpty {
            params["search"] = searchText
        }
        if let fromDate = filter.fromDate,
           !fromDate.isEmpty {
            params["from_date"] = fromDate
        }
        if let toDate = filter.toDate,
           !toDate.isEmpty {
            params["to_date"] = toDate
        }
        if let status = filter.statusId {
            params["req_type"] = status
        }
        if let countryId = filter.countryId {
            params["countryId"] = countryId
        }
        WebService.sharedInstance.getSellerPayoutsRequests(param: params) { [weak self] data in
            guard let self = self else { return }
            let newData = data.data ?? []
            if self.currentPage == 1 {
                self.sellerPayoutList = newData
            } else {
                self.sellerPayoutList.append(contentsOf: newData)
            }
            self.hasMoreData = newData.count == self.limit
            if self.hasMoreData {
                self.currentPage += 1
            }
            self.isLoading = false
            DispatchQueue.main.async {
                self.hostVC.listTableView.reloadData()
                self.hostVC.lblNoData.isHidden = !self.sellerPayoutList.isEmpty
            }
        }
    }
    
    func resetPagination() {
        currentPage = 1
        hasMoreData = true
        isLoading = false
        sellerPayoutList.removeAll()
    }
    
    func convertDateFormat(
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
    
}

struct SellerPayoutFilterModel {
    var fromDate: String?
    var toDate: String?
    var statusId: Int?
    var countryId: Int?
    var countryName: String?
}
