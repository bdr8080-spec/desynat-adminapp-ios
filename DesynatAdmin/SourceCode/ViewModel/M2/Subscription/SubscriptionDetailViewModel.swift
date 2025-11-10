//
//  SubscriptionDetailViewModel.swift
//  DesynatAdmin
//
//  Created by Meet Goti on 10/11/25.
//

import Foundation
class SubscriptionDetailViewModel {
    var data:PlanInfo
    init(data: PlanInfo) {
        self.data = data
    }
    
    func setActive(_ bool:Bool,completion:@escaping() -> Void) {
        self.data.isActive = bool
        WebService.sharedInstance.updateStatusPlan(id: data.id) { model in
            completion()
        }
    }
    func deletePlan(_ completion:@escaping() -> Void) {
        WebService.sharedInstance.deletePlan(id: data.id) { model in
            completion()
        }
    }
    
    func getDetail(_ completion:@escaping () -> Void)  {
        WebService.sharedInstance.getSubscriptionPlanDetail(id: String.getString(data.id)) { data in
            self.data = PlanInfo.makeInfo(data)
            completion()
        }
    }
}
