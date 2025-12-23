//
//  BannersMangementFilterViewModel.swift
//  DesynatAdmin
//
//  Created by fluper on 16/12/25.
//

import Foundation

class BannersMangementFilterViewModel {
    private(set) var countryListData: [GetCountryDataModel] = []
    private(set) var refresHandler : HandleTableRefresh?
    private(set) var filterInfo : FilterInfo = FilterInfo()
    
    func setFilter(_ info:FilterInfo)  {
        self.filterInfo = info
    }
    
    func setRefreshHandler(_ handler:HandleTableRefresh)  {
        refresHandler = handler
    }

    func setCountry(_ country:GetCountryDataModel) {
        self.filterInfo.country = country
    }
    func setStartDate(_ date:Date) {
        self.filterInfo.startDate = date
    }
    func setEndDate(_ date:Date) {
        self.filterInfo.endDate = date
    }
    
    func clearFilter() {
        self.filterInfo = FilterInfo()
    }
    
    func getAllCountry(_ completion:@escaping(() -> Void) ) {
        WebService.shared.getAllCountry(){ [weak self] response in
            guard let self = self else { return }
            countryListData = response
            if (!countryListData.isEmpty) {
                if self.filterInfo.country == nil {
                    self.setCountry(countryListData[0])
                }
            }
            completion()
        }
    }
}
