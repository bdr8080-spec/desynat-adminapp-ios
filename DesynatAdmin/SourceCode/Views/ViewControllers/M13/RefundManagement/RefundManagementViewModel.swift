//
//  RefundManagementViewModel.swift
//  DesynatAdmin
//
//  Created by fluper_mac3 on 16/04/26.
//

import Foundation

class RefundManagementViewModel {
    
    private var hostVC: RefundManagementViewController
    var refundListData: [RefundMangementList] = []
    var currentPage: Int = 1
    var totalPages: Int = 1
    var searchText: String = ""
    var appliedFilter = PaymentFilterModel()
    
    init(hostVC: RefundManagementViewController) {
        self.hostVC = hostVC
    }
    
    func getAllRefundRequest() {
      var params: [String : Any] = [:]
      
      params["page"] = currentPage
      params["limit"] = 3
      
      // Search
      if !searchText.isEmpty {
        params["search"] = searchText
      }
        
        if let countryName = appliedFilter.countryName {
            params["country_name"] = countryName
        }
      
      // From Date
      if let fromDate = appliedFilter.fromDate {
        params["from_date"] = convertDate(fromDate)
      }
      
      // To Date
      if let toDate = appliedFilter.toDate {
        params["to_date"] = convertDate(toDate)
      }
      
      // API CALL
      WebService.shared.getAllRefundDataService(param: params) { [weak self] response in
        guard let self = self else { return }
        
        self.currentPage = response.currentPage ?? 1
        self.totalPages = response.lastPage ?? 1
        
        self.refundListData = response.data ?? []
        
        DispatchQueue.main.async {
          self.hostVC.pageCountLabel.text = String(format: "%02d of %02d", self.currentPage, self.totalPages)
          self.hostVC.refundTableView.reloadData()
          self.hostVC.noDataFoundLabel.isHidden = !self.refundListData.isEmpty
          self.hostVC.updatePaginationButtonImages()
        }
      }
    }
    
    func goToNextPage() {
      guard currentPage < totalPages else { return }
      currentPage += 1
        getAllRefundRequest()
    }
    
    func goToPreviousPage() {
      guard currentPage > 1 else { return }
      currentPage -= 1
        getAllRefundRequest()
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
