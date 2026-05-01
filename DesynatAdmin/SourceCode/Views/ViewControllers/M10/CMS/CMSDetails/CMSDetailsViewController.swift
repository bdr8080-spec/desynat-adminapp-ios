//
//  CMSDetailsViewController.swift
//  DesynatAdmin
//
//  Created by fluper_mac3 on 16/03/26.
//

import UIKit
import WebKit

class CMSDetailsViewController: UIViewController {
    
    // MARK: - IBOutlet's
    @IBOutlet weak var contentView: WKWebView!
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: - Property Decalaration
    private lazy var viewModel = CMSDetailsViewModel(hostVC: self)
    var selectedUserType = 1
    var cmsType: CmsArray = .returnPolicy
    var comingForArabic: Bool = false
    var termsAndConditonData: CMSTermsConditionDataModel?
    
    // MARK: - View's LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        handleUI()
    }
    
    // MARK: - Button's Action
    @IBAction func backDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    //MARK: Function's declaration
    private func handleUI() {
        switch cmsType {
        case .termsAndCondition:
            titleLabel.text = "Terms & Condition".localiz()
        case .returnPolicy:
            titleLabel.text = "Return Policy".localiz()
        case .aboutUs:
            titleLabel.text = "About Us".localiz()
        case .cancellationPolicy:
            titleLabel.text = "Cancellation Policy".localiz()
        default:
            titleLabel.text = "Exchange Policy".localiz()
        }
        if comingForArabic {
            CommonUtils.loadHTMLContent(termsAndConditonData?.contentArabic ?? "N/A", webView: contentView)
            
        } else {
            CommonUtils.loadHTMLContent(termsAndConditonData?.contentEnglish ?? "N/A", webView: contentView)
        }
    }
}
