//
//  AddNewDriverViewController.swift
//  DesynatAdmin
//
//  Created by fluper on 21/11/25.
//

import UIKit

class AddNewDriverViewController: UIViewController {
  
  @IBOutlet weak var buttonLabel: UILabel!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var profileImageView: CustomImageView!
  @IBOutlet weak var fullNameInEnglishTF: UITextField!
  @IBOutlet weak var fullNameInArabicTF: UITextField!
  @IBOutlet weak var mobileTF: UITextField!
  @IBOutlet weak var countryCodeTF: UITextField!
  @IBOutlet weak var emailTF: UITextField!
  @IBOutlet weak var addressLineOneTF: UITextField!
  @IBOutlet weak var addressLineTwoTF: UITextField!
  @IBOutlet weak var cityTF: UITextField!
  @IBOutlet weak var stateTF: UITextField!
  @IBOutlet weak var passwordTF: UITextField!
  @IBOutlet weak var confirmPasswordTF: UITextField!
  @IBOutlet weak var zoneTF: UITextField!
  @IBOutlet weak var vehicleNameTF: UITextField!
  @IBOutlet weak var vehicleImageFrontImageView: CustomImageView!
  @IBOutlet weak var vehicleImageBackImageView: CustomImageView!
  @IBOutlet weak var identityProofFrontImageView: CustomImageView!
  @IBOutlet weak var identityProofBackImageView: CustomImageView!
  @IBOutlet weak var drivingLcenseFrontImageView: CustomImageView!
  @IBOutlet weak var drivingLcenseBackImageView: CustomImageView!
  @IBOutlet weak var vehicleInsuranceImageView: CustomImageView!
  @IBOutlet weak var pollutionPaperImageView: CustomImageView!
  @IBOutlet weak var registrationCertificationFrontImagViw: CustomImageView!
  @IBOutlet weak var registrationCertificationBackImagViw: CustomImageView!
  @IBOutlet weak var vehicleeRegistrationTF: UITextField!
  @IBOutlet weak var passwordView: UIView!
  @IBOutlet weak var confirmPassowrdView: UIView!
  @IBOutlet weak var currentLocationButton: UIButton!
  
