//
//  BannersManagementListViewModel.swift
//  DesynatAdmin
//
//  Created by fluper on 16/12/25.
//

import Foundation

struct BannerListInfo    {
    var id: String = UUID().uuidString
    var orderID:String = ""
    var name:String = ""
    var image:String = ""
    var country:String = ""
    var joinedOn:String = ""
    var totalDays:String = ""
    var totalOrders:String = "0"
    var totalEarning:String = "KD 0"
    var reason:String = ""
    var email:String = ""
    var bannerPosition:String = ""
    var paymentStatus:String = ""
    var from:String = ""
    var to:String = ""
    var transactionID:String = ""
    var subcategory:String = ""
    var status:BannersTab = .new
    var handler:HandleBannerAction?
    
    func accceptBanner() {
        self.handler?.aprovedBanner(self)
    }
    
    func rejectBanner() {
        self.handler?.rejectBanner(self)
    }
    
    static func makeInfo(_ data:BannerRequestData,handler:HandleBannerAction?,status:BannersTab) -> Self {
        BannerListInfo(
            id:String.getString(data.id), orderID: String.getString(data.orderID),
            name: "\(String.getString(data.sellerDetails?.firstName)) \(String.getString(data.sellerDetails?.lastName))",
            image: String.getString(data.uploadBanner),
            country: data.sellerDetails?.countryDetails?.name ?? "",
            joinedOn: CommonUtils.getDateStrings(
                from: Date(iso8601String: String.getString(data.createdAt)),
                format: "dd/MM/yyyy 'at' hh:mm a"
            ),
            totalDays:String.getString(data.totalDays),
            totalOrders: "0",
            totalEarning: String.getString(data.price),
            reason: String.getString(data.sellerDetails?.rejectReason),
            email: String.getString(data.sellerDetails?.email),
            bannerPosition: String.getString(data.bannerPosition),
            paymentStatus: String.getString(data.paymentStatus),
            from: String.getString(data.startDate),
            to: String.getString(data.endDate),
            transactionID: String.getString(data.transactionID),
            subcategory: String.getString(data.subcategoryDetails?.nameEnglish),
            status: status,
            handler: handler
        )
    }
}

protocol HandleBannerAction {
    func aprovedBanner(_ data:BannerListInfo)
    func rejectBanner(_ data:BannerListInfo)
}

enum BannersTab:Int {
case new,approved,reject
    var title:String {
        switch self {
        case .new:
            "New"
        case .approved:
            "Approved"
        case .reject:
            "Rejected"
        }
    }
    var placeHolder:String {
        switch self {
        case .new:
            "No banner Request Found!"
        case .approved:
            "No Result Found"
        case .reject:
            "No Result Found"
        }
    }
}

class BannersManagementListViewModel {
    private(set) var currentPage : Int = 1
    private(set) var totalPage : Int = 1
    private(set) var arraySellers : [BannerListInfo] = []
    private(set) var refreshHandler : HandleTableRefresh?
    private(set) var sellerActionHandler : HandleBannerAction?
    private(set) var currentTab : BannersTab = .new
    private(set) var filterInfo : FilterInfo = FilterInfo()
    private var searchTimer : Timer?
    var countryListData: [GetCountryDataModel] = []
    
    func setRefreshHandler(_ handler:HandleTableRefresh,sellerActionHandler:HandleBannerAction) {
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
    
    
    @objc func handleSearch(_ sender:Timer) {
        self.getData()
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
    
    func changeTab(_ tab:BannersTab) {
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
    
    func refreshArray(for type:BannersTab,_ data:[BannerRequestData])  {
        self.arraySellers = data.map(
            { seller in
                BannerListInfo.makeInfo(
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
            
            WebService.shared.getNewBanners(parameter: paramter) { data in
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
            WebService.shared.getNewBanners(parameter: paramter) { data in
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
            WebService.shared.getNewBanners(parameter: paramter) { data in
                self.totalPage = data.lastPage ?? 1
                self.refreshArray(for: .reject, data.data ?? [])
            }
        }
    }
    
    func acceptBanner(id:String,_ completion:@escaping() -> Void ) {
        WebService.shared.acceptBanners(id: id) { data in
            completion()
        }
    }
    func rejectBanner(id:String,reason:String,_ completion:@escaping() -> Void ) {
        let parameter :[String:Any] = [
            APIKeys.bannerId:id,
            APIKeys.reject_reason:reason,
        ]
        WebService.shared.rejectBanners(paramter: parameter) { data in
            completion()
        }
    }
}

