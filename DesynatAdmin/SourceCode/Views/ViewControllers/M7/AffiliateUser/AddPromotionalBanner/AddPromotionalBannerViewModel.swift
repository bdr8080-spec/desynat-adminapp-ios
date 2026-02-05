//
//  AddPromotionalBannerViewModel.swift
//  DesynatAdmin
//
//  Created by fluper_mac3 on 04/02/26.
//

import Foundation

class AddPromotionalBannerViewModel {
    
    private var hostVC: AddPromotionalBannerViewController
    //  var countryListData: [GetAllUserCountryModel] = []
    var categoryListData: [GetCategoryModel] = []
    var selectedCategoriesId: Int? = -1
    var selectedSubCategoriesId: Int? = -1
    var subcategoriesList: [GetSubCategoryDataList] = []
    
    init(hostVC: AddPromotionalBannerViewController) {
        self.hostVC = hostVC
    }
    
    func getAllCategory() {
        WebService.shared.getAllCategory(){ [weak self] response in
            guard let self = self else { return }
            categoryListData = response
            hostVC.selectCategoryCollectionview.reloadData()
            if !self.hostVC.isComingForEdit {
                self.selectedCategoriesId = self.categoryListData.first?.id
                self.getSubCategoriesListApi()
            }
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
        
        //Image
        if errorMessage == .none &&
            hostVC.selectedImageUrl.isEmpty &&
            hostVC.pickedImage == nil {//}&&
//            hostVC.pickedGifData == nil {
            errorMessage = .SelectBannerImage
        }
        
        //ForType
        if errorMessage == .none && hostVC.selectedPositionIndex == 0 {
            errorMessage = .selectForPosition
        }
        
        // Category & SubCategory (ONLY when Category selected)
        if errorMessage == .none && hostVC.selectedPositionIndex == 3 {
            
            if selectedCategoriesId == -1 {
                errorMessage = .SelectCategory
            }
            else if selectedSubCategoriesId == -1 {
                errorMessage = .SelectSubCategory
            }
        }
        
        //From Date
        let fromDate = String.getString(hostVC.fromTextField.text)
            .trimmingCharacters(in: .whitespacesAndNewlines)
        
        if errorMessage == .none && fromDate.isEmpty {
            errorMessage = .SelectFromDate
        }
        
        //To Date
        let toDate = String.getString(hostVC.toTextField.text)
            .trimmingCharacters(in: .whitespacesAndNewlines)
        
        if errorMessage == .none && toDate.isEmpty {
            errorMessage = .SelectToDate
        }
        
        if errorMessage != .none {
            hostVC.showAlert(msg: errorMessage.rawValue)
            hostVC.view.endEditing(true)
            return false
        }
        
        hostVC.view.endEditing(true)
        return true
    }
    
    func addAdvertisementApi() {
        let apiFromDate = convertDateString(hostVC.fromTextField.text ?? "",from: "dd/MM/yyyy",to: "yyyy-MM-dd")
        let apiToDate = convertDateString(hostVC.toTextField.text ?? "",from: "dd/MM/yyyy",to: "yyyy-MM-dd")
        
        var params: [String:Any] = [
            "banner_position": hostVC.selectedPositionIndex,
            "upload_banner": hostVC.selectedImageUrl,
            "start_date": apiFromDate,
            "end_date": apiToDate,
            "total_days": hostVC.lblTotalDays.text ?? "",
        ]
        if hostVC.selectedPositionIndex == 3 {
            params["category"] = selectedCategoriesId ?? 0
            params["subcatgory"] = selectedSubCategoriesId ?? 0
        }
        
        WebService.sharedInstance.addPromotionalBanner(param: params) { (response) in
            DispatchQueue.main.async {
                CommonUtils.showToast(message: "Advertisement added succesfully")
                self.hostVC.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func editAdvertisementApi() {
        let apiFromDate = convertDateString(hostVC.fromTextField.text ?? "",from: "dd/MM/yyyy",to: "yyyy-MM-dd")
        let apiToDate = convertDateString(hostVC.toTextField.text ?? "",from: "dd/MM/yyyy",to: "yyyy-MM-dd")
        let params: [String:Any] = [:]
        //      "banner_id": hostVC.giftsListData?.id ?? 0,
        //      "image": hostVC.selectedImageUrl,
        //      "country_id": hostVC.countryId,
        //      "type": hostVC.selectedPositionIndex,
        //      "title": hostVC.titleTextField.text?.trimmed() ?? "",
        //      "start_date": apiFromDate, //hostVC.fromTextField.text?.trimmed() ?? "",
        //      "end_date": apiToDate ]//hostVC.toTextField.text?.trimmed() ?? ""]
        
        WebService.sharedInstance.editAdvertisement(param: params) { (response) in
            DispatchQueue.main.async {
                CommonUtils.showToast(message: "Advertisement updated succesfully")
                self.hostVC.onCardUpdated?(response)
                self.hostVC.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func uploadDocument(file: Any, isImage: Bool, completion: @escaping(String) -> Void) {
        let param:MultipartUpload = MultipartUpload(fileName: "image", file: file, mimeType: isImage ? .image : .pdf)
        WebService.sharedInstance.uploadFile(withParams: param) { url, msg, code in
            completion(url)
        }
    }
    
//    func uploadFullScreenBanner(
//        file: Any,
//        isImage: Bool,
//        isGif: Bool = false,
//        keyParam: [String: Any],
//        completion: @escaping(String) -> Void
//    ) {
//        let mime: MultipartUpload.Mime = isGif ? .gif : (isImage ? .image : .pdf)
//        
//        let param = MultipartUpload(
//            fileName: "image",
//            file: file,
//            mimeType: mime
//        )
//        
//        WebService.sharedInstance.uploadFullScreenBanner(withParams: param, param: keyParam) {
//            url, msg, code in
//            completion(url)
//        }
//    }
    
    
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

