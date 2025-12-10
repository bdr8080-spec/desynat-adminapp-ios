//
//  AddPromocodeViewModel.swift
//  DesynatAdmin
//
//  Created by fluper on 09/12/25.
//

import Foundation

class AddPromocodeViewModel {
  
  private var hostVC: AddPromocodeViewController?
  var countryListData: [GetCountryDataModel] = []
  
  init(hostVC: AddPromocodeViewController) {
    self.hostVC = hostVC
  }
  
  func getAllCountry(completion: (() -> Void)? = nil) {
    WebService.shared.getAllCountry(){ [weak self] response in
      guard let self = self else { return }
      countryListData = response
      completion?()
    }
  }
  
  func addPromocode() {
    let param: [String: Any] = ["country_id": hostVC?.countryCode ?? 0,
                                "name_english": hostVC?.promocodeEnglishTF.text ?? "",
                                "name_arabic": hostVC?.promocodeArabicTF.text ?? "",
                                "description_english": hostVC?.descriptionEnglishTF.text ?? "",
                                "description_arabic": hostVC?.descriptionArabicTF.text ?? "",
                                "applicable_for": hostVC?.selectedOrderType ?? 1, // 1 = first order, 2 = every order
                                "discount_percent": Int(hostVC?.discountF.text ?? "0") ?? 0,
                                "min_order_value": Int(hostVC?.minimumOrderTF.text ?? "0") ?? 0,
                                "upto_discount": Int(hostVC?.upToDiscountTF.text ?? "0") ?? 0,
                                "start_date": convertToAPIDate(hostVC?.startDateTF.text ?? ""), // yyyy-MM-dd
                                "end_date": convertToAPIDate(hostVC?.endDateTF.text ?? "")      // yyyy-MM-dd
    ]
    WebService.shared.addPromoCode(param: param){ [weak self] response in
      guard let self = self else { return }
      self.hostVC?.navigationController?.popViewController(animated: true)
    }
  }
  
  func editPromocode() {
    let param: [String: Any] = ["promocode_id": hostVC?.promocodeDetails?.id ?? 0,
                                "country_id": hostVC?.countryCode ?? 0,
                                "name_english": hostVC?.promocodeEnglishTF.text ?? "",
                                "name_arabic": hostVC?.promocodeArabicTF.text ?? "",
                                "description_english": hostVC?.descriptionEnglishTF.text ?? "",
                                "description_arabic": hostVC?.descriptionArabicTF.text ?? "",
                                "applicable_for": hostVC?.selectedOrderType ?? 1, // 1 = first order, 2 = every order
                                "discount_percent": Int(hostVC?.discountF.text ?? "0") ?? 0,
                                "min_order_value": Int(hostVC?.minimumOrderTF.text ?? "0") ?? 0,
                                "upto_discount": Int(hostVC?.upToDiscountTF.text ?? "0") ?? 0,
                                "start_date": convertToAPIDate(hostVC?.startDateTF.text ?? ""), // yyyy-MM-dd
                                "end_date": convertToAPIDate(hostVC?.endDateTF.text ?? "")      // yyyy-MM-dd
    ]
    WebService.shared.editPromoCode(param: param){ [weak self] response in
      guard let self = self else { return }
//      self.hostVC?.navigationController?.popViewController(animated: true)
      self.hostVC?.navigationController?.popToViewController(ofClass: PromodeListViewController.self, animated: true)
    }
  }
  
  func convertToAPIDate(_ input: String) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "dd/MM/yyyy"
    
    let apiFormatter = DateFormatter()
    apiFormatter.dateFormat = "yyyy-MM-dd"
    
    if let date = formatter.date(from: input) {
      return apiFormatter.string(from: date)
    }
    return ""
  }
  
}
