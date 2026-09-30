//
//  PaymentViewModel.swift
//  DesynatAdmin
//
//  Created by Fluper New Mac1 on 23/07/26.
//

import Foundation

class PaymentViewModel {
    
    private var hostVC: PaymentMethodVC
    var refundListData: [RefundMangementList] = []
    var currentPage: Int = 1
    var totalPages: Int = 1
    var searchText: String = ""
    var appliedFilter = PaymentFilterModel()
    
    init(hostVC: PaymentMethodVC) {
        self.hostVC = hostVC
    }
    
    func refundOrder(orderDetailId: Int,_ paymentId:String,_ completion: @escaping () -> Void) {
        let params: [String: Any] = [
            "orderdetail_id": orderDetailId
        ]
        WebService.shared.refundOrderService(param: params) { [weak self] response in
            guard let self = self else { return }
            completion()
        }
    }
    
    func sellerPayout(sellerID: Int, payAmount: Double, _ transactionId: String, _ completion: @escaping () -> Void) {
        let param: [String: Any] = ["transaction_id": transactionId,
                                    "amount": payAmount,
                                    "seller_id": sellerID]
        WebService.shared.addSellerPayoutsRequests(param: param){ [weak self] response in
            guard let self = self else { return }
            completion()
        }
    }

    
}
