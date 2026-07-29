//
//  ShippingChargesAndTaxViewModel.swift
//  DesynatAdmin
//
//  Created by fluper on 09/12/25.
//

import Foundation

class ShippingChargesAndTaxViewModel {
    
    private var hostVC: ShippingChargesAndTaxViewController?
    
    var shippingTaxDetails: [ShippingChargesList]?
    
    init(hostVC: ShippingChargesAndTaxViewController) {
        self.hostVC = hostVC
    }
    
    func deleteShippingInfo(param: [String: Any]) {
        WebService.shared.deleteShippingInfo(param: param) { [weak self] response in
            guard let self = self else { return }
            DispatchQueue.main.async {
                CommonUtils.showToast(message: "Delivery charge deleted succesfully".localiz())
                self.getAllshippingTaxList()
            }
        }
    }
    
    func updateActiveStatus(param: [String: Any], completion: @escaping (Bool) -> Void) {
        WebService.shared.updateStatusOfShippingFees(param: param){ response in
            completion(true)
        }
    }
    
    func getAllshippingTaxList() {
        let param: [String: Any] = ["country_id": hostVC?.countryId ?? 0]
        WebService.shared.getShippingTaxesCountryWise(params: param) { [weak self] response in
            guard let self = self else { return }
            self.shippingTaxDetails = response
            DispatchQueue.main.async {
                self.hostVC?.shippingTableView.reloadData()
                self.hostVC?.populateData()
                self.hostVC?.noDataFoundLabel.isHidden = !(self.shippingTaxDetails?.isEmpty ?? false)
            }
        }
    }
    
    func getDefaultDeliveryFees() {
        let param: [String: Any] = ["country_id": hostVC?.countryId ?? 0]
        WebService.shared.getDefaultDeliveryFees(param: param) { [weak self] response in
            guard let self = self else { return }
            hostVC?.defaultTaxAmount = response.shippingFee
            if let taxString = response.shippingFee,
               let taxDouble = Double(taxString) {
                self.hostVC?.defaultDeliveryFeeLabel.text = CommonUtils.formatPrice(taxDouble, currency: response.countryInfo?.currencyCode ?? "")
            } else {
                self.hostVC?.defaultDeliveryFeeLabel.text = CommonUtils.formatPriceStringInputDecimal("0", currency: response.countryInfo?.currencyCode ?? "")
            }
        }
    }
}


