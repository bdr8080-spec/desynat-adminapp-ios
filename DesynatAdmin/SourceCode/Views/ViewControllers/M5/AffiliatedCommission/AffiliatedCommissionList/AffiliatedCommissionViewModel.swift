//
//  AffiliatedCommissionViewModel.swift
//  DesynatAdmin
//
//  Created by fluper on 16/12/25.
//

import Foundation

class AffiliatedCommissionViewModel {
    
    private var hostVC: AffiliatedCommissionViewController
    var commissionData: [CommissionPercentageModel] = []
    
    init(hostVC: AffiliatedCommissionViewController) {
        self.hostVC = hostVC
    }
    
    func getAffiliatedCommissionByCity() {
        WebService.sharedInstance.getAffiliateCommissionByCities { [weak self] (result) in
            self?.commissionData = result
            
            DispatchQueue.main.async {
                self?.hostVC.affiliatedTableView.reloadData()
                self?.hostVC.noDataFoundLabel.isHidden = !(self?.commissionData.isEmpty ?? true)
            }
        }
    }
    
    func updateAffiliatedCommissionByCity(countryId: Int, commission: String) {
        let params: [String:Any] = [
            "country_id": countryId,
            "commission": commission]
        WebService.sharedInstance.updateCommissionByCities(param: params) { [weak self] (result) in
            
            DispatchQueue.main.async {
                self?.getAffiliatedCommissionByCity()
            }
        }
    }
}