  var isComingForEdit: Bool = false
  var userId: Int? = 0
  private lazy var viewModel = AddNewDriverViewModel(hostVC: self)
  var countryCode: String? = "+965"
  var zoneId: Int? = 0
  var profileImageUrl: String = ""
  var vehicleImageFrontImageUrl: String = ""
  var vehicleImageBackImageUrl: String = ""
  var identityProofFrontImageUrl: String = ""
  var identityProofBackImageUrl: String = ""
  var drivingLcenseFrontImageUrl: String = ""
  var drivingLcenseBackImagenUrl: String = ""
  var pollutionPaperImageUrl: String = ""
  var vehicleInsuranceImageUrl: String = ""
  var registrationCertificationFrontUrl: String = ""
  var registrationCertificationBackUrl: String = ""
  var latitude: Double? = 0.0
  var longitude: Double? = 0.0
  //    var editDriverData: DeliveryBoysList?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    let textFields: [UITextField] = [
      fullNameInEnglishTF, fullNameInArabicTF, mobileTF, countryCodeTF,
      emailTF, addressLineOneTF, addressLineTwoTF, cityTF, stateTF,
      passwordTF, confirmPasswordTF, zoneTF, vehicleNameTF, vehicleeRegistrationTF
    ]
    
    for tf in textFields {
      tf.delegate = self
    }
    //        viewModel.getAllCountry()
    viewModel.getAllZone()
    if isComingForEdit {
      viewModel.getDriverDetails()
      titleLabel.text = "Edit Driver"
      buttonLabel.text = "Save Changes"
    } else {
      titleLabel.text = "Add New Driver"
      buttonLabel.text = "Add"
    }
  }
  
  
  @IBAction func backDidTapped(_ sender: Any) {
    self.navigationController?.popViewController(animated: true)
  }
  
  @IBAction func continueDidTapped(_ sender: Any) {
    if viewModel.validateFields() {
      if isComingForEdit {
        viewModel.editDriverProfileApi()
      } else {
        viewModel.addDriverApi()
      }
    }
  }
  
  @IBAction func countryCodeDidTapped(_ sender: UIButton) {
    let countryNames = viewModel.countryListData.map { country -> String in
      let name = country.name ?? ""
      let dialCode = country.dialCode ?? ""
      let flag = country.flag ?? "🇰🇼"
      return "\(flag)  \(name) (\(dialCode))"
    }
    
    kSharedAppDelegate.dropDown(dataSource: countryNames, anchorView: sender) { index, item in
      let selectedCountry = self.viewModel.countryListData[index]
      self.countryCodeTF.text = selectedCountry.dialCode
      self.countryCode = selectedCountry.dialCode ?? "+965"
    }
  }
  
  @IBAction func profileImageDidTappd(_ sender: Any) {
    ImagePickerManager().pickImage(self) { [weak self] image, fileName, url in
      guard let self = self else { return }
      DispatchQueue.main.async {
        self.profileImageView.image = image
      }
      guard let compressedImage = image.jpegData(compressionQuality: 0.25),
            let finalImage = UIImage(data: compressedImage) else {
        return
      }
      self.viewModel.uploadDocument(file: finalImage, isImage: true) { [weak self] uploadedUrl in
        guard let self = self else { return }
        DispatchQueue.main.async {
          self.profileImageUrl = uploadedUrl
        }
      }
    }
  }
  
  @IBAction func addressLineOneDidTapped(_ sender: Any) {
    let vc = LocationViewController.instantiate(fromAppStoryboard: .ReasonManagement)
    vc.preSelectedLat = self.latitude   // your saved lat
    vc.preSelectedLng = self.longitude  // your saved long
    
    vc.locationCallBack = { [weak self] address, locality, city, state, country, pincode, lat, long in
      guard let self = self else { return }
      
      // Make fallback-safe variables
      let safeLocality = locality.isEmpty ? address : locality        // fallback to full address
      let safeCity = city.isEmpty ? locality.isEmpty ? address : locality : city
      let safeState = state.isEmpty ? city.isEmpty ? locality.isEmpty ? address : locality : city : state
      let safePincode = pincode.isEmpty ? "" : pincode
      
      // Field 1 — Address Line One
      self.addressLineOneTF.text = safeLocality
      
      // Field 2 — Address Line Two (city + state + pincode)
      var components: [String] = []
      
      if !safeCity.isEmpty { components.append(safeCity) }
      if !safeState.isEmpty { components.append(safeState) }
      
      var addressLine2 = components.joined(separator: ", ")
      if !safePincode.isEmpty { addressLine2 += " - \(safePincode)" }
      
      // Last fallback if line2 becomes empty
      if addressLine2.isEmpty { addressLine2 = address }
      
      self.addressLineTwoTF.text = addressLine2
      
      // City & State fields
      self.cityTF.text = safeCity.isEmpty ? address : safeCity
      self.stateTF.text = safeState.isEmpty ? safeCity.isEmpty ? address : safeCity : safeState
      
      // Coordinates
      self.latitude = lat
      self.longitude = long
    }
    self.navigationController?.pushViewController(vc, animated: true)
  }
  
  @IBAction func selectZoneDidTapped(_ sender: UIButton) {
    let zoneNames = viewModel.zoneListData.map { country -> String in
      let name = country.nameEnglish ?? ""
      return "\(name)"
    }
    
    kSharedAppDelegate.dropDown(dataSource: zoneNames, anchorView: sender) { index, item in
      let selectedCountry = self.viewModel.zoneListData[index]
      self.zoneTF.text = selectedCountry.nameEnglish
      self.zoneId = selectedCountry.id
    }
  }
  
  @IBAction func uploadVehicleImageAction(_ sender: UIButton) {
    let isFront = (sender.tag == 0)
    let picker = ImagePickerManager.shared
    picker.allowPDFSelection = true  // enable PDF for this use
    picker.pickImage(self) { [weak self] image, fileName, url in
      guard let self = self else { return }
      let targetImageView = isFront ? self.vehicleImageFrontImageView : self.vehicleImageBackImageView
      let setUploadedUrl: (String) -> Void = { url in
        if isFront {
          self.vehicleImageFrontImageUrl = url
        } else {
          self.vehicleImageBackImageUrl = url
        }
      }
      
      if let url = url, url.pathExtension.lowercased() == "pdf" {
        DispatchQueue.main.async {
          targetImageView?.image = UIImage(named: "pdf_uploaded_sec")
        }
        if let pdfData = try? Data(contentsOf: url) {
          self.viewModel.uploadDocument(file: pdfData, isImage: false) { uploadedUrl in
            DispatchQueue.main.async {
              setUploadedUrl(uploadedUrl)
            }
          }
        }
      } else {
        DispatchQueue.main.async {
          targetImageView?.image = image
        }
        if let compressed = image.jpegData(compressionQuality: 0.25),
           let finalImage = UIImage(data: compressed) {
          self.viewModel.uploadDocument(file: finalImage, isImage: true) { uploadedUrl in
            DispatchQueue.main.async {
              setUploadedUrl(uploadedUrl)
            }
          }
        }
      }
    }
    
  }
  
  @IBAction func uplaodIdentityProofDidTapped(_ sender: UIButton) {
    let isFront = (sender.tag == 0)
    let pickerManager = ImagePickerManager.shared
    pickerManager.pickImage(self) { [weak self] image, fileName, url in
      guard let self = self else { return }
      
      let targetImageView = isFront ? self.identityProofFrontImageView : self.identityProofBackImageView
      let setUploadedUrl: (String) -> Void = { url in
        if isFront {
          self.identityProofFrontImageUrl = url
        } else {
          self.identityProofBackImageUrl = url
        }
      }
      
      if let url = url, url.pathExtension.lowercased() == "pdf" {
        // Show PDF placeholder
        DispatchQueue.main.async {
          targetImageView?.image = UIImage(named: "pdf_uploaded_sec")
        }
        
        // Upload PDF
        if let pdfData = try? Data(contentsOf: url) {
          self.viewModel.uploadDocument(file: pdfData, isImage: false) { uploadedUrl in
            DispatchQueue.main.async {
              setUploadedUrl(uploadedUrl)
            }
          }
        }
      } else {
        // It's an image
        DispatchQueue.main.async {
          targetImageView?.image = image
        }
        if let compressed = image.jpegData(compressionQuality: 0.25),
           let finalImage = UIImage(data: compressed) {
          self.viewModel.uploadDocument(file: finalImage, isImage: true) { uploadedUrl in
            DispatchQueue.main.async {
              setUploadedUrl(uploadedUrl)
            }
          }
        }
      }
    }
    
    
  }
  
  @IBAction func drivingLicencseAction(_ sender: UIButton) {
    let isFront = (sender.tag == 0)
    let picker = ImagePickerManager.shared
    picker.allowPDFSelection = true  // Enable PDF selection
    
    picker.pickImage(self) { [weak self] image, fileName, url in
      guard let self = self else { return }
      
      let targetImageView = isFront ? self.drivingLcenseFrontImageView : self.drivingLcenseBackImageView
      let setUploadedUrl: (String) -> Void = { url in
        if isFront {
          self.drivingLcenseFrontImageUrl = url
        } else {
          self.drivingLcenseBackImagenUrl = url
        }
      }
      
      // Check if the selected file is a PDF
      if let url = url, url.pathExtension.lowercased() == "pdf" {
        DispatchQueue.main.async {
          targetImageView?.image = UIImage(named: "pdf_uploaded_sec") // PDF placeholder
        }
        
        if let pdfData = try? Data(contentsOf: url) {
          self.viewModel.uploadDocument(file: pdfData, isImage: false) { uploadedUrl in
            DispatchQueue.main.async {
              setUploadedUrl(uploadedUrl)
            }
          }
        }
      } else {
        // It's an image
        DispatchQueue.main.async {
          targetImageView?.image = image
        }
        
        if let compressed = image.jpegData(compressionQuality: 0.25),
           let finalImage = UIImage(data: compressed) {
          self.viewModel.uploadDocument(file: finalImage, isImage: true) { uploadedUrl in
            DispatchQueue.main.async {
              setUploadedUrl(uploadedUrl)
            }
          }
        }
      }
    }
    
    
  }
  
  @IBAction func vehicleInsuranceDidTapepd(_ sender: Any) {
    let picker = ImagePickerManager.shared
    picker.allowPDFSelection = true  // Enable PDF selection
    
    picker.pickImage(self) { [weak self] image, fileName, url in
      guard let self = self else { return }
      
      // Check if the picked file is a PDF
      if let url = url, url.pathExtension.lowercased() == "pdf" {
        DispatchQueue.main.async {
          self.vehicleInsuranceImageView.image = UIImage(named: "pdf_uploaded_sec") // PDF placeholder
        }
        // Upload PDF as Data
        if let pdfData = try? Data(contentsOf: url) {
          self.viewModel.uploadDocument(file: pdfData, isImage: false) { uploadedUrl in
            DispatchQueue.main.async {
              self.vehicleInsuranceImageUrl = uploadedUrl
            }
          }
        }
      } else {
        // Handle image
        DispatchQueue.main.async {
          self.vehicleInsuranceImageView.image = image
        }
        
        if let compressedData = image.jpegData(compressionQuality: 0.25),
           let finalImage = UIImage(data: compressedData) {
          self.viewModel.uploadDocument(file: finalImage, isImage: true) { uploadedUrl in
            DispatchQueue.main.async {
              self.vehicleInsuranceImageUrl = uploadedUrl
            }
          }
        }
      }
    }
    
  }
  
  @IBAction func pollutionPaperImageDidTapped(_ sender: UIButton) {
    let picker = ImagePickerManager.shared
    picker.allowPDFSelection = true  // Enable PDF selection
    
    picker.pickImage(self) { [weak self] image, fileName, url in
      guard let self = self else { return }
      
      // Check if the picked file is a PDF
      if let url = url, url.pathExtension.lowercased() == "pdf" {
        DispatchQueue.main.async {
          self.pollutionPaperImageView.image = UIImage(named: "pdf_uploaded_sec") // PDF placeholder
        }
        // Upload PDF as Data
        if let pdfData = try? Data(contentsOf: url) {
          self.viewModel.uploadDocument(file: pdfData, isImage: false) { uploadedUrl in
            DispatchQueue.main.async {
              self.pollutionPaperImageUrl = uploadedUrl
            }
          }
        }
      } else  {
        // Handle image
        DispatchQueue.main.async {
          self.pollutionPaperImageView.image = image
        }
        
        if let compressedData = image.jpegData(compressionQuality: 0.25),
           let finalImage = UIImage(data: compressedData) {
          self.viewModel.uploadDocument(file: finalImage, isImage: true) { uploadedUrl in
            DispatchQueue.main.async {
              self.pollutionPaperImageUrl = uploadedUrl
            }
          }
        }
      }
    }
    
    
  }
  
  @IBAction func registrationCertificationDidTapped(_ sender: UIButton) {
    let isFront = (sender.tag == 0)
    let picker = ImagePickerManager.shared
    picker.allowPDFSelection = true  // Enable PDF selection
    
    picker.pickImage(self) { [weak self] image, fileName, url in
      guard let self = self else { return }
      
      let targetImageView = isFront ? self.registrationCertificationFrontImagViw : self.registrationCertificationBackImagViw
      let setUploadedUrl: (String) -> Void = { url in
        if isFront {
          self.registrationCertificationFrontUrl = url
        } else {
          self.registrationCertificationBackUrl = url
        }
      }
      
      // Check if the picked file is a PDF
      if let url = url, url.pathExtension.lowercased() == "pdf" {
        DispatchQueue.main.async {
          targetImageView?.image = UIImage(named: "pdf_uploaded_sec") // PDF placeholder
        }
        // Upload PDF as Data
        if let pdfData = try? Data(contentsOf: url) {
          self.viewModel.uploadDocument(file: pdfData, isImage: false) { uploadedUrl in
            DispatchQueue.main.async {
              setUploadedUrl(uploadedUrl)
            }
          }
        }
      } else {
        // Handle image
        DispatchQueue.main.async {
          targetImageView?.image = image
        }
        
        if let compressedData = image.jpegData(compressionQuality: 0.25),
           let finalImage = UIImage(data: compressedData) {
          self.viewModel.uploadDocument(file: finalImage, isImage: true) { uploadedUrl in
            DispatchQueue.main.async {
              setUploadedUrl(uploadedUrl)
            }
          }
        }
      }
    }
    
  }
  
  @IBAction func btnTapCreatePasswordEye(_ sender: UIButton) {
    sender.isSelected.toggle()
    passwordTF.isSecureTextEntry.toggle()
  }
  
  @IBAction func btnTapConfirmPasswordEye(_ sender: UIButton) {
    sender.isSelected.toggle()
    confirmPasswordTF.isSecureTextEntry.toggle()
  }
  
  func fillDriverData(data: DeliveryBoysList) {
    // MARK: - Text Fields
    fullNameInEnglishTF.text = data.fullNameEnglish
    fullNameInArabicTF.text = data.fullNameArabic
    emailTF.text = data.email
    mobileTF.text = data.mobile
    countryCodeTF.text = data.countryCode
    countryCode = data.countryCode
    
    addressLineOneTF.text = data.addressLine1
    addressLineTwoTF.text = data.addressLine2
    cityTF.text = data.city
    stateTF.text = data.state
    passwordTF.text = data.unhashedPassword
    confirmPasswordTF.text = data.unhashedPassword
    vehicleNameTF.text = data.vehicleName
    vehicleeRegistrationTF.text = data.vehicleRegNo
    zoneTF.text = data.zoneInfo?.nameEnglish
    zoneId = data.zoneInfo?.id
    
    latitude = Double(data.lat ?? "0.0")
    longitude = Double(data.long ?? "0.0")
    
    // MARK: - Image URLs Assignment (required for API)
    profileImageUrl = data.profilePic ?? ""
    
    vehicleImageFrontImageUrl = data.vehicleImage?.first(where: { $0.isFront == 1})?.documentPath ?? ""
    vehicleImageBackImageUrl = data.vehicleImage?.first(where: { $0.isFront == 0})?.documentPath ?? ""
    
    identityProofFrontImageUrl = data.identityProof?.first(where: { $0.isFront == 1})?.documentPath ?? ""
    identityProofBackImageUrl = data.identityProof?.first(where: { $0.isFront == 0})?.documentPath ?? ""
    
    drivingLcenseFrontImageUrl = data.drivingLicense?.first(where: { $0.isFront == 1})?.documentPath ?? ""
    drivingLcenseBackImagenUrl = data.drivingLicense?.first(where: { $0.isFront == 0})?.documentPath ?? ""
    
    vehicleInsuranceImageUrl = data.vehicleInsurance?.first?.documentPath ?? ""
    pollutionPaperImageUrl = data.pollutionPaper?.first?.documentPath ?? ""
    
    registrationCertificationFrontUrl = data.registrationCertificate?.first(where: { $0.isFront == 1})?.documentPath ?? ""
    registrationCertificationBackUrl = data.registrationCertificate?.first(where: { $0.isFront == 0})?.documentPath ?? ""
    
    // MARK: - Show Images
    profileImageView.setImage(with: data.profilePic)
    
    vehicleImageFrontImageView.setImage(with: data.vehicleImage?.first(where: { $0.isFront == 1})?.documentPath ?? "frontUpload")
    vehicleImageBackImageView.setImage(with: data.vehicleImage?.first(where: { $0.isFront == 0})?.documentPath ?? "backUpload")
    
    identityProofFrontImageView.setImage(with: data.identityProof?.first(where: { $0.isFront == 1})?.documentPath ?? "frontUpload")
    identityProofBackImageView.setImage(with: data.identityProof?.first(where: { $0.isFront == 0})?.documentPath ?? "backUpload")
    
    drivingLcenseFrontImageView.setImage(with: data.drivingLicense?.first(where: { $0.isFront == 1})?.documentPath ?? "frontUpload")
    drivingLcenseBackImageView.setImage(with: data.drivingLicense?.first(where: { $0.isFront == 0})?.documentPath ?? "backUpload")
    
    vehicleInsuranceImageView.setImage(with: data.vehicleInsurance?.first?.documentPath ?? "frontUpload")
    //        pollutionPaperImageView.setImage(with: data.pollutionPaper?.first?.documentPath ?? "frontUpload")
    //
    //        registrationCertificationFrontImagViw.setImage(with: data.registrationCertificate?.first(where: { $0.isFront == 1})?.documentPath ?? "frontUpload")
    //        registrationCertificationBackImagViw.setImage(with: data.registrationCertificate?.first(where: { $0.isFront == 0})?.documentPath ?? "backUpload")
    
    pollutionPaperImageView.setOrPlaceholderImage(
      path: data.pollutionPaper?.first?.documentPath,
      placeholder: "frontUpload"
    )
    
    registrationCertificationFrontImagViw.setOrPlaceholderImage(
      path: data.registrationCertificate?.first(where: { $0.isFront == 1 })?.documentPath,
      placeholder: "frontUpload"
    )
    
    registrationCertificationBackImagViw.setOrPlaceholderImage(
      path: data.registrationCertificate?.first(where: { $0.isFront == 0 })?.documentPath,
      placeholder: "backUpload"
    )
  }
  
  
  
}

