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
  var driverDetails: DeliveryBoysList?
  
    init(hostVC: AddNewDriverViewController) {
        self.hostVC = hostVC
    }
    
  func validateFields() -> Bool {
    var message = ""
    
    // MARK: - Image Checks
    if hostVC.profileImageUrl.isEmpty { message = "Please upload profile picture" }
    
    if message.isEmpty, hostVC.fullNameInEnglishTF.text?.trimmingCharacters(in: .whitespaces).isEmpty ?? true {
      message = "Enter full name in English"
    }
    
    if message.isEmpty, hostVC.fullNameInArabicTF.text?.trimmingCharacters(in: .whitespaces).isEmpty ?? true {
      message = "Enter full name in Arabic"
    }
    
    if message.isEmpty, let mobile = hostVC.mobileTF.text, mobile.count < 6 {
      message = "Enter valid mobile number"
    }
    
    if message.isEmpty, hostVC.emailTF.text?.isEmpty ?? true {
      message = "Enter email"
    }
    
    if message.isEmpty, !String.getString(hostVC.emailTF.text).isValidEmail() {
      message = "Enter valid email address"
    }
    
    if message.isEmpty, hostVC.passwordTF.text?.isEmpty ?? true {
      message = "Enter password"
    }
    
    if message.isEmpty, hostVC.confirmPasswordTF.text?.isEmpty ?? true {
      message = "Enter confirm password"
    }
    
    if message.isEmpty, hostVC.passwordTF.text != hostVC.confirmPasswordTF.text {
      message = "Password & confirm password should match"
    }
    
    if message.isEmpty, hostVC.addressLineOneTF.text?.isEmpty ?? true {
      message = "Select Address Line 1"
    }
    
    if message.isEmpty, hostVC.addressLineTwoTF.text?.isEmpty ?? true {
      message = "Enter Address Line 2"
    }
    
    if message.isEmpty, hostVC.cityTF.text?.isEmpty ?? true {
      message = "Enter city"
    }
    
    if message.isEmpty, hostVC.stateTF.text?.isEmpty ?? true {
      message = "Enter state"
    }
    
    if message.isEmpty, hostVC.zoneId == 0 {
      message = "Select zone"
    }
    
    if message.isEmpty, hostVC.vehicleNameTF.text?.isEmpty ?? true {
      message = "Enter Vehcile Name"
    }
    
    if message.isEmpty, hostVC.vehicleeRegistrationTF.text?.isEmpty ?? true {
      message = "Enter Vehcile Registration"
    }
    
    // Vehicle / Proof Images
    if message.isEmpty, hostVC.vehicleImageFrontImageUrl.isEmpty { message = "Upload vehicle front image" }
    if message.isEmpty, hostVC.vehicleImageBackImageUrl.isEmpty { message = "Upload vehicle back image" }
    
    if message.isEmpty, hostVC.identityProofFrontImageUrl.isEmpty { message = "Upload identity proof (front)" }
    if message.isEmpty, hostVC.identityProofBackImageUrl.isEmpty { message = "Upload identity proof (back)" }
    
    if message.isEmpty, hostVC.drivingLcenseFrontImageUrl.isEmpty { message = "Upload driving license (front)" }
    if message.isEmpty, hostVC.drivingLcenseBackImagenUrl.isEmpty { message = "Upload driving license (back)" }
    
    if message.isEmpty, hostVC.vehicleInsuranceImageUrl.isEmpty { message = "Upload vehicle insurance" }
    if message.isEmpty, hostVC.pollutionPaperImageUrl.isEmpty { message = "Upload pollution paper" }
    
    if message.isEmpty, hostVC.registrationCertificationFrontUrl.isEmpty { message = "Upload RC front image" }
    if message.isEmpty, hostVC.registrationCertificationBackUrl.isEmpty { message = "Upload RC back image" }
    
    // Show error
    if !message.isEmpty {
      self.hostVC.showAlert(msg: message)
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
        
        WebService.sharedInstance.editSubCategory(param: params) { (response) in
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
  
  func getDriverDetails(param: [String: Any], completion: (() -> Void)? = nil) {
    WebService.shared.getDriverDetails(param: param){ [weak self] response in
          guard let self = self else { return }
        driverDetails = response
        completion?()
      }
  }
}
