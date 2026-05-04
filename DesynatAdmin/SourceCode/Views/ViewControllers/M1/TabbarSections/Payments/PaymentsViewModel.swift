//
//  PaymentsViewModel.swift
//  DesynatAdmin
//
//  Created by fluper_mac3 on 09/04/26.
//

import Foundation

class PaymentsViewModel {
    
    private var hostVC: PaymentsController
    var paymentList: [PaymentList] = []
    var currentPage: Int = 1
    var totalPages: Int = 1
    var searchText: String = ""
    var ordersFilter = PaymentFilterModel()
    var plansFilter = PaymentFilterModel()
    var giftCardsFilter = PaymentFilterModel()
    var bannersFilter = PaymentFilterModel()
    
    init(hostVC: PaymentsController) {
        self.hostVC = hostVC
    }
    
    // Helper
    func filter(for type: PaymentTab) -> PaymentFilterModel {
        switch type {
        case .orders: return ordersFilter
        case .plans: return plansFilter
        case .giftCards: return giftCardsFilter
        case .banners: return bannersFilter
        }
    }
    
    func resetFilter(for type: PaymentTab) {
        setFilter(PaymentFilterModel(), for: type)
    }
    
    func setFilter(_ filter: PaymentFilterModel, for type: PaymentTab) {
        switch type {
        case .orders: ordersFilter = filter
        case .plans: plansFilter = filter
        case .giftCards: giftCardsFilter = filter
        case .banners: bannersFilter = filter
        }
    }
    
    func fetchOrdersList() {
        let filter = ordersFilter
        var params: [String : Any] = [:]
        params["page"] = currentPage
        params["limit"] = 3
        if !searchText.isEmpty {
            params["search"] = searchText
        }
        
        if let country = filter.countryId {
            params["country_id"] = country
        }
        
        if let fromDate = filter.fromDate {
            params["from_date"] = convertDate(fromDate)
        }
        
        if let toDate = filter.toDate {
            params["to_date"] = convertDate(toDate)
        }
        
        if let status = filter.status {
            params["status"] = status
        }
        
        WebService.shared.fetchOrdersListService(param: params) { [weak self] response in
            guard let self = self else { return }
            
            // Update page info
            self.currentPage = response.orders?.currentPage ?? 1
            self.totalPages = response.orders?.lastPage ?? 1
            
            // Update data
            self.paymentList = response.orders?.data ?? []
            DispatchQueue.main.async {
                self.hostVC.totalRevenueLbl.text = CommonUtils.formatPrice(response.totalRevenue ?? 0.0)
                self.hostVC.orderCommissionLbl.text = CommonUtils.formatPrice(response.totalCommission ?? 0.0)
                self.hostVC.specialOrderLbl.text = CommonUtils.formatPrice(response.totalCustomOrderRevenue ?? 0.0)
                self.hostVC.pagecountLabel.text = String(format: "%02d of %02d", self.currentPage, self.totalPages)
                self.hostVC.paymentTableView.reloadData()
                self.hostVC.paymentTableView.layoutIfNeeded()
                self.hostVC.heightOfTableViewConstarint.constant = self.hostVC.paymentTableView.contentSize.height
                self.hostVC.noDataFoundLabel.isHidden = !self.paymentList.isEmpty
                self.hostVC.paginationBottomView.isHidden = self.paymentList.isEmpty
                self.hostVC.updatePaginationButtonImages()
            }
        }
    }
    
    func fetchPlansList() {
        let filter = plansFilter
        var params: [String : Any] = [:]
        params["page"] = currentPage
        params["limit"] = 3
        if !searchText.isEmpty {
            params["search"] = searchText
        }
        
        if let country = filter.countryId {
            params["country_id"] = country
        }
        
        if let fromDate = filter.fromDate {
            params["from_date"] = convertDate(fromDate)
        }
        
        if let toDate = filter.toDate {
            params["to_date"] = convertDate(toDate)
        }
        
        if let status = filter.status {
            params["status"] = status
        }
        
        WebService.shared.fetchPlansListService(param: params) { [weak self] response in
            guard let self = self else { return }
            
            // Update page info
            self.currentPage = response.orders?.currentPage ?? 1
            self.totalPages = response.orders?.lastPage ?? 1
            
            // Update data
            self.paymentList = response.orders?.data ?? []
            DispatchQueue.main.async {
                self.hostVC.totalRevenueLbl.text = CommonUtils.formatPrice(response.totalRevenue ?? 0.0)
                self.hostVC.pagecountLabel.text = String(format: "%02d of %02d", self.currentPage, self.totalPages)
                self.hostVC.paymentTableView.reloadData()
                self.hostVC.paymentTableView.layoutIfNeeded()
                self.hostVC.heightOfTableViewConstarint.constant = self.hostVC.paymentTableView.contentSize.height
                self.hostVC.noDataFoundLabel.isHidden = !self.paymentList.isEmpty
                self.hostVC.paginationBottomView.isHidden = self.paymentList.isEmpty
                self.hostVC.updatePaginationButtonImages()
            }
        }
    }
    
