//
//  LoginViewModel.swift
//  DesynatUser
//
//  Created by Rakhi Kumari on 28/10/25.
//


import Foundation
import UIKit

class LoginViewModel: NSObject {
    
    private var loginHostVC: LoginViewController
    
    init(loginHostVC: LoginViewController) {
        self.loginHostVC = loginHostVC
    }
    
    func validFields() -> Bool {
        var errorMessage: AlertConstant = .none
        let input = String.getString(loginHostVC.emailTextField.text).trimmingCharacters(in: .whitespacesAndNewlines)
        
        if input.isEmpty {
            errorMessage = .EnterEmailAddress
        } else if input.isEmail() {
            if !input.isValidEmail() {
                errorMessage = .EnterValidEmailAddress
            }
        } else if input.isPhoneNumber() {
            if !input.isValidPhoneNumber() {
                errorMessage = .validMobileNumber
            }
        } else {
            errorMessage = .EnterValidEmail
        }
        
        let password = String.getString(loginHostVC.passwordTextField.text).trimmingCharacters(in: .whitespacesAndNewlines)
        
        if errorMessage == .none {
            if password.isEmpty {
                errorMessage = .EnterPassword
            }
        }
        
        if errorMessage != .none {
            loginHostVC.showAlert(msg: errorMessage.rawValue)
        }
        
        loginHostVC.view.endEditing(true)
        return errorMessage == .none
    }
    
    func loginApi() {
        let params: [String:Any] = [
            "device_type": 1,//0 web 1 ios 2 andriod
            "fcm_token": kSharedUserDefaults.retrieveModelFor(key: .deviceToken, model: String.self) ?? "",
            "email": loginHostVC.emailTextField.text?.trimmed() ?? "",
            "password": loginHostVC.passwordTextField.text?.trimmed() ?? ""]
        WebService.sharedInstance.loginUserService(withParams: params) { response in
            if response.type == "2" {
                self.getStaffDetails(userId: response.id ?? 0)
            } else {
                kSharedSceneDelegate.navigateToUserHomeVc()
            }
        }
    }
    
    func getStaffDetails(userId: Int) {
        let param: [String:Any] = ["id": userId]
        WebService.shared.getSubAdminProfileDetailsService(param: param) { [weak self] response in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if response.permissionDetails?.first?.moduleID == 1 {
                    kSharedUserDefaults.setSubAdminUserHasDashboardAccess(hasDashboardAccess: true)
                    if response.permissionDetails?.first?.moduleID == 1 && response.permissionDetails?.first?.canAction == 1 {
                        kSharedUserDefaults.setSubAdminActionDashboardAccess(hasActionDashboardAccess: true)
                    }
                    kSharedSceneDelegate.navigateToUserHomeVc()
                } else {
                    kSharedSceneDelegate.navigateToSideMenuVc()
                }
            }
        }
    }
}

