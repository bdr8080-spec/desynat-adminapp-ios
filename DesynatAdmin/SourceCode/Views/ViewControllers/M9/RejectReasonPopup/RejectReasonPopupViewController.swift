//
//  RejectReasonPopupViewController.swift
//  DesynatAdmin
//
//  Created by fluper on 16/12/25.
//

import UIKit

class RejectReasonPopupViewController: UIViewController {
    
    @IBOutlet weak var reasonTextView: UITextView!
    @IBOutlet weak var headerView: UIView!
    
    private lazy var viewModel = RejectReasonPopupViewModel(hostVC: self)
    var onChangesAreDone: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        handleUISetup()
    }
    
    @IBAction func saveChangesDidTapped(_ sender: Any) {
        onChangesAreDone?()
        self.dismiss(animated: true)
    }
    
    @IBAction func dismissDidTapepd(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    private func handleUISetup() {
        headerView.layer.cornerRadius = 24
        headerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        headerView.clipsToBounds = true
    }
    
}