    func fetchGiftCardsList() {
        let filter = giftCardsFilter
        var params: [String : Any] = [:]
        params["page"] = currentPage
        params["limit"] = 3
        if !searchText.isEmpty {
            params["search"] = searchText
        }
        
        if let country = filter.countryId {
            params["country_id"] = country
        }
        
        if let fromDate = filter.fromDate {
            params["from_date"] = convertDate(fromDate)
        }
        
        if let toDate = filter.toDate {
            params["to_date"] = convertDate(toDate)
        }

        if let status = filter.status {
            params["status"] = status
        }
        
        WebService.shared.fetchGiftCardsListService(param: params) { [weak self] response in
            guard let self = self else { return }
            
            // Update page info
            self.currentPage = response.orders?.currentPage ?? 1
            self.totalPages = response.orders?.lastPage ?? 1
            
            // Update data
            self.paymentList = response.orders?.data ?? []
            DispatchQueue.main.async {
                self.hostVC.totalRevenueLbl.text = CommonUtils.formatPrice(response.totalRevenue ?? 0.0)
                self.hostVC.pagecountLabel.text = String(format: "%02d of %02d", self.currentPage, self.totalPages)
                self.hostVC.paymentTableView.reloadData()
                self.hostVC.paymentTableView.layoutIfNeeded()
                self.hostVC.heightOfTableViewConstarint.constant = self.hostVC.paymentTableView.contentSize.height
                self.hostVC.noDataFoundLabel.isHidden = !self.paymentList.isEmpty
                self.hostVC.paginationBottomView.isHidden = self.paymentList.isEmpty
                self.hostVC.updatePaginationButtonImages()
            }
        }
    }
    
    func fetchBannersList() {
        let filter = bannersFilter
        var params: [String : Any] = [:]
        params["page"] = currentPage
        params["limit"] = 3
        if !searchText.isEmpty {
            params["search"] = searchText
        }
        
        if let country = filter.countryId {
            params["country_id"] = country
        }
        
        if let fromDate = filter.fromDate {
            params["from_date"] = convertDate(fromDate)
        }
        
        if let toDate = filter.toDate {
            params["to_date"] = convertDate(toDate)
        }
//        if let fromDate = filter.fromDate {
//            params["from_date"] = fromDate
//        }
//
//        if let toDate = filter.toDate {
//            params["to_date"] = toDate
//        }
        
        if let status = filter.status {
            params["status"] = status
        }
        
        WebService.shared.fetchBannersListService(param: params) { [weak self] response in
            guard let self = self else { return }
            
            // Update page info
            self.currentPage = response.orders?.currentPage ?? 1
            self.totalPages = response.orders?.lastPage ?? 1
            
            // Update data
            self.paymentList = response.orders?.data ?? []
            DispatchQueue.main.async {
                self.hostVC.totalRevenueLbl.text = CommonUtils.formatPrice(response.totalRevenue ?? 0.0)
                self.hostVC.pagecountLabel.text = String(format: "%02d of %02d", self.currentPage, self.totalPages)
                self.hostVC.paymentTableView.reloadData()
                self.hostVC.paymentTableView.layoutIfNeeded()
                self.hostVC.heightOfTableViewConstarint.constant = self.hostVC.paymentTableView.contentSize.height
                self.hostVC.noDataFoundLabel.isHidden = !self.paymentList.isEmpty
                self.hostVC.paginationBottomView.isHidden = self.paymentList.isEmpty
                self.hostVC.updatePaginationButtonImages()
            }
        }
    }
    
    
    func goToNextPage(type: PaymentTab) {
        guard currentPage < totalPages else { return }
        currentPage += 1
        switch type {
        case .orders:
            fetchOrdersList()
        case .plans:
            fetchPlansList()
        case .giftCards:
            fetchGiftCardsList()
        case .banners:
            fetchBannersList()
        }
    }
    
    func goToPreviousPage(type: PaymentTab) {
        guard currentPage > 1 else { return }
        currentPage -= 1
        switch type {
        case .orders:
            fetchOrdersList()
        case .plans:
            fetchPlansList()
        case .giftCards:
            fetchGiftCardsList()
        case .banners:
            fetchBannersList()
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

