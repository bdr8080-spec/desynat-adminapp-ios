//
//  AddNewDriverViewModel.swift
//  DesynatAdmin
//
//  Created by fluper on 21/11/25.
//

import Foundation
import UIKit

class AddNewDriverViewModel: NSObject {
    
    private var hostVC: AddNewDriverViewController
    var countryListData: [GetCountryDataModel] = []
    var zoneListData: [DriverZoneList] = []
    
    init(hostVC: AddNewDriverViewController) {
        self.hostVC = hostVC
    }
    
    func validateFields() -> Bool {
        var error: AlertConstant = .none
        
        // Profile image
        if hostVC.profileImageUrl.isEmpty {
            error = .uploadProfilePicture
        }
        
        // Full names
        if error == .none, hostVC.fullNameInEnglishTF.text?.trimmed().isEmpty ?? true {
            error = .enterFullNameEnglish
        }
        
        if error == .none, hostVC.fullNameInArabicTF.text?.trimmed().isEmpty ?? true {
            error = .enterFullNameArabic
        }
        
        let mobileInput = String.getString(hostVC.mobileTF.text).trimmingCharacters(in: .whitespacesAndNewlines)
        
        if mobileInput.isEmpty {
            error = .EnterMobileNumber
        } else {
            if !mobileInput.isValidPhoneNumber() {
                error = .validMobileNumber
            }
        }
        
        let emailInput = String.getString(hostVC.emailTF.text).trimmingCharacters(in: .whitespacesAndNewlines)
        
        if emailInput.isEmpty {
            error = .EnterEmailAddress
        } else {
            if !emailInput.isValidEmail() {
                error = .EnterValidEmailAddress
            }
        }
        
        if !hostVC.isComingForEdit {
            if error == .none, hostVC.passwordTF.text?.isEmpty ?? true {
                error = .EnterPassword
            }
            
            if error == .none, hostVC.confirmPasswordTF.text?.isEmpty ?? true {
                error = .EnterConfirmPassword
            }
            
            if error == .none, hostVC.passwordTF.text != hostVC.confirmPasswordTF.text {
                error = .PasswordNotMatched
            }
        }
        
        if error == .none, hostVC.addressLineOneTF.text?.isEmpty ?? true {
            error = .enterAddress1
        }
        
        if error == .none, hostVC.addressLineTwoTF.text?.isEmpty ?? true {
            error = .enterAddress2
        }
        
        if error == .none, hostVC.cityTF.text?.isEmpty ?? true {
            error = .enterCity
        }
        
        if error == .none, hostVC.stateTF.text?.isEmpty ?? true {
            error = .enterState
        }
        
        if error == .none, hostVC.zoneId == 0 {
            error = .selectZone
        }
        
        // Vehicle details
        if error == .none, hostVC.vehicleNameTF.text?.isEmpty ?? true {
            error = .enterVehicleName
        }
        
        if error == .none, hostVC.vehicleeRegistrationTF.text?.isEmpty ?? true {
            error = .enterVehicleReg
        }
        
        if error == .none, hostVC.vehicleImageFrontImageUrl.isEmpty { error = .uploadVehicleFront }
        if error == .none, hostVC.vehicleImageBackImageUrl.isEmpty { error = .uploadVehicleBack }
        
        if error == .none, hostVC.identityProofFrontImageUrl.isEmpty { error = .uploadIdentityFront }
        if error == .none, hostVC.identityProofBackImageUrl.isEmpty { error = .uploadIdentityBack }
        
        if error == .none, hostVC.drivingLcenseFrontImageUrl.isEmpty { error = .uploadDLFront }
        if error == .none, hostVC.drivingLcenseBackImagenUrl.isEmpty { error = .uploadDLBack }
        
        if error == .none, hostVC.vehicleInsuranceImageUrl.isEmpty { error = .uploadInsurance }
        if error == .none, hostVC.pollutionPaperImageUrl.isEmpty { error = .uploadPollution }
        
        if error == .none, hostVC.registrationCertificationFrontUrl.isEmpty { error = .uploadRCFront }
        if error == .none, hostVC.registrationCertificationBackUrl.isEmpty { error = .uploadRCBack }
        
        // Show error
        if error != .none {
            hostVC.showAlert(msg: error.rawValue)
            return false
        }
        
        return true
    }
    
