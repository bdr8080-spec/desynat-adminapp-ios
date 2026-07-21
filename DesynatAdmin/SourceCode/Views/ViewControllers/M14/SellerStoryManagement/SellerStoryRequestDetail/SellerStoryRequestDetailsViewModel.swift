//
//  SellerStoryRequestDetailsViewModel.swift
//  DesynatAdmin
//
//  Created by Fluper New Mac1 on 21/07/26.
//

import Foundation

class SellerStoryRequestListDetailsViewModel {
    
    private var hostVC: SellerStoryRequestDetailsViewController
    
    private(set) var currentPage : Int = 1
    private(set) var totalPage : Int = 1
    var arraySellers : [SellerStoryRequestListInfo] = []
    private(set) var refreshHandler : HandleTableRefresh?
    private(set) var sellerActionHandler : HandleSellerStoryRequestAction?
    private(set) var currentTab : SellerStoryRequestTab = .new
    private(set) var filterInfo : FilterInfo = FilterInfo()
    private var searchTimer : Timer?
    var countryListData: [GetCountryDataModel] = []
    
    func setRefreshHandler(_ handler:HandleTableRefresh,sellerActionHandler:HandleSellerStoryRequestAction) {
        self.refreshHandler = handler
        self.sellerActionHandler = sellerActionHandler
    }
    
    func setSearch(_ string:String)  {
        if (searchTimer != nil) {
            searchTimer?.invalidate()
            searchTimer = nil
        }
        self.filterInfo.searchText = string
        self.searchTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(handleSearch(_:)), userInfo: nil, repeats: false)
    }
    
    func changePage(_ isPrevious:Bool) {
        if isPrevious {
            currentPage = currentPage <= 1 ? 1 : currentPage - 1
        } else {
            currentPage = currentPage < totalPage ? currentPage + 1 : currentPage
        }
        self.getData()
    }
    
    private func resetPageCount() {
        self.currentPage = 1
        self.totalPage = 1
    }
    
    func setFilter(_ filter:FilterInfo) {
        self.filterInfo = filter
    }
    
    func setCurrentPage(_ page: Int) {
        self.currentPage = page
    }
    
    func changeTab(_ tab:SellerStoryRequestTab) {
        self.currentTab = tab
        self.resetPageCount()
        self.filterInfo = FilterInfo()
        
        self.getData()
    }
    
    var isLastPage:Bool {
        currentPage >= totalPage
    }
    var isFirstPage:Bool {
        currentPage <= 1
    }
    
    func refreshArray(for type:SellerStoryRequestTab,_ data:[SellerStoryRequestManagementData])  {
        self.arraySellers = data.map(
            { seller in
                SellerStoryRequestListInfo.makeInfo(
                    seller,
                    handler: self.sellerActionHandler,
                    status: type
                )
            })
        self.refreshHandler?.refreshTable(for: "")
    }
    
    func getData() {
        let limit = 2
        let searchText = String.getString(self.filterInfo.searchText)
        var fromDate :String = ""
        if let startDate = filterInfo.startDate {
            fromDate = CommonUtils.getDateString(from: startDate,format: "yyyy-MM-dd")
        }
        var toDate :String = ""
        if let endDate = filterInfo.endDate {
            toDate = CommonUtils.getDateString(from: endDate,format: "yyyy-MM-dd")
        }
        let country  = String.getString(filterInfo.country?.name)
        var paramter : [String:Any] = [
            APIKeys.limit:limit,
            APIKeys.page:self.currentPage,
            APIKeys.bannerType:self.currentTab.rawValue
        ]
        switch self.currentTab {
        case .new:
            if (!country.isEmpty) {
                paramter[APIKeys.countryName] = country
            }
            if (!fromDate.isEmpty) {
                paramter[APIKeys.from_date] = fromDate
            }
            if (!toDate.isEmpty) {
                paramter[APIKeys.to_date] = toDate
            }
            
            if (!searchText.isEmpty) {
                paramter[APIKeys.search] = searchText
            }
            
            WebService.shared.getNewSellerStories(parameter: paramter) { data in
                self.totalPage = data.lastPage ?? 1
                self.refreshArray(for: .new, data.data ?? [])
            }
        case .approved:
            
            if (!country.isEmpty) {
                paramter[APIKeys.countryName] = country
            }
            if (!fromDate.isEmpty) {
                paramter[APIKeys.from_date] = fromDate
            }
            if (!toDate.isEmpty) {
                paramter[APIKeys.to_date] = toDate
            }
            
            if (!searchText.isEmpty) {
                paramter[APIKeys.search] = searchText
            }
            WebService.shared.getNewSellerStories(parameter: paramter) { data in
                self.totalPage = data.lastPage ?? 1
                self.refreshArray(for: .approved, data.data ?? [])
            }
            
        case .reject:
            if (!country.isEmpty) {
                paramter[APIKeys.countryName] = country
            }
            if (!fromDate.isEmpty) {
                paramter[APIKeys.from_date] = fromDate
            }
            if (!toDate.isEmpty) {
                paramter[APIKeys.to_date] = toDate
            }
            if (!searchText.isEmpty) {
                paramter[APIKeys.search] = searchText
            }
            WebService.shared.getNewSellerStories(parameter: paramter) { data in
                self.totalPage = data.lastPage ?? 1
                self.refreshArray(for: .reject, data.data ?? [])
            }
        }
    }
    
    func acceptSellerStory(id:String,_ completion:@escaping() -> Void ) {
        WebService.shared.acceptSellerStories(id: id) { data in
            completion()
        }
    }
    
    func rejectSellerStory(id:String,reason:String,_ completion:@escaping() -> Void ) {
        let parameter :[String:Any] = [
            APIKeys.storyId:id,
            APIKeys.reject_reason:reason,
        ]
        WebService.shared.rejectSellerStories(paramter: parameter) { data in
            completion()
        }
    }
    
    func upadteBannerStatus(param: [String: Any], completion: @escaping (Bool) -> Void) {
        WebService.shared.upadteBannerRequestStatus(param: param) { response in
            completion(true)
        }
    }
    
    @objc func handleSearch(_ sender:Timer) {
        self.getData()
    }
    
    init(hostVC: SellerStoryRequestDetailsViewController) {
        self.hostVC = hostVC
    }
    
}
