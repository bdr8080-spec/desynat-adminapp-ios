//
//  AddBrandViewModel.swift
//  DesynatAdmin
//
//  Created by Rakhi Kumari on 01/11/25.
//

import Foundation
import UIKit

class AddBrandViewModel: NSObject {
    
    private var hostVC: AddNewBrandViewController
    
    init(hostVC: AddNewBrandViewController) {
        self.hostVC = hostVC
    }
    
    func validFields() -> Bool {
        var errorMessage: AlertConstant = .none
        
        if hostVC.selectedImageUrl.isEmpty {
            errorMessage = .SelectBrandImage
        }
        
        let englishName = String.getString(hostVC.brandNameEnglishTextField.text).trimmingCharacters(in: .whitespacesAndNewlines)
        if errorMessage == .none {
            if englishName.isEmpty {
                errorMessage = .EnterBrandEnglish
            }
        }
        
        let arabicName = String.getString(hostVC.brandNameArabicTextField.text).trimmingCharacters(in: .whitespacesAndNewlines)
        if errorMessage == .none {
            if arabicName.isEmpty {
                errorMessage = .EnterBrandArabic
            }
        }
        
        if errorMessage != .none {
            hostVC.showAlert(msg: errorMessage.rawValue)
        }
        
        hostVC.view.endEditing(true)
        return errorMessage == .none
    }

    
    func addBrandApi() {
        let params: [String:Any] = [
            "name_english": hostVC.brandNameEnglishTextField.text?.trimmed() ?? "",
            "name_arabic": hostVC.brandNameArabicTextField.text?.trimmed() ?? "",
            "image": hostVC.selectedImageUrl]
        WebService.sharedInstance.addNewBrand(param: params) { (response) in
            DispatchQueue.main.async {
                CommonUtils.showToast(message: "Brand Added Succesfully")
                self.hostVC.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func editBrandApi() {
        let params: [String:Any] = [
            "brand_id": hostVC.brandData?.id ?? 0,
            "name_english": hostVC.brandNameEnglishTextField.text?.trimmed() ?? "",
            "name_arabic": hostVC.brandNameArabicTextField.text?.trimmed() ?? "",
            "image": hostVC.selectedImageUrl]
        WebService.sharedInstance.editBrand(param: params) { (response) in
            DispatchQueue.main.async {
                CommonUtils.showToast(message: "Brand updated Succesfully ")
                self.hostVC.onBrandUpdated?(response)
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
    
}

