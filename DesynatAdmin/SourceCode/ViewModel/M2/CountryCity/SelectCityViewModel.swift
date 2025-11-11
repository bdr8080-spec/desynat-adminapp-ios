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
    
    func setCountryId(_ string:String) {
        self.countryId = string
    }
    
    func getAllCities(_ completion:@escaping(() -> Void) ) {
        WebService.shared.getCities(countryId: countryId){ [weak self] response in
            guard let self = self else { return }
            citiesListData = response
            if (!citiesListData.isEmpty) {
                if selectedCity == nil {
                    self.setCities(citiesListData[0])
                }
            }
            refresHandler?.refreshTable(for: "")
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
