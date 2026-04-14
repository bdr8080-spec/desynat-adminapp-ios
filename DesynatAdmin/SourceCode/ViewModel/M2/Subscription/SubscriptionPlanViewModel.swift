//
//  SubscriptionPlanViewModel.swift
//  DesynatAdmin
//
//  Created by Meet Goti on 10/11/25.
//

import Foundation
enum SubscriptionTableType:String {
    case country,plans
}
class SubscriptionPlanViewModel {
    
    private(set) var countryListData: [GetCountryDataModel] = []
    private(set) var selectedCountry : GetCountryDataModel?
    private(set) var refresHandler : HandleTableRefresh?
    private(set) var arrayPlans : [PlanInfo] = []
    func setRefreshHandler(_ handler:HandleTableRefresh)  {
        refresHandler = handler
    }
    func getAllCountry(_ completion:@escaping(() -> Void) ) {
        WebService.shared.getAllCountry(){ [weak self] response in
            guard let self = self else { return }
            countryListData = response
            if (!countryListData.isEmpty && self.selectedCountry == nil) {
                self.setCountry(countryListData[0])
            } else {
                self.getPlans()
            }
            refresHandler?.refreshTable(for: SubscriptionTableType.country.rawValue)
            completion()
        }
    }
    
    func setCountry(_ country:GetCountryDataModel) {
        self.selectedCountry = country
        self.refresHandler?.refreshTable(for: SubscriptionTableType.country.rawValue)
        self.getPlans()
    }
    func getPlans() {
        WebService.shared.getSubscriptionPlan(countryId: String.getString(self.selectedCountry?.id)) { plans in
            self.arrayPlans = plans.map({PlanInfo.makeInfo($0)})
            self.refresHandler?.refreshTable(for: SubscriptionTableType.plans.rawValue)
        }
    }
}
