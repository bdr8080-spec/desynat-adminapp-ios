//
//  DriverDetailsViewController.swift
//  DesynatAdmin
//
//  Created by fluper on 21/11/25.
//

import UIKit

class DriverDetailsViewController: UIViewController {
    
    // MARK: - IBOutlet's
    @IBOutlet weak var registrtionCertificateView: UIView!
    @IBOutlet weak var pollutionCertificateView: UIView!
    @IBOutlet weak var profileImageView: CustomImageView!
    @IBOutlet weak var fullNameInEnglishLabel: UILabel!
    @IBOutlet weak var mobileLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var zoneLabel: UILabel!
    @IBOutlet weak var orderDeliveryLabel: UILabel!
    @IBOutlet weak var vehicleNameTF: UITextField!
    @IBOutlet weak var vehicleRegistrationTF: UITextField!
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
    
    // MARK: - Property Decalaration
    private lazy var viewModel = DriverDetailsViewModel(hostVC: self)
    var userId: Int = 0
    
    // MARK: - View's LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getDriverDetails()
    }
    
    // MARK: - Button's Action
    @IBAction func editDidTapped(_ sender: Any) {
        let vc = AddNewDriverViewController.instantiate(fromAppStoryboard: .ReasonManagement)
        vc.isComingForEdit = true
        vc.userId = userId
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    
    @IBAction func backDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func deleteDidTapped(_ sender: Any) {
        self.showConfirmationAlert(msg: "Are you sure you want to delete this user?") { [weak self] in
            guard let self = self else { return }
            let param: [String: Any] = ["user_id": userId]
            viewModel.deleteBoy(param: param)
        }
    }
    
    //MARK: Function's declaration
    func configData(data: DeliveryBoysList) {
        // MARK: - Text Fields
        fullNameInEnglishLabel.text = data.fullNameEnglish
        emailLabel.text = data.email
        mobileLabel.text = "\(data.countryCode ?? "0") \(data.mobile ?? "")"
        
        addressLabel.text = [
            data.addressLine1,
            data.addressLine2,
            data.city,
            data.state
        ]
            .compactMap { $0 }
            .filter { !$0.isEmpty }
            .joined(separator: ", ")
        
        vehicleNameTF.text = data.vehicleName
        vehicleRegistrationTF.text = data.vehicleRegNo
        zoneLabel.text = data.zoneInfo?.nameEnglish
        
        // MARK: - Show Images
        profileImageView.setImage(with: data.profilePic)
        
        vehicleImageFrontImageView.setImage(with: data.vehicleImage?.first(where: { $0.isFront == 1})?.documentPath)
        vehicleImageBackImageView.setImage(with: data.vehicleImage?.first(where: { $0.isFront == 0})?.documentPath)
        
        identityProofFrontImageView.setImage(with: data.identityProof?.first(where: { $0.isFront == 1})?.documentPath)
        identityProofBackImageView.setImage(with: data.identityProof?.first(where: { $0.isFront == 0})?.documentPath)
        
        drivingLcenseFrontImageView.setImage(with: data.drivingLicense?.first(where: { $0.isFront == 1})?.documentPath ?? "")
        drivingLcenseBackImageView.setImage(with: data.drivingLicense?.first(where: { $0.isFront == 0})?.documentPath ?? "")
        
        vehicleInsuranceImageView.setImage(with: data.vehicleInsurance?.first?.documentPath)
        let pollutionUrl = data.pollutionPaper?.first?.documentPath ?? ""
        
        pollutionCertificateView.isHidden = pollutionUrl.isEmpty
        
        pollutionPaperImageView.setImage(with: data.pollutionPaper?.first?.documentPath)
        
        let registrationURL = data.registrationCertificate?.first(where: { $0.isFront == 1})?.documentPath ?? ""
        registrtionCertificateView.isHidden = registrationURL.isEmpty
        registrationCertificationFrontImagViw.setImage(with: data.registrationCertificate?.first(where: { $0.isFront == 1})?.documentPath)
        registrationCertificationBackImagViw.setImage(with: data.registrationCertificate?.first(where: { $0.isFront == 0})?.documentPath)
    }
    
}
