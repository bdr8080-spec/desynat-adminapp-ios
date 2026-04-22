//
//  AddNewStaffViewModel.swift
//  DesynatAdmin
//
//  Created by fluper_mac3 on 16/04/26.
//

import Foundation

class AddNewStaffViewModel {
    
    private var hostVC: AddNewStaffViewController
    var countryListData: [GetCountryDataModel] = []
    var adminModulesListData: [GetAllAdminModulesDataModel] = []
    
    init(hostVC: AddNewStaffViewController) {
        self.hostVC = hostVC
    }
    
    func getAllCountry() {
        WebService.shared.getAllCountry(){ [weak self] response in
            guard let self = self else { return }
            countryListData = response
        }
    }
    
    func getAllAdminModulesRequest(completion: (() -> Void)? = nil) {
        WebService.shared.getAllAdminModulesService(){ [weak self] response in
            guard let self = self else { return }
            adminModulesListData = response
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
        
//        if hostVC.selectedRoleIndex == -1 {
//            errorMessage = .selectRoleForNotification
//        }
        
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
        
        if errorMessage == .none {
            if password != confirmPassword {
                errorMessage = .PasswordNotMatched
            }
        }
        
        if errorMessage == .none {
            if hostVC.moduleSelctedData.isEmpty {
                errorMessage = .selectModule
            }
        }
        
        if errorMessage != .none {
            hostVC.showAlert(msg: errorMessage.rawValue)
        }
        
        hostVC.view.endEditing(true)
        return errorMessage == .none
    }
    
    func addNewStaff() {
        let modulesArray = hostVC.moduleSelctedData.map { module in
            return [
                "module_id": module.moduleId,
                "can_view": module.viewSelcted,
                "can_action": module.actionIsSelected
            ]
        }
        
        let param: [String: Any] = ["profile_pic": hostVC.selectedImageUrl,
                                    "full_name": hostVC.fullNameInEnglishTF.text ?? "",
                                    "full_name_ar": hostVC.fullNameInArabicTF.text ?? "",
                                    "country_code": hostVC.countryCode,
                                    "mobile": hostVC.mobileTF.text ?? "",
                                    "email": hostVC.emailTF.text ?? "",
                                    "country_id": hostVC.countryID,
                                    "password": hostVC.passwordTxtField.text ?? "",
                                    "confirm_password": hostVC.confirmPasswortTxtField.text ?? "",
                                    "modules": modulesArray]
        WebService.shared.addSubAdminService(param: param){ [weak self] response in
            guard let self = self else { return }
            CommonUtils.showToast(message: "Staff is added successfully")
            self.hostVC.navigationController?.popViewController(animated: true)
        }
    }
    
    func editStaffDetails() {
        let modulesArray = hostVC.moduleSelctedData.map { module in
            return [
                "module_id": module.moduleId,
                "can_view": module.viewSelcted,
                "can_action": module.actionIsSelected
            ]
        }
        
        let param: [String: Any] = ["id": hostVC.staffDetails?.id ?? 0,
                                    "profile_pic": hostVC.selectedImageUrl,
                                    "full_name": hostVC.fullNameInEnglishTF.text ?? "",
                                    "full_name_ar": hostVC.fullNameInArabicTF.text ?? "",
                                    "country_code": hostVC.countryCode,
                                    "mobile": hostVC.mobileTF.text ?? "",
                                    "email": hostVC.emailTF.text ?? "",
                                    "country_id": hostVC.countryID,
                                    "password": hostVC.passwordTxtField.text ?? "",
                                    "confirm_password": hostVC.confirmPasswortTxtField.text ?? "",
                                    "modules": modulesArray]
        print("param====>\(param)")
        WebService.shared.updateSubAdminService(param: param){ [weak self] response in
            guard let self = self else { return }
            CommonUtils.showToast(message: "Staff is updated successfully")
            self.hostVC.navigationController?.popViewController(animated: true)
        }
    }
    
}
