//
//  AddPricePerDayViewModel.swift
//  DesynatAdmin
//
//  Created by fluper on 09/12/25.
//

import Foundation

class AddPricePerDayViewModel {
  
  private var hostVC: AddPricePerDayViewController
  
  init(hostVC: AddPricePerDayViewController) {
    self.hostVC = hostVC
  }

  func addPricePerDay() {
    let params: [String : Any] = ["per_day_price": hostVC.amountTF.text?.trimmed() ?? "",
                                  "type": hostVC.bannerDetails?.type ?? 1,
                                  "country_id": hostVC.bannerDetails?.countryID ?? 0]
    WebService.shared.addPriceBannersPerDay(param: params) { [weak self] response in
      guard let self = self else { return }
      DispatchQueue.main.async {
        self.hostVC.onChangesAreDone?()
        self.hostVC.dismiss(animated: true)
      }
    }
  }

}
