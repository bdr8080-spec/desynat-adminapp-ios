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
    
    let mobileInput = String.getString(hostVC.mobileTF.text).trimmingCharacters(in: .whitespacesAndNewlines)
    let emailInput  = String.getString(hostVC.emailTF.text).trimmingCharacters(in: .whitespacesAndNewlines)
    let passwordInput  = String.getString(hostVC.passwordTF.text).trimmingCharacters(in: .whitespacesAndNewlines)
    
    if hostVC.profileImageUrl.isEmpty {
      error = .uploadProfilePicture
      
    } else if hostVC.fullNameInEnglishTF.text?.trimmed().isEmpty ?? true {
      error = .enterFullNameEnglish
      
    } else if hostVC.fullNameInArabicTF.text?.trimmed().isEmpty ?? true {
      error = .enterFullNameArabic
      
    } else if mobileInput.isEmpty {
      error = .EnterMobileNumber
      
    } else if !mobileInput.isValidPhoneNumber() {
      error = .validMobileNumber
      
    } else if emailInput.isEmpty {
      error = .EnterEmailAddress
      
    } else if !emailInput.isValidEmail() {
      error = .EnterValidEmailAddress
      
    }  else if hostVC.addressLineOneTF.text?.isEmpty ?? true {
      error = .enterAddress1
      
    } else if hostVC.addressLineTwoTF.text?.isEmpty ?? true {
      error = .enterAddress2
      
    } else if hostVC.cityTF.text?.isEmpty ?? true {
      error = .enterCity
      
    } else if hostVC.stateTF.text?.isEmpty ?? true {
      error = .enterState
      
      
    }else if hostVC.passwordTF.text?.isEmpty ?? true {
      error = .EnterPassword
      
    } else if passwordInput.count < 6 {
      error = .PasswordMinLength
    }else if hostVC.confirmPasswordTF.text?.isEmpty ?? true {
      error = .EnterConfirmPassword
      
    } else if hostVC.passwordTF.text != hostVC.confirmPasswordTF.text {
      error = .PasswordNotMatched
      
    } else if hostVC.zoneId == 0 {
      error = .selectZone
      
    } else if hostVC.vehicleNameTF.text?.isEmpty ?? true {
      error = .enterVehicleName
      
    } else if hostVC.vehicleeRegistrationTF.text?.isEmpty ?? true {
      error = .enterVehicleReg
      
    } else if hostVC.vehicleImageFrontImageUrl.isEmpty {
      error = .uploadVehicleFront
      
    } else if hostVC.vehicleImageBackImageUrl.isEmpty {
      error = .uploadVehicleBack
      
    } else if hostVC.identityProofFrontImageUrl.isEmpty {
      error = .uploadIdentityFront
      
    } else if hostVC.identityProofBackImageUrl.isEmpty {
      error = .uploadIdentityBack
      
    } else if hostVC.drivingLcenseFrontImageUrl.isEmpty {
      error = .uploadDLFront
      
    } else if hostVC.drivingLcenseBackImagenUrl.isEmpty {
      error = .uploadDLBack
      
    } else if hostVC.vehicleInsuranceImageUrl.isEmpty {
      error = .uploadInsurance
      
   // } else if hostVC.pollutionPaperImageUrl.isEmpty {
     // error = .uploadPollution
      
//    } else if hostVC.registrationCertificationFrontUrl.isEmpty {
//      error = .uploadRCFront
      
//    } else if hostVC.registrationCertificationBackUrl.isEmpty {
//      error = .uploadRCBack
    }
    
    if error != .none {
        hostVC.showAlert(msg: error.rawValue.localiz())
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
          CommonUtils.showToast(message: "Driver added succesfully".localiz())
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
          CommonUtils.showToast(message: "Driver Details updated succesfully".localiz())
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
