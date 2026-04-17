//
//  EditProfileViewModel.swift
//  DesynatAdmin
//
//  Created by fluper_mac3 on 16/04/26.
//

import Foundation

class EditProfileViewModel {
    
    private var hostVC: EditProfileViewController
    var userProfile: UserModel?
    var countryListData: [GetCountryDataModel] = []
    
    init(hostVC: EditProfileViewController) {
        self.hostVC = hostVC
    }
    
    func validFields() -> Bool {
        var errorMessage: AlertConstant = .none
        
        if hostVC.selectedImageUrl.isEmpty {
            errorMessage = .SelectBrandImage
        }
        
        let fullName = String.getString(hostVC.fullnameTF.text).trimmingCharacters(in: .whitespacesAndNewlines)
        if errorMessage == .none {
            if fullName.isEmpty {
                errorMessage = .EnterBrandEnglish
            }
        }
        
        let email = String.getString(hostVC.emailIdTF.text).trimmingCharacters(in: .whitespacesAndNewlines)
        if email.isEmpty {
            errorMessage = .EnterEmailAddress
        }
        else if !email.isValidEmail() {
            errorMessage = .EnterValidEmailAddress
        }
        
        let mobile = String.getString(hostVC.mobileTF.text).trimmingCharacters(in: .whitespacesAndNewlines)
        if mobile.isEmpty {
            errorMessage = .EnterMobileNumber
        }
        else if !mobile.isValidPhoneNumber() {
            errorMessage = .validMobileNumber
        }
        
        if errorMessage != .none {
            hostVC.showAlert(msg: errorMessage.rawValue)
        }
        
        hostVC.view.endEditing(true)
        return errorMessage == .none
    }
    
    func getAllCountry(completion: (() -> Void)? = nil) {
        WebService.shared.getAllCountry(){ [weak self] response in
            guard let self = self else { return }
            countryListData = response
            completion?()
        }
    }
    
    func editProfileRequest() {
        let params: [String:Any] = ["profile_pic": hostVC.selectedImageUrl,
                                    "email": hostVC.emailIdTF.text ?? "",
                                    "country_code": hostVC.countryCode,
                                    "mobile": hostVC.mobileTF.text ?? "",
                                    "full_name": hostVC.fullnameTF.text ?? ""]
        WebService.sharedInstance.editProfileService(withParams: params) { (response) in
            DispatchQueue.main.async {
                CommonUtils.showToast(message: "Profile is updated Succesfully ")
                self.hostVC.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func getUserProfile() {
        if let savedUser: UserModel = kSharedUserDefaults.retrieveModelFor(key: .user, model: UserModel.self) {
            userProfile = savedUser
            hostVC.configData()
        }
    }
    
    func uploadDocument(file: Any, isImage: Bool, completion: @escaping(String) -> Void) {
        let param:MultipartUpload = MultipartUpload(fileName: "image", file: file, mimeType: isImage ? .image : .pdf)
        WebService.sharedInstance.uploadFile(withParams: param) { url, msg, code in
            completion(url)
        }
    }
    
}
