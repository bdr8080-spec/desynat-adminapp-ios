//
//  RejectReasonPopupViewController.swift
//  DesynatAdmin
//
//  Created by fluper on 16/12/25.
//

import UIKit

class RejectReasonPopupViewController: UIViewController {
    
    // MARK: - IBOutlet's
    @IBOutlet weak var reasonTextView: UITextView!
    @IBOutlet weak var headerView: UIView!
    
    // MARK: - Property Decalaration
    private lazy var viewModel = RejectReasonPopupViewModel(hostVC: self)
    var onChangesAreDone: ((String) -> Void)?
    
    // MARK: - View's LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        handleUISetup()
    }
    
    // MARK: - Button's Action
    @IBAction func saveChangesDidTapped(_ sender: Any) {
        if (self.reasonTextView.text.isEmpty) {
            self.showAlert(msg: "Please enter reason")
            return
        }
        self.reasonTextView.becomeFirstResponder()
        self.dismiss(animated: true) {
            self.onChangesAreDone?(self.reasonTextView.text)
        }
    }
    
    @IBAction func dismissDidTapepd(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    //MARK: Function's declaration
    private func handleUISetup() {
        headerView.layer.cornerRadius = 24
        headerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        headerView.clipsToBounds = true
    }
    
}
