//
//  SellerDetailViewModel.swift
//  DesynatAdmin
//
//  Created by Meet Goti on 07/11/25.
//

import Foundation
struct SocialMediaInfo {
    var id:String = UUID().uuidString
    var postUrl:String = ""
    var isVideo:Bool = false
}
class SellerDetailViewModel {
    private(set) var sellerData :SellerListInfo?
    private(set) var detailModel: SellerDataModel?
    private(set) var sellerStatus : SellersTab = .none
//    private(set) var arrayReels : [SocialMediaInfo] = []
    private(set) var arrayPlans : [PurchasedPlanInfo] = []
    private(set) var isActive : Bool = true
    
    func setData(_ sellerData :SellerListInfo) {
        self.sellerData = sellerData
    }
    
    func getSellerDetailInfo(_ completion:@escaping () -> Void) {
        WebService.shared.getSellerDetail(id: String.getString(sellerData?.id)) { data in
            self.detailModel = data
            self.arrayPlans = (data.subcriptionPlan ?? []).map({ PurchasedPlanInfo.makeData($0)} )
            completion()
        }
    }
    
    func setActive(_ bool:Bool) {
        self.isActive = bool
    }
    func approveSeller(_ completion:@escaping() -> Void ) {
        WebService.shared.approveSellers(id: String.getString(self.sellerData?.id)) { data in
            completion()
        }
    }
    func updateStatusSellers(_ completion:@escaping() -> Void ) {
        WebService.shared.updateStatusSellers(id: String.getString(self.sellerData?.id)) { data in
            completion()
        }
    }
    func rejectSeller(reason:String,type:SellerRejectionType,_ completion:@escaping() -> Void ) {
        let parameter :[String:Any] = [
            APIKeys.seller_id:String.getString(self.sellerData?.id),
            APIKeys.reject_reason:reason,
            APIKeys.reject_type:type.paramterValue,
        ]
        WebService.shared.rejectSellers(paramter: parameter) { data in
            self.setActive(Bool(truncating: NSNumber(value: Int.getInt(data.isBlock))))
            completion()
        }
    }
}
