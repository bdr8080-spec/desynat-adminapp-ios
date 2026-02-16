//
//  SetDefaultDeliveryFeeViewModel.swift
//  DesynatAdmin
//
//  Created by fluper_mac3 on 16/02/26.
//

import Foundation

class SetDefaultDeliveryfeeViewModel {
    
    private var hostVC: SetDefaultDeliveryfeeViewController?
    
    init(hostVC: SetDefaultDeliveryfeeViewController?) {
        self.hostVC = hostVC
    }
    
    func addDefaultShippingFees(param: [String: Any]) {
        WebService.shared.addDefaultShippingFees(param: param){ [weak self] response in
            guard let self = self else { return }
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                self.hostVC?.dismiss(animated: true)
                let taxAmount = hostVC?.taxTF.text ?? ""
                self.hostVC?.taxDefaultAmountSet?(taxAmount)
                CommonUtils.showToast(message: "Default Delivery Tax Updated successfully")
            }
        }
    }
}
