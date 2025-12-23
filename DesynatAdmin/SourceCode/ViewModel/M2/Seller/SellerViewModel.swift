//
//  SellerViewModel.swift
//  DesynatAdmin
//
//  Created by Meet Goti on 07/11/25.
//

import Foundation

struct SellerListInfo    {
    var id: String = UUID().uuidString
    var name:String
    var image:String = ""
    var country:String
    var joinedOn:String
    var mobileNumber:String
    var totalOrders:String = "0"
    var totalEarning:String = "KD 0"
    var reason:String = ""
    var email:String
    var status:SellersTab = .none
    var handler:HandleSellerAction?
    
    func accceptSeller() {
        self.handler?.aprovedSeller(self)
    }
    
    func rejectSeller() {
        self.handler?.rejectSeller(self)
    }
    
    static func makeInfo(_ data:SellerDataModel,handler:HandleSellerAction?,status:SellersTab) -> Self {
        SellerListInfo(
            id:String.getString(data.id),
            name: "\(String.getString(data.firstName)) \(String.getString(data.lastName))",
            image: String.getString(data.profilePic),
            country: String.getString(data.storeInfo?.countryInfo?.name),
            joinedOn: CommonUtils.getDateString(from: Date(iso8601String: String.getString(data.createdAt)),format: "dd/MM/yyyy"),
            mobileNumber: "\(String.getString(data.countryCode))-\(String.getString(data.mobile))",
            totalOrders: "0",
            totalEarning: "KD 0",
            reason: String.getString(data.rejectReason),
            email: String.getString(data.email),
            status: status,
            handler: handler
        )
    }
}

protocol HandleTableRefresh {
    func refreshTable(for string:String)
}

protocol HandleSellerAction {
    func aprovedSeller(_ data:SellerListInfo)
    func rejectSeller(_ data:SellerListInfo)
}

protocol HandleCityAction {
    func viewZone(_ data:CitiesInfo)
    func deleteCity(_ data:CitiesInfo)
    func setActiveCity(_ data:CitiesInfo)
}
protocol HandleZoneAction {
    func viewLocation(_ data:ZoneInfo)
    func deleteZone(_ data:ZoneInfo)
    func editZone(_ data:ZoneInfo)
    func setActiveZone(_ data:ZoneInfo)
}

enum SellersTab:Int {
case none = 0, new,approved,reject
    var title:String {
        switch self {
        case .none:
            ""
        case .new:
            "Pending"
        case .approved:
            "Approved"
        case .reject:
            "Rejected"
        }
    }
    var placeHolder:String {
        switch self {
        case .none:
            ""
        case .new:
            "No New Request Found"
        case .approved:
            "No Result Found"
        case .reject:
            "No Result Found"
        }
    }
}
struct FilterInfo {
    var searchText:String = ""
    var country:GetCountryDataModel?
    var startDate:Date?
    var endDate:Date?
}
class SellerViewModel {
    private(set) var currentPage : Int = 1
    private(set) var totalPage : Int = 1
    private(set) var arraySellers : [SellerListInfo] = []
    private(set) var refreshHandler : HandleTableRefresh?
    private(set) var sellerActionHandler : HandleSellerAction?
    private(set) var currentTab : SellersTab = .new
    private(set) var filterInfo : FilterInfo = FilterInfo()
    private var searchTimer : Timer?
    var countryListData: [GetCountryDataModel] = []
    init() {
        self.getAllCountry {
        }
    }
    
