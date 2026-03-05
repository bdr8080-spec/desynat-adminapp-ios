//
//  ResetPasswordViewController.swift
//  DesynatUser
//
//  Created by Rakhi Kumari on 23/10/25.
//

import UIKit

class ResetPasswordViewController: UIViewController {
    
    // MARK: - IBOutlet's
    @IBOutlet weak var createPasswordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    // MARK: - Property Decalaration
    lazy private var viewModel = ResetPasswordViewModel(hostVC: self)
    var userId: String? = ""
    
    // MARK: - View's LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        confirmPasswordTextField.delegate = self
        createPasswordTextField.delegate = self
    }
    
    // MARK: - Button's Action
    @IBAction func doneDidTapped(_ sender: Any) {
        if viewModel.validFields() {
            viewModel.resetPasswordOTPApi()
        }
    }
    
    @IBAction func backDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnTapCreatePasswordEye(_ sender: UIButton) {
        sender.isSelected.toggle()
        createPasswordTextField.isSecureTextEntry.toggle()
    }
    
    @IBAction func btnTapConfirmPasswordEye(_ sender: UIButton) {
        sender.isSelected.toggle()
        confirmPasswordTextField.isSecureTextEntry.toggle()
    }
    
}
