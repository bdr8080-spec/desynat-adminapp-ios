//
//  ForgotPasswordViewController.swift
//  DesynatUser
//
//  Created by Rakhi Kumari on 23/10/25.
//

import UIKit

class ForgotPasswordViewController: UIViewController {
    
    // MARK: - IBOutlet's
    @IBOutlet weak var emailAddressTextField: UITextField!
    
    // MARK: - Property Decalaration
    private lazy var viewModel = ForgotPasswordViewModel(hostVC: self)
    
    // MARK: - View's LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        emailAddressTextField.delegate = self
    }
    
    // MARK: - Button's Action
    @IBAction func continueDidTapped(_ sender: Any) {
        if viewModel.validFields() {
            viewModel.forgotPasswordApi()
        }
    }
    
    @IBAction func backDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

//MARK: UITextFieldDelegate Methods
extension ForgotPasswordViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        
        // Safely unwrap the current text
        guard let currentText = textField.text else { return true }
        
        // Construct the updated text after the change
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: string)
        
        // Prevent leading space
        if updatedText.hasPrefix(" ") {
            return false
        }
        
        var validation: StringValidation?
        
        // Validate email
        if textField == emailAddressTextField {
            validation = StringValidation(string: updatedText, characterCount: 55, validation: .emailId)
        }
        
        // Perform validation if applicable
        if let validation = validation {
            return validation.validate()
        }
        
        return true
    }
}
