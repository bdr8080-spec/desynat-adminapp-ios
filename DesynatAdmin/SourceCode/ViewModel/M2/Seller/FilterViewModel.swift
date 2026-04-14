//
//  FilterViewModel.swift
//  DesynatAdmin
//
//  Created by Meet Goti on 07/11/25.
//

import Foundation
class FilterViewModel {
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
        self.refresHandler?.refreshTable(for: "")
    }
    func setStartDate(_ date:Date) {
        self.filterInfo.startDate = date
    }
    func setEndDate(_ date:Date) {
        self.filterInfo.endDate = date
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
            refresHandler?.refreshTable(for: "")
            completion()
        }
    }
}
