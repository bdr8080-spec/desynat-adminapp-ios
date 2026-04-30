//
//  AddNewCardViewModel.swift
//  DesynatAdmin
//
//  Created by fluper on 09/12/25.
//

import Foundation
import UIKit

class AddNewCardViewModel: NSObject {
    private var hostVC: AddNewCardViewController
    
    init(hostVC: AddNewCardViewController) {
        self.hostVC = hostVC
    }
    
    func validFields() -> Bool {
        var errorMessage: AlertConstant = .none
        
        if hostVC.selectedImageUrl.isEmpty {
            errorMessage = .SelectCardImage
        }
        
        let englishName = String.getString(hostVC.cardNameEnglishTextField.text).trimmingCharacters(in: .whitespacesAndNewlines)
        if errorMessage == .none {
            if englishName.isEmpty {
                errorMessage = .EnterCardEnglish
            }
        }
        
        let arabicName = String.getString(hostVC.cardNameArabicTextField.text).trimmingCharacters(in: .whitespacesAndNewlines)
        if errorMessage == .none {
            if arabicName.isEmpty {
                errorMessage = .EnterCardArabic
            }
        }
        
        if errorMessage != .none {
            hostVC.showAlert(msg: errorMessage.rawValue.localiz())
        }
        
        hostVC.view.endEditing(true)
        return errorMessage == .none
    }
    
    
    func addCardApi() {
        let params: [String:Any] = [
            "name_english": hostVC.cardNameEnglishTextField.text?.trimmed() ?? "",
            "name_arabic": hostVC.cardNameArabicTextField.text?.trimmed() ?? "",
            "image": hostVC.selectedImageUrl]
        WebService.sharedInstance.addNewCard(param: params) { (response) in
            DispatchQueue.main.async {
                CommonUtils.showToast(message: "Gift Card Category Added Succesfully".localiz())
                self.hostVC.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func editCardApi() {
        let params: [String:Any] = [
            "giftCard_id": hostVC.giftsListData?.id ?? 0,
            "name_english": hostVC.cardNameEnglishTextField.text?.trimmed() ?? "",
            "name_arabic": hostVC.cardNameArabicTextField.text?.trimmed() ?? "",
            "image": hostVC.selectedImageUrl]
        WebService.sharedInstance.editCardDetails(param: params) { (response) in
            DispatchQueue.main.async {
                CommonUtils.showToast(message: "Gift Card Category Updated Succesfully".localiz())
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
}

