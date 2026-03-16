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
    
    // MARK: - View's LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        switch cmsType {
        case .returnPolicy:
            viewModel.getReturnPolicyRequest()
        case .aboutUs:
            viewModel.getAboutUsRequest()
        case .cancellationPolicy:
            viewModel.getCancellationPolicyRequest()
        case .exchangePolicy:
            viewModel.getExchangePolicyRequest()
        default:
            viewModel.getReturnPolicyRequest()
        }
    }
    
    // MARK: - Button's Action
    @IBAction func backDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    //MARK: Function's declaration
    
}
