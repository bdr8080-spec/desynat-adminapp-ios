//
//  LoginViewController.swift
//  DesynatUser
//
//  Created by Rakhi Kumari on 23/10/25.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    
    private lazy var viewModel = LoginViewModel(loginHostVC: self)
//    var countryCode: String = LocationManager.sharedInstance.getCurrentLocationCode().dialCode
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTextField.isSecureTextEntry = true
        passwordTextField.delegate = self
        emailTextField.delegate = self
    }
    

    @IBAction func loginDidTapped(_ sender: Any) {
        if viewModel.validFields() {
            viewModel.loginApi()
        }
    }
    
    @IBAction func forgotPasswordDidTapped(_ sender: Any) {
        let vc = ForgotPasswordViewController.instantiate(fromAppStoryboard: .Main)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    

    @IBAction func passwordEyeToggle(_ sender: UIButton) {
        sender.isSelected.toggle()
        passwordTextField.isSecureTextEntry.toggle()
    }
    
    
}

extension LoginViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let currentText = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        var validation: StringValidation?
        
        if textField == self.emailTextField {
            if currentText.hasPrefix(" ") {
                return false
            }
            
            validation = StringValidation(string: currentText, characterCount: 55, validation: .emailId)
    
            if let data = validation {
                return data.validate()
            } else {
                return true
            }
        }
        return true
    }
}
