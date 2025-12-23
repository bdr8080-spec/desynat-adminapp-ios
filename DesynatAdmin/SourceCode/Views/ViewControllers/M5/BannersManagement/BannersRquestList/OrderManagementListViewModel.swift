//
//  OrderManagementListViewModel.swift
//  DesynatAdmin
//
//  Created by Chandra Prakash on 22/12/25.
//

import Foundation

enum OrderCategory {
    case active
    case returnExchange
    case completed
    case cancelled
}

enum FilterContext {
    case banners
    case orders(OrderCategory)
}


class OrderManagementListViewModel {

    // MARK: - Pagination
    private(set) var currentPage: Int = 1
    private(set) var totalPage: Int = 1

    // MARK: - Data
    private(set) var orders: [OrderData] = []
    private(set) var refresHandler : HandleTableRefresh?
    var orderDetail : OrderData?
    var driverList: [DeliveryBoyListModel] = []
    

    // MARK: - State
    var currentCategory: OrderCategory = .active
    private var searchTimer: Timer?
    
    func setDriver(_ driver:DeliveryBoyListModel) {
        self.refresHandler?.refreshTable(for: "")
    }
    
    private var categoryFilters: [OrderCategory: FilterInfo] = [:]
    var filterInfo: FilterInfo {
           get {
               categoryFilters[currentCategory] ?? FilterInfo()
           }
           set {
               categoryFilters[currentCategory] = newValue
           }
       }

    // MARK: - Bindings
    var onDataUpdate: (() -> Void)?
    var onNoData: ((Bool) -> Void)?

    // MARK: - Helpers
    var isLastPage: Bool { currentPage >= totalPage }
    var isFirstPage: Bool { currentPage <= 1 }

    // MARK: - Category Change
    func setCategory(_ category: OrderCategory) {
        currentCategory = category
        currentPage = 1
        totalPage = 1
        getData()
    }

    // MARK: - Search
    func setSearch(_ string: String) {
        searchTimer?.invalidate()
        filterInfo.searchText = string
        currentPage = 1

        searchTimer = Timer.scheduledTimer(
            timeInterval: 0.5,
            target: self,
            selector: #selector(handleSearch),
            userInfo: nil,
            repeats: false
        )
    }

    @objc private func handleSearch() {
        getData()
    }

    // MARK: - Pagination
    func changePage(_ isPrevious: Bool) {
        if isPrevious {
            currentPage = max(1, currentPage - 1)
        } else {
            currentPage = min(totalPage, currentPage + 1)
        }
        getData()
    }
    
    func setFilter(_ filter:FilterInfo) {
        self.filterInfo = filter
    }

    // MARK: - API Call
    func getData() {

        let limit = 3
        let searchText = filterInfo.searchText
        let country = filterInfo.country?.name ?? ""

        var params: [String: Any] = [
            APIKeys.limit: limit,
            APIKeys.page: currentPage
        ]

        if !searchText.isEmpty {
            params[APIKeys.search] = searchText
        }
        if !country.isEmpty {
            params[APIKeys.countryName] = country
        }

        let completion: (OrderListModel) -> Void = { data in
            self.totalPage = data.lastPage ?? 1
            self.orders = data.data ?? []
            self.onNoData?(self.orders.isEmpty)
            self.onDataUpdate?()
        }

        switch currentCategory {
        case .active:
            WebService.shared.getActiveOrders(parameter: params, completion: completion)

        case .returnExchange:
            WebService.shared.getReturnOrders(parameter: params, completion: completion)

        case .completed:
            WebService.shared.getCompletedOrders(parameter: params, completion: completion)

        case .cancelled:
            WebService.shared.getCancelledOrders(parameter: params, completion: completion)
        }
    }
    
    func getOrderDetail(orderId: Int, _ completion:@escaping() -> Void) {
        let param: [String: Any] = ["id": orderId]
        WebService.shared.getOrderDetail(parameter: param) { [weak self] data in
            self?.orderDetail = data
            completion()
        }
    }
    
    func getAssignDrivers(orderId: Int,_ completion:@escaping(() -> Void) ) {
        let param: [String: Any] = ["order_id": orderId]
        WebService.shared.getDeliveryBoy(parameter: param){ [weak self] response in
            guard let self = self else { return }
            driverList = response
            refresHandler?.refreshTable(for: "")
            completion()
        }
    }
    
    func assignDriver(orderId: Int, driverId: Int,_ completion:@escaping(() -> Void)) {
        let param: [String: Any] = ["order_id": orderId, "driver_id": driverId]
        WebService.shared.assignDriver(parameter: param){ [weak self] response in
            guard let self = self else { return }
            completion()
        }
    }
}

