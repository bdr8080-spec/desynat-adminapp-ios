//
//  SellerStoryRequestListViewModel.swift
//  DesynatAdmin
//
//  Created by fluper_mac2 on 14/07/26.
//

import Foundation

struct SellerStoryRequestListInfo {
    
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
    var bannerBlockStatus:String = ""
    var status:SellerStoryRequestTab = .new
    var handler:HandleSellerStoryRequestAction?
    
    func accceptBanner() {
        self.handler?.aprovedBanner(self)
    }
    
    func rejectBanner() {
        self.handler?.rejectBanner(self)
    }
    
    static func makeInfo(_ data:SellerStoryRequestManagementData,handler:HandleSellerStoryRequestAction?,status:SellerStoryRequestTab) -> Self {
//        SellerStoryRequestListInfo(
//            id:String.getString(data.id), orderID: String.getString(data.data.orderID),
//            name: "\(String.getString(data.sellerDetails?.firstName)) \(String.getString(data.sellerDetails?.lastName))",
//            image: String.getString(data.uploadBanner),
//            country: (AppLanguageManager.shared.currentLanguage == .ar ? data.sellerDetails?.countryDetails?.nameAr ?? "الكويت" : data.sellerDetails?.countryDetails?.name) ?? "Kuwait",
//            joinedOn: CommonUtils.getDateStrings(
//                from: Date(iso8601String: String.getString(data.createdAt)),
//                format: "dd/MM/yyyy 'at' hh:mm a"
//            ),
//            totalDays:String.getString(data.totalDays),
//            totalOrders: "0",
//            totalEarning: String.getString(data.price),
//            reason: String.getString(data.cancelledReason),
//            email: String.getString(data.sellerDetails?.email),
//            bannerPosition: String.getString(data.bannerPosition),
//            paymentStatus: String.getString(data.paymentStatus),
//            from: String.getString(data.startDate),
//            to: String.getString(data.endDate),
//            transactionID: String.getString(data.transactionID),
//            subcategory: String.getString(data.subcategoryDetails?.nameEnglish),
//            bannerBlockStatus: String.getString(data.status),
//            status: status,
//            handler: handler
//        )
        SellerStoryRequestListInfo(
            id: String.getString(data.id),
            orderID: String.getString(data.transactionID),

            name: "\(String.getString(data.sellerDetails?.firstName)) \(String.getString(data.sellerDetails?.lastName))",

            image: String.getString(data.file),

            country: (AppLanguageManager.shared.currentLanguage == .ar
                        ? data.sellerDetails?.storeInfo?.countryInfo?.nameAr
                        : data.sellerDetails?.storeInfo?.countryInfo?.name) ?? "Kuwait",

            joinedOn: CommonUtils.getDateStrings(
                from: Date(iso8601String: String.getString(data.createdAt)),
                format: "dd/MM/yyyy 'at' hh:mm a"
            ),

            totalDays: String.getString(data.totalDays),
            totalOrders: "0",
            totalEarning: String.getString(data.amount),
            reason: String.getString(data.rejectReason),
            email: String.getString(data.sellerDetails?.email),

            bannerPosition: "",
            paymentStatus: String.getString(data.paymentStatus),
            from: String.getString(data.startDate),
            to: String.getString(data.endDate),
            transactionID: String.getString(data.transactionID),
            subcategory: "",
            bannerBlockStatus: String.getString(data.status),
            status: status,
            handler: handler
        )
    }
}

protocol HandleSellerStoryRequestAction {
    func aprovedBanner(_ data:SellerStoryRequestListInfo)
    func rejectBanner(_ data:SellerStoryRequestListInfo)
}

enum SellerStoryRequestTab:Int {
    case new,approved,reject
    var title:String {
        switch self {
        case .new:
            "New".localiz()
        case .approved:
            "Approved".localiz()
        case .reject:
            "Rejected".localiz()
        }
    }
    var placeHolder:String {
        switch self {
        case .new:
            "No seller story Request Found!".localiz()
        case .approved:
            "No Result Found".localiz()
        case .reject:
            "No Result Found".localiz()
        }
    }
}

class SellerStoryRequestListViewModel {
    
    private var hostVC: SellerStoryRequestListViewController
    
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
    
    init(hostVC: SellerStoryRequestListViewController) {
        self.hostVC = hostVC
    }
    
}
