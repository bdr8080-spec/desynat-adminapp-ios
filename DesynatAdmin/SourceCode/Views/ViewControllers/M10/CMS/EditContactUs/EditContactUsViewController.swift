//
//  EditContactUsViewController.swift
//  DesynatAdmin
//
//  Created by fluper_mac3 on 18/03/26.
//

import UIKit

class EditContactUsViewController: UIViewController {

    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var inputTF: UITextField!
    
    var comingReason: ComingReasonAtContactEdit = .email
    private lazy var viewModel = EditContactUsViewModel(hostVC: self)
    var selectedUserType = 1
    var contactListData: ContactUsDataModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        handleUISetup()
        switch comingReason {
        case .email:
            titleLabel.text = "Support Email Address"
            headerLabel.text = "Edit Support Email Address"
            inputTF.text = contactListData?.contentEnglish?.email
        case .phoneNumber:
            titleLabel.text = "Support Contact Number"
            headerLabel.text = "Edit Support Contact Number"
            inputTF.text = contactListData?.contentEnglish?.mobile
        case .whatsApp:
            titleLabel.text = "Support Whatsapp Number"
            headerLabel.text = "Edit Support Whatsapp Number"
            inputTF.text = contactListData?.contentEnglish?.whatsapp
        }
    }
    
    @IBAction func dismissDidTapepd(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func submitDidTapped(_ sender: Any) {
        if viewModel.validFields() {
            viewModel.updateFAQRequest()
        }
    }
    
    //MARK: Function's declaration
    private func handleUISetup() {
        headerView.layer.cornerRadius = 24
        headerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        headerView.clipsToBounds = true
    }
}

enum ComingReasonAtContactEdit {
    case email
    case whatsApp
    case phoneNumber
}
