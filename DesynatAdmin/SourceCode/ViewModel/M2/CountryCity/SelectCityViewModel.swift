//
//  SelectCityViewModel.swift
//  DesynatAdmin
//
//  Created by Meet Goti on 11/11/25.
//

import Foundation
class SelectCityViewModel {
    private(set) var citiesListData: [CountryCitiesDataModel] = []
    private(set) var refresHandler : HandleTableRefresh?
    private(set) var countryId : String = ""
    private(set) var selectedCity:CountryCitiesDataModel?
    private var excludedCityIds: [Int] = []
    
    func setCountryId(_ string:String) {
        self.countryId = string
    }
    
    func setExcludedCities(_ ids: [Int]) {
            self.excludedCityIds = ids
        }
    
    func getAllCities(_ completion:@escaping(() -> Void) ) {
        WebService.shared.getCities(countryId: countryId) { [weak self] response in
            guard let self = self else { return }
            
            // filter out excluded cities BEFORE assigning and refreshing
            self.citiesListData = response.filter { city in
                !self.excludedCityIds.contains(Int.getInt(city.id))
            }
            
            if !self.citiesListData.isEmpty, self.selectedCity == nil {
                self.setCities(self.citiesListData[0])
            }
            
            self.refresHandler?.refreshTable(for: "")
            completion()
        }
    }
    
    func setRefreshHandler(_ handler:HandleTableRefresh)  {
        refresHandler = handler
    }

    func setCities(_ country:CountryCitiesDataModel) {
        self.selectedCity = country
        self.refresHandler?.refreshTable(for: "")
    }
}