    func addDriverApi() {
        let params: [String: Any] = [
            "profile_pic": hostVC.profileImageUrl,
            
            "full_name_english": String.getString(hostVC.fullNameInEnglishTF.text),
            "full_name_arabic": String.getString(hostVC.fullNameInArabicTF.text),
            "email": String.getString(hostVC.emailTF.text),
            "country_code": hostVC.countryCode ?? "+965",
            "mobile": String.getString(hostVC.mobileTF.text),
            "password": String.getString(hostVC.passwordTF.text),
            "confirm_password": String.getString(hostVC.confirmPasswordTF.text),
            
            "address_line1": String.getString(hostVC.addressLineOneTF.text),
            "address_line2": String.getString(hostVC.addressLineTwoTF.text),
            "city": String.getString(hostVC.cityTF.text),
            "state": String.getString(hostVC.stateTF.text),
            
            "let": hostVC.latitude ?? 0.0,
            "long": hostVC.longitude ?? 0.0,
            "zone_id": hostVC.zoneId ?? 0,
            
            "vehicle_name": String.getString(hostVC.vehicleNameTF.text),
            "vehicle_reg_no": String.getString(hostVC.vehicleeRegistrationTF.text),  // Add your field if present
            
            "vehicle_image_front": hostVC.vehicleImageFrontImageUrl,
            "vehicle_image_back": hostVC.vehicleImageBackImageUrl,
            
            "identity_proof_front": hostVC.identityProofFrontImageUrl,
            "identity_proof_back": hostVC.identityProofBackImageUrl,
            
            "driving_license_front": hostVC.drivingLcenseFrontImageUrl,
            "driving_license_back": hostVC.drivingLcenseBackImagenUrl,
            
            "vehicle_insurance": hostVC.vehicleInsuranceImageUrl,
            "pollution_paper": hostVC.pollutionPaperImageUrl,
            
            "registration_certificate_front": hostVC.registrationCertificationFrontUrl,
            "registration_certificate_back": hostVC.registrationCertificationBackUrl
        ]
        WebService.sharedInstance.addDriver(param: params) { (response) in
            DispatchQueue.main.async {
                CommonUtils.showToast(message: "New Driver added succesfully")
                self.hostVC.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func editDriverProfileApi() {
        let params: [String: Any] = [
            "delivery_boy_id": hostVC.userId ?? 0,
            "profile_pic": hostVC.profileImageUrl,
            
            "full_name_english": String.getString(hostVC.fullNameInEnglishTF.text),
            "full_name_arabic": String.getString(hostVC.fullNameInArabicTF.text),
            "email": String.getString(hostVC.emailTF.text),
            "country_code": hostVC.countryCode ?? "+965",
            "mobile": String.getString(hostVC.mobileTF.text),
            "password": String.getString(hostVC.passwordTF.text),
            "confirm_password": String.getString(hostVC.confirmPasswordTF.text),
            
            "address_line1": String.getString(hostVC.addressLineOneTF.text),
            "address_line2": String.getString(hostVC.addressLineTwoTF.text),
            "city": String.getString(hostVC.cityTF.text),
            "state": String.getString(hostVC.stateTF.text),
            
            "let": hostVC.latitude ?? 0.0,
            "long": hostVC.longitude ?? 0.0,
            "zone_id": hostVC.zoneId ?? 0,
            
            "vehicle_name": String.getString(hostVC.vehicleNameTF.text),
            "vehicle_reg_no": String.getString(hostVC.vehicleeRegistrationTF.text),  // Add your field if present
            
            "vehicle_image_front": hostVC.vehicleImageFrontImageUrl,
            "vehicle_image_back": hostVC.vehicleImageBackImageUrl,
            
            "identity_proof_front": hostVC.identityProofFrontImageUrl,
            "identity_proof_back": hostVC.identityProofBackImageUrl,
            
            "driving_license_front": hostVC.drivingLcenseFrontImageUrl,
            "driving_license_back": hostVC.drivingLcenseBackImagenUrl,
            
            "vehicle_insurance": hostVC.vehicleInsuranceImageUrl,
            "pollution_paper": hostVC.pollutionPaperImageUrl,
            
            "registration_certificate_front": hostVC.registrationCertificationFrontUrl,
            "registration_certificate_back": hostVC.registrationCertificationBackUrl
        ]
        
        WebService.sharedInstance.editDriverDetails(param: params) { (response) in
            DispatchQueue.main.async {
                CommonUtils.showToast(message: "Driver Details updated succesfully")
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
    
    func getAllCountry(completion: (() -> Void)? = nil) {
        WebService.shared.getAllCountry(){ [weak self] response in
            guard let self = self else { return }
            countryListData = response
            completion?()
        }
    }
    
    func getAllZone(completion: (() -> Void)? = nil) {
        WebService.shared.getAllZone(){ [weak self] response in
            guard let self = self else { return }
            zoneListData = response
            completion?()
        }
    }
    
    func getDriverDetails() {
        let param: [String: Any] = ["user_id": hostVC.userId ?? 0]
        WebService.shared.getDriverDetails(param: param){ [weak self] response in
            guard let self = self else { return }
            hostVC.fillDriverData(data: response)
        }
    }
}
