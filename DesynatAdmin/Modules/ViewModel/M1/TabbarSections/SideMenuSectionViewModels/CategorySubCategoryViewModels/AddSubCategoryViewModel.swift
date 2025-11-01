//
//  AddSubCategory.swift
//  DesynatAdmin
//
//  Created by Rakhi Kumari on 01/11/25.
//

import Foundation
import UIKit

class AddSubCategoryViewModel: NSObject {
    private var hostVC: AddSubCategoryViewController
    
    init(hostVC: AddSubCategoryViewController) {
        self.hostVC = hostVC
    }
    
    func validFields() -> Bool {
        var errorMessage: AlertConstant = .none
        
        if hostVC.selectedImageUrl.isEmpty {
            errorMessage = .SelectSubCategoryImage
        }
        
        let englishName = String.getString(hostVC.subCategoryTextField.text).trimmingCharacters(in: .whitespacesAndNewlines)
        if errorMessage == .none {
            if englishName.isEmpty {
                errorMessage = .EnterSubCategoryEnglish
            }
        }
        
        let arabicName = String.getString(hostVC.subCategoryTextField.text).trimmingCharacters(in: .whitespacesAndNewlines)
        if errorMessage == .none {
            if arabicName.isEmpty {
                errorMessage = .EnterSubCategoryArabic
            }
        }
        
        if errorMessage != .none {
            hostVC.showAlert(msg: errorMessage.rawValue)
        }
        
        hostVC.view.endEditing(true)
        return errorMessage == .none
    }
    
    func addSubCategoryApi() {
        let params: [String:Any] = [
            "category_id": hostVC.categoryId,
            "name_english": hostVC.subCategoryTextField.text?.trimmed() ?? "",
            "name_arabic": hostVC.subCategoryArabicTextField.text?.trimmed() ?? "",
            "image": hostVC.selectedImageUrl]
        
        WebService.sharedInstance.addSubCategory(param: params) { (response) in
            DispatchQueue.main.async {
                self.hostVC.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func editSubCategoryApi() {
        let params: [String:Any] = [
            "subcategory_id": hostVC.subCategoryData?.id ?? 0,
            "name_english": hostVC.subCategoryTextField.text?.trimmed() ?? "",
            "name_arabic": hostVC.subCategoryArabicTextField.text?.trimmed() ?? "",
            "image": hostVC.selectedImageUrl]
        
        WebService.sharedInstance.editSubCategory(param: params) { (response) in
            DispatchQueue.main.async {
                self.hostVC.onSubCategoryUpdated?(response)
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
