//
//  CountryCityViewModel.swift
//  DesynatAdmin
//
//  Created by Meet Goti on 11/11/25.
//

import Foundation
import CoreLocation

struct CitiesInfo {
    var id:String = UUID().uuidString
    var name:String = ""
    var countryId:String = ""
    var countryName:String = ""
    var isActive:Bool = false
    var handler:HandleCityAction?
    static func makeData(_ data:CitiesDataModel,handler:HandleCityAction?) -> Self {
        CitiesInfo(
            id: String.getString(data.id),
            name: String.getString(data.name),
            countryId: String.getString(data.countryId),
            isActive:data.status == 1,
            handler:handler
        )
    }
    func delete() {
        self.handler?.deleteCity(self)
    }
    
    func setActive() {
        self.handler?.setActiveCity(self)
    }
    
    func view() {
        self.handler?.viewZone(self)
    }
    
}

struct ZoneInfo {
    var id:String = UUID().uuidString
    var parentCityId:String = ""
    var countryId:String = ""
    var nameEn:String = ""
    var nameAr:String = ""
    var coordinates:[CLLocationCoordinate2D] = []
    var isActive:Bool = false
    var handler:HandleZoneAction?
    var paramter:[String:Any] {
        return [
            APIKeys.country_id:Int.getInt(self.countryId),
            APIKeys.city_id:Int.getInt(self.parentCityId),
            APIKeys.name_english:self.nameEn,
            APIKeys.name_arabic:self.nameAr,
            APIKeys.coordinates:self.coordinates.map({[APIKeys.lat:$0.latitude,APIKeys.lng:$0.longitude]}),
        ]
    }
    func validate() -> AlertConstant {
        if (coordinates.count < 3) {
            return .provideZoneBoundary
        } else if (nameEn.isEmpty) {
            return .enterEnglishName
        } else if (nameAr.isEmpty) {
            return .enterArabicName
        }
        return .none
    }
    func edit() {
        self.handler?.editZone(self)
    }
    func delete() {
        self.handler?.deleteZone(self)
    }
    func view() {
        self.handler?.viewLocation(self)
    }
    func setActive() {
        self.handler?.setActiveZone(self)
    }
    static func makeData(_ data:ZoneDataModel,handler:HandleZoneAction?) -> Self {
        ZoneInfo(
            id: String.getString(data.id),
            parentCityId: String.getString(data.cityId),
            countryId: String.getString(data.countryId),
            nameEn: String.getString(data.nameEnglish),
            nameAr: String.getString(data.nameArabic),
            coordinates: (data.coordinates ?? []).map({$0.coordinates}),
            isActive: data.status == 1,
            handler: handler
        )
    }
}

class CountryCityViewModel {
    private(set) var currentPage : Int = 1
    private(set) var totalPage : Int = 1
    private(set) var countryListData: [GetCountryDataModel] = []
    private(set) var selectedCountry : GetCountryDataModel?
    private(set) var refresHandler : HandleTableRefresh?
    private(set) var arrayCities : [CitiesInfo] = []
    private(set) var searchText : String = ""
    private var searchTimer : Timer?
    private var cityActionHandler:HandleCityAction?
    
    func setRefreshHandler(_ handler:HandleTableRefresh,cityActionHandler:HandleCityAction)  {
        refresHandler = handler
        self.cityActionHandler = cityActionHandler
    }
    
    func getAllCountry(_ completion:@escaping(() -> Void) ) {
        WebService.shared.getAllCountry(){ [weak self] response in
            guard let self = self else { return }
            countryListData = response
            if (!countryListData.isEmpty && self.selectedCountry == nil) {
                self.setCountry(countryListData[0])
            } else {
                self.getCities()
            }
            refresHandler?.refreshTable(for: CountryCityListTableType.country.rawValue)
            completion()
        }
    }
    func setSearch(_ string:String)  {
        if (searchTimer != nil) {
            searchTimer?.invalidate()
            searchTimer = nil
        }
        self.searchText = string
        self.searchTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(handleSearch(_:)), userInfo: nil, repeats: false)
    }
    
    
    func changePage(_ isPrevious:Bool) {
        if isPrevious {
            currentPage = currentPage <= 1 ? 1 : currentPage - 1
        } else {
            currentPage = currentPage < totalPage ? currentPage + 1 : currentPage
        }
        self.getCities()
    }
    var isLastPage:Bool {
        currentPage >= totalPage
    }
    var isFirstPage:Bool {
        currentPage <= 1
    }
    
    private func resetPageCount() {
        self.currentPage = 1
        self.totalPage = 1
    }
    
    @objc func handleSearch(_ sender:Timer) {
        self.getCities()
    }
    
    func setCountry(_ country:GetCountryDataModel) {
        self.selectedCountry = country
        self.refresHandler?.refreshTable(for: CountryCityListTableType.country.rawValue)
        self.resetPageCount()
        self.searchText = ""
        self.getCities()
        
    }
    
    
    func getCities() {
        let limit = 5
        let searchText = String.getString(self.searchText)
        let country  = Int.getInt(selectedCountry?.id)
        var paramter : [String:Any] = [
            APIKeys.limit:limit,
            APIKeys.page:self.currentPage,
        ]
        if (country > 0) {
            paramter[APIKeys.country_id] = country
        }
        if (!searchText.isEmpty) {
            paramter[APIKeys.search] = searchText
        }
        WebService.sharedInstance.getServiceCities(parameter: paramter) { cityModel in
            self.totalPage = cityModel.lastPage ?? 1
            self.arrayCities = ((cityModel.data ?? []).sorted(by: {Date(iso8601String: String.getString($0.createdAt)).compare(Date(iso8601String: String.getString($1.createdAt))) == .orderedDescending})).map({CitiesInfo.makeData($0,handler: self.cityActionHandler)})
            self.refresHandler?.refreshTable(for: CountryCityListTableType.cities.rawValue)
        }
    }
    func addCity(id:String,_ completion:@escaping () -> Void) {
        WebService.shared.addCity(cityId: id) { data in
            completion()
        }
    }
    func deleteCity(id:String,_ completion:@escaping () -> Void) {
        WebService.shared.deleteCity(cityId: id) { data in
            completion()
        }
    }
    func changeCityStatus(id:String,_ completion:@escaping () -> Void) {
        WebService.shared.changeCityStatus(cityId: id) { data in
            completion()
        }
    }
}
