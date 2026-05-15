//
//  AffiliatedUserDetailsViewController.swift
//  DesynatAdmin
//
//  Created by fluper_mac3 on 22/01/26.
//

import UIKit
import SDWebImage

class AffiliatedUserDetailsViewController: UIViewController {
    
    // MARK: - IBOutlet's
    @IBOutlet weak var swiftView: UIView!
    @IBOutlet weak var ibanView: UIView!
    @IBOutlet weak var accountTypeLabel: UILabel!
    @IBOutlet weak var statusToggleButton: UIButton!
    @IBOutlet weak var rejectTypeLabel: UILabel!
    @IBOutlet weak var buttonActionStackView: UIStackView!
    @IBOutlet weak var proofOfDocumentImageView: CustomImageView!
    @IBOutlet weak var accountHolderNameLabel: UILabel!
    @IBOutlet weak var bankNameLabel: UILabel!
    @IBOutlet weak var swiftBICLabel: UILabel!
    @IBOutlet weak var ibanLabel: UILabel!
    @IBOutlet weak var secondDocumentImageView: CustomImageView!
    @IBOutlet weak var firstDocumentImageView: CustomImageView!
    @IBOutlet weak var addressLaebl: UILabel!
    @IBOutlet weak var toggleViewstatusLabel: UILabel!
    @IBOutlet weak var toggleOnOffView: UIView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var approvedStackView: UIStackView!
    @IBOutlet weak var rejectedStackView: UIStackView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var mobileLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var joinedDateLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var totalOrdersLabel: UILabel!
    @IBOutlet weak var totalEarningsLabel: UILabel!
    @IBOutlet weak var reasonLabel: UILabel!
    
    // MARK: - Property Decalaration
    var userType: AffiliatedUsersListType = .newUsers
    private lazy var viewModel = AffiliatedUserDetailsViewModel(hostVC: self)
    var userId: Int? = 0
    var hasActionPermission: Bool = false
    
    // MARK: - View's LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        initailSetupUI()
        statusToggleButton.isUserInteractionEnabled = hasActionPermission
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getAffilitaedUserDetails()
    }
    
    // MARK: - Button's Action
    @IBAction func statusToggleDidTapped(_ sender: Any) {
        viewModel.upadteUserStatus(param: ["user_id": userId ?? 0])
    }
    
    @IBAction func backDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func rejectDidTapped(_ sender: Any) {
        let vc = RejectReasonViewController.viewFromNIB
        vc.needToShowButtonStackView = true
        vc.setCallback { reason,type in
            let param: [String: Any] = ["user_id": self.userId ?? 0,
                                        "reject_type": type.paramterValue,
                                        "reject_reason": reason]
            self.viewModel.RejectUserRequest(param: param)
            vc.dismiss(animated: false)
            self.userType = .rejectedUsers
            self.initailSetupUI()
        }
        self.presentVC(vc,withAnimation: false,modalPresentationStyle: .overCurrentContext)
    }
    
    @IBAction func acceptDidTapped(_ sender: Any) {
        let param: [String: Any] = ["user_id": self.userId ?? 0]
        viewModel.AcceptUserRequest(param: param)
    }
    
    //MARK: Function's declaration
    func initailSetupUI() {
        approvedStackView.isHidden = true
        rejectedStackView.isHidden = true
        statusLabel.isHidden = true
        toggleOnOffView.isHidden = true
        buttonActionStackView.isHidden = true
        switch userType {
        case .newUsers:
            statusLabel.isHidden = false
            buttonActionStackView.isHidden = !hasActionPermission
        case .approvedUsers:
            approvedStackView.isHidden = false
            toggleOnOffView.isHidden = false
        case .rejectedUsers:
            rejectedStackView.isHidden = false
        }
    }
    
    func configUserData(userData: AffilitaitedUsersDataModel?) {
        guard let data = userData else { return }
        if let imageUrlString = data.profileImage,
           let url = URL(string: imageUrlString) {
            profileImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            profileImageView.sd_imageIndicator?.startAnimatingIndicator()
            profileImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "userProfile"))
        } else {
            profileImageView.image = UIImage(named: "userProfile")
        }
        usernameLabel.text = data.fullName
        countryLabel.text = AppLanguageManager.shared.currentLanguage == .ar ? data.countryDetails?.nameAr : data.countryDetails?.name
        joinedDateLabel.text = "\("Joined on".localiz()) \(convertISOToDMY(data.createdAt ?? "") ?? "")"
        mobileLabel.text = "\(data.countryCode ?? "")-\(data.mobile ?? "")"
        emailLabel.text = data.email
        //        totalOrdersLabek.text = data.or
        //        totalEarningsLabel.text = data.ea
        reasonLabel.text = data.rejectReason
        firstDocumentImageView.enableFullscreenZoom()
        secondDocumentImageView.enableFullscreenZoom()
        if data.adminVerify == "3" {
            rejectTypeLabel.text = "Complete Rejected".localiz()
        } else if data.adminVerify == "4" {
            rejectTypeLabel.text = "Document Rejected".localiz()
        }
        if data.status == "1" {
            toggleViewstatusLabel.text = "Active".localiz()
            statusToggleButton.setImage(UIImage(named: "toggleOn"), for: .normal)
        } else {
            toggleViewstatusLabel.text = "Inactive".localiz()
            statusToggleButton.setImage(UIImage(named: "toggleOff"), for: .normal)
        }
        addressLaebl.text = data.addressDetails?.locations//data.addressDetails?.fullAddress
        
        firstDocumentImageView.setImage(with: data.document1)
        secondDocumentImageView.setImage(with: data.document2)
        proofOfDocumentImageView.setImage(with: data.bankDetails?.first?.uploadProof)
        
        let type = data.bankDetails?.first?.accountType ?? "0"
        if type == "0" {
            accountTypeLabel.text = "Personal".localiz()
        } else {
            accountTypeLabel.text = "Business".localiz()
        }
        
        if let iban = data.bankDetails?.first?.iban, !iban.isEmpty {
            ibanView.isHidden = false
            ibanLabel.text = iban
        } else {
            ibanView.isHidden = true
        }
        
        if let swift = data.bankDetails?.first?.swift, !swift.isEmpty {
            swiftView.isHidden = false
            swiftBICLabel.text = swift
        } else {
            swiftView.isHidden = true
        }
        bankNameLabel.text = data.bankDetails?.first?.bankName
        accountHolderNameLabel.text = data.bankDetails?.first?.accountHolderName
    }
    
    private func convertISOToDMY(_ isoString: String) -> String? {
        // ISO8601 parser
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        // Parse to Date
        guard let date = isoFormatter.date(from: isoString) else {
            return nil
        }
        
        // Output formatter
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "dd/MM/yyyy"
        
        return outputFormatter.string(from: date)
    }
}

