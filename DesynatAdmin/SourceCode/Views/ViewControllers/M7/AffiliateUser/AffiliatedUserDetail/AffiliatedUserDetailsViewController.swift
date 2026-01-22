//
//  AffiliatedUserDetailsViewController.swift
//  DesynatAdmin
//
//  Created by fluper_mac3 on 22/01/26.
//

import UIKit

class AffiliatedUserDetailsViewController: UIViewController {
    
    @IBOutlet weak var buttonActionStackView: UIStackView!
    @IBOutlet weak var proofOfDocumentImageView: CustomImageView!
    @IBOutlet weak var accountHolderNameLabel: UILabel!
    @IBOutlet weak var bankNameLabel: UILabel!
    @IBOutlet weak var swiftBICLabel: UILabel!
    @IBOutlet weak var ibanLabel: UILabel!
    @IBOutlet weak var accountTypeLabel: UILabel!
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
    
    var userType: AffiliatedUsersListType = .newUsers
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initailSetupUI()
    }
    
    @IBAction func statusToggleDidTapped(_ sender: Any) {
//        guard let brand = brandData else { return }
//        viewModel.upadteBrandStatus(param: ["brand_id": brand.id ?? 0])
    }
    
    @IBAction func backDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func rejectDidTapped(_ sender: Any) {
        let vc = RejectReasonViewController.viewFromNIB
        vc.needToShowButtonStackView = true
        vc.setCallback { reason,type in
//          let param: [String: Any] = ["request_id": data.id ?? 0,
//                                      "reject_reason": reason]
//          self.viewModel.rejectLiveRequest(param: param)
        }
        self.presentVC(vc,withAnimation: false,modalPresentationStyle: .overCurrentContext)
    }
    
    @IBAction func acceptDidTapped(_ sender: Any) {
        let vc = RegisterationSuccessViewController.instantiate(fromAppStoryboard: .Main)
        vc.comingReason = .AffiliateUserManagement
        vc.callBackDismiss = {
//            self.fetchAffiliatedUsersList()
        }
        self.navigationController?.present(vc, animated: true)
    }

    func initailSetupUI() {
        approvedStackView.isHidden = true
        rejectedStackView.isHidden = true
        statusLabel.isHidden = true
        toggleOnOffView.isHidden = true
        buttonActionStackView.isHidden = true
        switch userType {
        case .newUsers:
            statusLabel.isHidden = false
            buttonActionStackView.isHidden = false
        case .approvedUsers:
            approvedStackView.isHidden = false
            toggleOnOffView.isHidden = false
        case .rejectedUsers:
            rejectedStackView.isHidden = false
        }
    }
}
