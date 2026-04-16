//
//  AddNewStaffViewModel.swift
//  DesynatAdmin
//
//  Created by fluper_mac3 on 16/04/26.
//

import Foundation

class AddNewStaffViewModel {
    
    private var hostVC: AddNewStaffViewController
    var userProfile: UserModel?
    var countryListData: [GetCountryDataModel] = []
    
    init(hostVC: AddNewStaffViewController) {
        self.hostVC = hostVC
    }
    
    func getAllCountry(completion: (() -> Void)? = nil) {
        WebService.shared.getAllCountry(){ [weak self] response in
            guard let self = self else { return }
            countryListData = response
            completion?()
        }
    }
    
    func uploadDocument(file: Any, isImage: Bool, completion: @escaping(String) -> Void) {
        let param:MultipartUpload = MultipartUpload(fileName: "image", file: file, mimeType: isImage ? .image : .pdf)
        WebService.sharedInstance.uploadFile(withParams: param) { url, msg, code in
            completion(url)
        }
    }
    
    func validFields() -> Bool {
        var errorMessage: AlertConstant = .none
        
        if hostVC.selectedImageUrl.isEmpty {
            errorMessage = .SelectBrandImage
        }
        
        let fullNameInEnglish = String.getString(hostVC.fullNameInEnglishTF.text).trimmingCharacters(in: .whitespacesAndNewlines)
        if errorMessage == .none {
            if fullNameInEnglish.isEmpty {
                errorMessage = .enterFullNameEnglish
            }
        }
        
        let fullNameInArabic = String.getString(hostVC.fullNameInArabicTF.text).trimmingCharacters(in: .whitespacesAndNewlines)
        if errorMessage == .none {
            if fullNameInArabic.isEmpty {
                errorMessage = .enterFullNameArabic
            }
        }
        
        let emailId = String.getString(hostVC.emailTF.text).trimmingCharacters(in: .whitespacesAndNewlines)
        if emailId.isEmpty {
            errorMessage = .EnterEmailAddress
        }else if !emailId.isValidEmail() {
            errorMessage = .EnterValidEmailAddress
        }
        
        let mobile = String.getString(hostVC.mobileTF.text).trimmingCharacters(in: .whitespacesAndNewlines)
        if mobile.isEmpty {
            errorMessage = .EnterMobileNumber
        }else if !mobile.isValidPhoneNumber() {
            errorMessage = .validMobileNumber
        }
        
        if hostVC.selectedRoleIndex == -1 {
            errorMessage = .selectRoleForNotification
        }
        
        let password = String.getString(hostVC.passwordTxtField.text).trimmingCharacters(in: .whitespacesAndNewlines)
        if errorMessage == .none {
            if password.isEmpty {
                errorMessage = .EnterPassword
            }
        }
        
        let confirmPassword = String.getString(hostVC.confirmPasswortTxtField.text).trimmingCharacters(in: .whitespacesAndNewlines)
        if errorMessage == .none {
            if confirmPassword.isEmpty {
                errorMessage = .EnterConfirmPassword
            }
        }
        
        if errorMessage != .none {
            hostVC.showAlert(msg: errorMessage.rawValue)
        }
        
        hostVC.view.endEditing(true)
        return errorMessage == .none
    }
    
    func addNewStaff() {
        
    }
    
    func editStaffDetails() {
        
    }
    
}
