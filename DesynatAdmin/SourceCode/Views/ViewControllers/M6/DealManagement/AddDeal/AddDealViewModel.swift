//
//  AddDealViewModel.swift
//  DesynatAdmin
//
//  Created by fluper on 08/01/26.
//

import Foundation

class AddDealViewModel {
  
  private var hostVC : AddDealViewController
  var categoryListData: [GetCategoryModel] = []
  var selectedCategoriesId: Int? = -1
  var selectedSubCategoriesId: Int? = -1
  var subcategoriesList: [GetSubCategoryDataList] = []
  
  init(hostVC: AddDealViewController) {
    self.hostVC = hostVC
  }
  
  func getAllCategory() {
    WebService.shared.getAllCategory(){ [weak self] response in
      guard let self = self else { return }
      categoryListData = response
      hostVC.selectCategoryCollectionview.reloadData()
      //      selectedCategoriesId = categoryListData.first?.id ?? 0
      if !self.hostVC.comingforEdit {
        self.selectedCategoriesId = self.categoryListData.first?.id
        self.getSubCategoriesListApi()
      }
      //      getSubCategoriesListApi()
    }
  }
  
  func uploadDocument(file: Any, isImage: Bool, completion: @escaping(String) -> Void) {
    let param:MultipartUpload = MultipartUpload(fileName: "image", file: file, mimeType: isImage ? .image : .pdf)
    WebService.sharedInstance.uploadFile(withParams: param) { url, msg, code in
      completion(url)
    }
  }
  
  func getSubCategoriesListApi(){
    let param: [String :Any] = ["category_id": selectedCategoriesId ?? ""]
    WebService.sharedInstance.getAllsubcategory(param: param) { [self] list in
      self.subcategoriesList = list.data ?? []
    }
  }
  
  func validFields() -> Bool {
    var errorMessage: AlertConstant = .none
    
    if hostVC.selectedImageUrl.isEmpty {
      errorMessage = .SelectCardImage
    }
    
    let englishName = String.getString(hostVC.fullNameTF.text).trimmingCharacters(in: .whitespacesAndNewlines)
    if errorMessage == .none {
      if englishName.isEmpty {
        errorMessage = .enterFullNameEnglish
      }
    }
    
    let arabicName = String.getString(hostVC.fullNameInArabicTF.text).trimmingCharacters(in: .whitespacesAndNewlines)
    if errorMessage == .none {
      if arabicName.isEmpty {
        errorMessage = .enterFullNameArabic
      }
    }
    
    if errorMessage == .none && selectedCategoriesId == -1 {
      errorMessage = .SelectCategory
    }
    
    if errorMessage == .none && selectedSubCategoriesId == -1 {
      errorMessage = .SelectSubCategory
    }
    
    let discount = String.getString(hostVC.discountTF.text).trimmingCharacters(in: .whitespacesAndNewlines)
    if errorMessage == .none {
      if discount.isEmpty {
        errorMessage = .EnterDiscount
      }
    }
    
    let fromDate = String.getString(hostVC.fromTf.text).trimmingCharacters(in: .whitespacesAndNewlines)
    if errorMessage == .none {
      if fromDate.isEmpty {
        errorMessage = .SelectFromDate
      }
    }
    
    let toDate = String.getString(hostVC.toTF.text).trimmingCharacters(in: .whitespacesAndNewlines)
    if errorMessage == .none {
      if toDate.isEmpty {
        errorMessage = .SelectToDate
      }
    }
    
    if errorMessage != .none {
      hostVC.showAlert(msg: errorMessage.rawValue)
    }
    
    hostVC.view.endEditing(true)
    return errorMessage == .none
  }
  
  func addCardApi() {
    let apiFromDate = convertDateString(hostVC.fromTf.text ?? "",from: "dd/MM/yyyy",to: "yyyy-MM-dd")
    let apiToDate = convertDateString(hostVC.toTF.text ?? "",from: "dd/MM/yyyy",to: "yyyy-MM-dd")
    let params: [String:Any] = [
      "image": hostVC.selectedImageUrl,
      "name_english": hostVC.fullNameTF.text?.trimmed() ?? "",
      "name_arabic": hostVC.fullNameInArabicTF.text?.trimmed() ?? "",
      "category_id": selectedCategoriesId ?? 0,
      "sub_category_id": selectedSubCategoriesId ?? 0,
      "discount": hostVC.discountTF.text?.trimmed() ?? "",
      "from":  apiFromDate,
      "to": apiToDate]
    WebService.sharedInstance.addNewDeal(param: params) { (response) in
      DispatchQueue.main.async {
        CommonUtils.showToast(message: "Deal Added Succesfully")
        self.hostVC.navigationController?.popViewController(animated: true)
      }
    }
  }
  
  func editCardApi() {
    let apiFromDate = convertDateString(hostVC.fromTf.text ?? "",from: "dd/MM/yyyy",to: "yyyy-MM-dd")
    let apiToDate = convertDateString(hostVC.toTF.text ?? "",from: "dd/MM/yyyy",to: "yyyy-MM-dd")
    let params: [String:Any] = [
      "deal_id": hostVC.dealData?.id ?? 0,
      "image": hostVC.selectedImageUrl,
      "name_english": hostVC.fullNameTF.text?.trimmed() ?? "",
      "name_arabic": hostVC.fullNameInArabicTF.text?.trimmed() ?? "",
      "category_id": selectedCategoriesId ?? 0,
      "sub_category_id": selectedSubCategoriesId ?? 0,
      "discount": hostVC.discountTF.text?.trimmed() ?? "",
      "from":  apiFromDate,
      "to": apiToDate]
    WebService.sharedInstance.editDealsDetails(param: params) { (response) in
      DispatchQueue.main.async {
        CommonUtils.showToast(message: "Deal Updated Succesfully ")
        self.hostVC.navigationController?.popViewController(animated: true)
      }
    }
  }
  
  func convertDateString(
    _ dateString: String,
    from inputFormat: String,
    to outputFormat: String
  ) -> String {
    let inputFormatter = DateFormatter()
    inputFormatter.dateFormat = inputFormat
    inputFormatter.locale = Locale(identifier: "en_US_POSIX")
    
    let outputFormatter = DateFormatter()
    outputFormatter.dateFormat = outputFormat
    outputFormatter.locale = Locale(identifier: "en_US_POSIX")
    
    guard let date = inputFormatter.date(from: dateString) else {
      return ""
    }
    return outputFormatter.string(from: date)
  }
  
}