extension AddNewDriverViewController: UITextFieldDelegate {
  
  func textField(_ textField: UITextField,
                 shouldChangeCharactersIn range: NSRange,
                 replacementString string: String) -> Bool {
    
    let currentText = (textField.text! as NSString).replacingCharacters(in: range, with: string)
    
    // Allow deletion
    if string.isEmpty { return true }
    
    // Block leading space for all fields
    if currentText.hasPrefix(" ") { return false }
    
    // Fields that allow spaces
    let fieldsAllowingSpaces: [UITextField] = [
      fullNameInEnglishTF,
      fullNameInArabicTF,
      addressLineOneTF,
      addressLineTwoTF,
      cityTF,
      stateTF,
      vehicleNameTF,
      vehicleeRegistrationTF
    ]
    
    // Arabic field validation
    if textField == fullNameInArabicTF {
      let allowedSet = CharacterSet(charactersIn: "\u{0600}"..."\u{06FF}")
        .union(CharacterSet(charactersIn: "\u{0750}"..."\u{077F}"))
        .union(CharacterSet(charactersIn: "\u{08A0}"..."\u{08FF}"))
        .union(CharacterSet.whitespaces)
      
      for scalar in string.unicodeScalars {
        if !allowedSet.contains(scalar) {
          CommonUtils.showToast(message: "Please switch to Arabic keyboard")
          return false
        }
      }
      return true
    }
    
    if textField == fullNameInEnglishTF {
      let allowedSet = CharacterSet.letters.union(.whitespaces)
      for scalar in string.unicodeScalars {
        if !allowedSet.contains(scalar) {
          return false
        }
      }
      return true
    }
    
    
    // Block spaces in other fields except the allowed ones
    if !fieldsAllowingSpaces.contains(textField) {
      if string.contains(" ") {
        return false
      }
    }
    
    var validation: StringValidation?
    
    if textField == self.emailTF {
      if currentText.hasPrefix(" ") {
        return false
      }
      validation = StringValidation(string: currentText,
                                    characterCount: 65,
                                    validation: .emailId)
    }
    if textField == self.mobileTF {
      if currentText.hasPrefix(" ") {
        return false
      }
      validation = StringValidation(string: currentText,
                                    characterCount: 15,
                                    validation: .mobileNo)
    }
    
    
    if let data = validation {
      return data.validate()
    } else {
      return true
    }
    
  }
}

extension UIImageView {
  func setOrPlaceholderImage(path: String?, placeholder: String) {
    if let urlString = path, !urlString.trimmingCharacters(in: .whitespaces).isEmpty {
      self.setImage(with: urlString)
    } else {
      self.image = UIImage(named: placeholder)
    }
  }
}