    func setRefreshHandler(_ handler:HandleTableRefresh,sellerActionHandler:HandleSellerAction) {
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
    
    func changeTab(_ tab:SellersTab) {
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
    
    func refreshArray(for type:SellersTab,_ data:[SellerDataModel])  {
        self.arraySellers = data.map(
            { seller in
                SellerListInfo.makeInfo(
                    seller,
                    handler: self.sellerActionHandler,
                    status: type
                )
            })
        self.refreshHandler?.refreshTable(for: "")
    }
    
    func getData() {
        let limit = 5
        let searchText = String.getString(self.filterInfo.searchText)
        var fromDate :String = ""
        if let startDate = filterInfo.startDate {
            fromDate = CommonUtils.getDateString(from: startDate,format: "yyyy-MM-dd")
        }
        var toDate :String = ""
        if let endDate = filterInfo.endDate {
            toDate = CommonUtils.getDateString(from: endDate,format: "yyyy-MM-dd")
        }
        let country  = Int.getInt(filterInfo.country?.id)
        var paramter : [String:Any] = [
            APIKeys.limit:limit,
            APIKeys.page:self.currentPage,
        ]
        switch self.currentTab {
        case .none:
            self.arraySellers = []
        case .new:
            if (country > 0) {
                paramter[APIKeys.country_id] = country
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
            
            WebService.shared.getNewSellers(parameter: paramter) { data in
                self.totalPage = data.lastPage ?? 1
                self.refreshArray(for: .new, data.data ?? [])
            }
//            self.arraySellers = [
//                SellerListInfo(
//                    name: "Alisha Khan",
//                    country: "Alisha Khan",
//                    joinedOn: "21/02/2025 ",
//                    mobileNumber: "+965- 28392018391",
//                    email: "alisha.khan@gmail.com",
//                    status: .new,
//                    handler: self.sellerActionHandler
//                ),
//                SellerListInfo(
//                    name: "Alisha Khan",
//                    country: "Alisha Khan",
//                    joinedOn: "21/02/2025 ",
//                    mobileNumber: "+965- 28392018391",
//                    email: "alisha.khan@gmail.com",
//                    status: .new,
//                    handler: self.sellerActionHandler
//                ),
//                SellerListInfo(
//                    name: "Alisha Khan",
//                    country: "Alisha Khan",
//                    joinedOn: "21/02/2025 ",
//                    mobileNumber: "+965- 28392018391",
//                    email: "alisha.khan@gmail.com",
//                    status: .new,
//                    handler: self.sellerActionHandler
//                ),
//                SellerListInfo(
//                    name: "Alisha Khan",
//                    country: "Alisha Khan",
//                    joinedOn: "21/02/2025 ",
//                    mobileNumber: "+965- 28392018391",
//                    email: "alisha.khan@gmail.com",
//                    status: .new,
//                    handler: self.sellerActionHandler
//                ),
//                SellerListInfo(
//                    name: "Alisha Khan",
//                    country: "Alisha Khan",
//                    joinedOn: "21/02/2025 ",
//                    mobileNumber: "+965- 28392018391",
//                    email: "alisha.khan@gmail.com",
//                    status: .new,
//                    handler: self.sellerActionHandler
//                ),
//            ]
        case .approved:
            
            if (country > 0) {
                paramter[APIKeys.country_id1] = country
            }
            if (!fromDate.isEmpty) {
                paramter[APIKeys.from_date1] = fromDate
            }
            if (!toDate.isEmpty) {
                paramter[APIKeys.to_date1] = toDate
            }
            
            if (!searchText.isEmpty) {
                paramter[APIKeys.search] = searchText
            }
            WebService.shared.getApprovedSellers(parameter: paramter) { data in
                self.totalPage = data.lastPage ?? 1
                self.refreshArray(for: .approved, data.data ?? [])
            }
//            self.arraySellers = [
//                SellerListInfo(
//                    name: "Alisha Khan",
//                    country: "Alisha Khan",
//                    joinedOn: "21/02/2025 ",
//                    mobileNumber: "+965- 28392018391",
//                    totalOrders: "30",
//                    totalEarning: "KD 1230",
//                    email: "alisha.khan@gmail.com",
//                    status: .approved,
//                    handler: self.sellerActionHandler
//                ),
//                SellerListInfo(
//                    name: "Alisha Khan",
//                    country: "Alisha Khan",
//                    joinedOn: "21/02/2025 ",
//                    mobileNumber: "+965- 28392018391",
//                    totalOrders: "30",
//                    totalEarning: "KD 1230",
//                    email: "alisha.khan@gmail.com",
//                    status: .approved,
//                    handler: self.sellerActionHandler
//                ),
//                SellerListInfo(
//                    name: "Alisha Khan",
//                    country: "Alisha Khan",
//                    joinedOn: "21/02/2025 ",
//                    mobileNumber: "+965- 28392018391",
//                    totalOrders: "30",
//                    totalEarning: "KD 1230",
//                    email: "alisha.khan@gmail.com",
//                    status: .approved,
//                    handler: self.sellerActionHandler
//                ),
//                SellerListInfo(
//                    name: "Alisha Khan",
//                    country: "Alisha Khan",
//                    joinedOn: "21/02/2025 ",
//                    mobileNumber: "+965- 28392018391",
//                    totalOrders: "30",
//                    totalEarning: "KD 1230",
//                    email: "alisha.khan@gmail.com",
//                    status: .approved,
//                    handler: self.sellerActionHandler
//                ),
//                SellerListInfo(
//                    name: "Alisha Khan",
//                    country: "Alisha Khan",
//                    joinedOn: "21/02/2025 ",
//                    mobileNumber: "+965- 28392018391",
//                    totalOrders: "30",
//                    totalEarning: "KD 1230",
//                    email: "alisha.khan@gmail.com",
//                    status: .approved,
//                    handler: self.sellerActionHandler
//                ),
//            ]
        case .reject:
            if (country > 0) {
                paramter[APIKeys.country_id2] = country
            }
            if (!fromDate.isEmpty) {
                paramter[APIKeys.from_date2] = fromDate
            }
            if (!toDate.isEmpty) {
                paramter[APIKeys.to_date2] = toDate
            }
//            
            if (!searchText.isEmpty) {
                paramter[APIKeys.search] = searchText
            }
            WebService.shared.getRejectSellers(parameter: paramter) { data in
                self.totalPage = data.lastPage ?? 1
                self.refreshArray(for: .reject, data.data ?? [])
            }
//            self.arraySellers = [
//                SellerListInfo(
//                    name: "Alisha Khan",
//                    country: "Alisha Khan",
//                    joinedOn: "21/02/2025 ",
//                    mobileNumber: "+965- 28392018391",
//                    reason: "lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor elit.",
//                    email: "alisha.khan@gmail.com",
//                    status: .reject,
//                    handler: self.sellerActionHandler
//                ),
//                SellerListInfo(
//                    name: "Alisha Khan",
//                    country: "Alisha Khan",
//                    joinedOn: "21/02/2025 ",
//                    mobileNumber: "+965- 28392018391",
//                    reason: "lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor elit.",
//                    email: "alisha.khan@gmail.com",
//                    status: .reject,
//                    handler: self.sellerActionHandler
//                ),
//                SellerListInfo(
//                    name: "Alisha Khan",
//                    country: "Alisha Khan",
//                    joinedOn: "21/02/2025 ",
//                    mobileNumber: "+965- 28392018391",
//                    reason: "lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor elit.",
//                    email: "alisha.khan@gmail.com",
//                    status: .reject,
//                    handler: self.sellerActionHandler
//                ),
//                SellerListInfo(
//                    name: "Alisha Khan",
//                    country: "Alisha Khan",
//                    joinedOn: "21/02/2025 ",
//                    mobileNumber: "+965- 28392018391",
//                    reason: "lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor elit.",
//                    email: "alisha.khan@gmail.com",
//                    status: .reject,
//                    handler: self.sellerActionHandler
//                ),
//                SellerListInfo(
//                    name: "Alisha Khan",
//                    country: "Alisha Khan",
//                    joinedOn: "21/02/2025 ",
//                    mobileNumber: "+965- 28392018391",
//                    reason: "lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor elit.",
//                    email: "alisha.khan@gmail.com",
//                    status: .reject,
//                    handler: self.sellerActionHandler
//                ),
//            ]
        }
        
    }
    
    func getAllCountry(_ completion:@escaping(() -> Void) ) {
        WebService.shared.getAllCountry(){ [weak self] response in
            guard let self = self else { return }
            countryListData = response
            completion()
        }
    }
    func approveSeller(id:String,_ completion:@escaping() -> Void ) {
        WebService.shared.approveSellers(id: id) { data in
            completion()
        }
    }
    func rejectSeller(id:String,reason:String,type:SellerRejectionType,_ completion:@escaping() -> Void ) {
        let parameter :[String:Any] = [
            APIKeys.seller_id:id,
            APIKeys.reject_reason:reason,
            APIKeys.reject_type:type.paramterValue,
        ]
        WebService.shared.rejectSellers(paramter: parameter) { data in
            completion()
        }
    }
}
