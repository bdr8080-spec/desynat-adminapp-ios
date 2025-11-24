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
        viewModel.getAllCountry()
        viewModel.getAllZone()
        if isComingForEdit {
            viewModel.getDriverDetails()
            titleLabel.text = "Edit Driver"
            buttonLabel.text = "Save Changes"
        } else {
            titleLabel.text = "Add New Driver"
            buttonLabel.text = "Add"
        }
//        passwordView.isHidden = isComingForEdit
//        confirmPassowrdView.isHidden = isComingForEdit
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
        
        vc.locationCallBack = { [weak self] address, locality, city, state, country, pincode, lat, long in
            guard let self = self else { return }
            
            // ✅ Safely unwrap each value with fallbacks
//            let safeAddress = address.isEmpty ? "" : address
            let safeLocality = locality.isEmpty ? "" : locality
            let safeCity = city.isEmpty ? "" : city
            let safeState = state.isEmpty ? "" : state
//            let safeCountry = country.isEmpty ? "" : country
            let safePincode = pincode.isEmpty ? "" : pincode
            
            // ✅ Assign values properly to all fields
            //           self.storeAddressTextField.text = safeAddress
            self.addressLineOneTF.text = safeLocality
            //            self.addressLineTwoTF.text = "\(safeCity), \(safeState) - \(safePincode)"
            var components: [String] = []
            
            if !safeCity.isEmpty {
                components.append(safeCity)
            }
            if !safeState.isEmpty {
                components.append(safeState)
            }
            
            var address = components.joined(separator: ", ")
            
            if !safePincode.isEmpty {
                address += " - \(safePincode)"
            }
            //
            self.addressLineTwoTF.text = address
            self.cityTF.text = safeCity
            self.stateTF.text = safeState
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
        ImagePickerManager().pickImage(self) { [weak self] image, fileName, url in
            guard let self = self else { return }
            let targetImageView = isFront ? self.vehicleImageFrontImageView : self.vehicleImageBackImageView
            let setUploadedUrl: (String) -> Void = { url in
                if isFront {
                    self.vehicleImageFrontImageUrl = url
                } else {
                    self.vehicleImageBackImageUrl = url
                }
            }
            DispatchQueue.main.async {
                targetImageView?.image = image
            }
            guard let compressed = image.jpegData(compressionQuality: 0.25),
                  let finalImage = UIImage(data: compressed) else { return }
            self.viewModel.uploadDocument(file: finalImage, isImage: true) { uploadedUrl in
                DispatchQueue.main.async {
                    setUploadedUrl(uploadedUrl)
                }
            }
        }
    }
    
    @IBAction func uplaodIdentityProofDidTapped(_ sender: UIButton) {
        let isFront = (sender.tag == 0)
        ImagePickerManager().pickImage(self) { [weak self] image, fileName, url in
            guard let self = self else { return }
            let targetImageView = isFront ? self.identityProofFrontImageView : self.identityProofBackImageView
            let setUploadedUrl: (String) -> Void = { url in
                if isFront {
                    self.identityProofFrontImageUrl = url
                } else {
                    self.identityProofBackImageUrl = url
                }
            }
            DispatchQueue.main.async {
                targetImageView?.image = image
            }
            guard let compressed = image.jpegData(compressionQuality: 0.25),
                  let finalImage = UIImage(data: compressed) else { return }
            self.viewModel.uploadDocument(file: finalImage, isImage: true) { uploadedUrl in
                DispatchQueue.main.async {
                    setUploadedUrl(uploadedUrl)
                }
            }
        }
    }
    
    @IBAction func drivingLicencseAction(_ sender: UIButton) {
        let isFront = (sender.tag == 0)
        ImagePickerManager().pickImage(self) { [weak self] image, fileName, url in
            guard let self = self else { return }
            let targetImageView = isFront ? self.drivingLcenseFrontImageView : self.drivingLcenseBackImageView
            let setUploadedUrl: (String) -> Void = { url in
                if isFront {
                    self.drivingLcenseFrontImageUrl = url
                } else {
                    self.drivingLcenseBackImagenUrl = url
                }
            }
            DispatchQueue.main.async {
                targetImageView?.image = image
            }
            guard let compressed = image.jpegData(compressionQuality: 0.25),
                  let finalImage = UIImage(data: compressed) else { return }
            self.viewModel.uploadDocument(file: finalImage, isImage: true) { uploadedUrl in
                DispatchQueue.main.async {
                    setUploadedUrl(uploadedUrl)
                }
            }
        }
    }
    
    @IBAction func vehicleInsuranceDidTapepd(_ sender: Any) {
        ImagePickerManager().pickImage(self) { [weak self] image, fileName, url in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.vehicleInsuranceImageView.image = image
            }
            guard let compressedImage = image.jpegData(compressionQuality: 0.25),
                  let finalImage = UIImage(data: compressedImage) else {
                return
            }
            self.viewModel.uploadDocument(file: finalImage, isImage: true) { [weak self] uploadedUrl in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.vehicleInsuranceImageUrl = uploadedUrl
                }
            }
        }
    }
    
    @IBAction func pollutionPaperImageDidTapped(_ sender: UIButton) {
        ImagePickerManager().pickImage(self) { [weak self] image, fileName, url in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.pollutionPaperImageView.image = image
            }
            guard let compressedImage = image.jpegData(compressionQuality: 0.25),
                  let finalImage = UIImage(data: compressedImage) else {
                return
            }
            self.viewModel.uploadDocument(file: finalImage, isImage: true) { [weak self] uploadedUrl in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.pollutionPaperImageUrl = uploadedUrl
                }
            }
        }
    }
    
    @IBAction func registrationCertificationDidTapped(_ sender: UIButton) {
        let isFront = (sender.tag == 0)
        ImagePickerManager().pickImage(self) { [weak self] image, fileName, url in
            guard let self = self else { return }
            let targetImageView = isFront ? self.registrationCertificationFrontImagViw : self.registrationCertificationBackImagViw
            let setUploadedUrl: (String) -> Void = { url in
                if isFront {
                    self.registrationCertificationFrontUrl = url
                } else {
                    self.registrationCertificationBackUrl = url
                }
            }
            DispatchQueue.main.async {
                targetImageView?.image = image
            }
            guard let compressed = image.jpegData(compressionQuality: 0.25),
                  let finalImage = UIImage(data: compressed) else { return }
            self.viewModel.uploadDocument(file: finalImage, isImage: true) { uploadedUrl in
                DispatchQueue.main.async {
                    setUploadedUrl(uploadedUrl)
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
      passwordTF.text = data.password
      confirmPasswordTF.text = data.password
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
        
        vehicleImageFrontImageView.setImage(with: data.vehicleImage?.first(where: { $0.isFront == 1})?.documentPath)
        vehicleImageBackImageView.setImage(with: data.vehicleImage?.first(where: { $0.isFront == 0})?.documentPath)
        
        identityProofFrontImageView.setImage(with: data.identityProof?.first(where: { $0.isFront == 1})?.documentPath)
        identityProofBackImageView.setImage(with: data.identityProof?.first(where: { $0.isFront == 0})?.documentPath)
        
        drivingLcenseFrontImageView.setImage(with: data.drivingLicense?.first(where: { $0.isFront == 1})?.documentPath ?? "")
        drivingLcenseBackImageView.setImage(with: data.drivingLicense?.first(where: { $0.isFront == 0})?.documentPath ?? "")
        
        vehicleInsuranceImageView.setImage(with: data.vehicleInsurance?.first?.documentPath)
        pollutionPaperImageView.setImage(with: data.pollutionPaper?.first?.documentPath)
        
        registrationCertificationFrontImagViw.setImage(with: data.registrationCertificate?.first(where: { $0.isFront == 1})?.documentPath)
        registrationCertificationBackImagViw.setImage(with: data.registrationCertificate?.first(where: { $0.isFront == 0})?.documentPath)
    }
    
    
}
