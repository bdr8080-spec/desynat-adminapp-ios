//
//  ForgotPasswordViewModel.swift
//  DesynatUser
//
//  Created by Rakhi Kumari on 28/10/25.
//


import Foundation
import UIKit

class ForgotPasswordViewModel: NSObject {
    
    private var hostVC: ForgotPasswordViewController
    
    init(hostVC: ForgotPasswordViewController) {
        self.hostVC = hostVC
    }
    
    
    func validFields() -> Bool {
        var errorMessage: AlertConstant = .none
            let input = String.getString(hostVC.emailAddressTextField.text).trimmingCharacters(in: .whitespacesAndNewlines)
            if input.isEmpty {
                errorMessage = .EnterEmailAddress
            } else if !input.isValidEmail() {
                errorMessage = .EnterValidEmailAddress
            }
        
        if errorMessage != .none {
            hostVC.showAlert(msg: errorMessage.rawValue)
        }
        
        hostVC.view.endEditing(true)
        return errorMessage == .none
    }
    
    func forgotPasswordApi() {
        var params: [String: Any] = [:]
            

                params = [
                    "email": hostVC.emailAddressTextField.text?.trimmed() ?? ""
                ]
            
        WebService.sharedInstance.forgotPasswordService(withParams: params) { (response) in
            let vc = OTPViewController.instantiate(fromAppStoryboard: .Main)
            vc.comingReason = .forgotPassword
            vc.phoneNumber = self.hostVC.emailAddressTextField.text?.trimmed() ?? ""
            vc.userId = "\(response.id ?? 0)"
            self.hostVC.navigationController?.pushViewController(vc, animated: true)
        }
    }

}
