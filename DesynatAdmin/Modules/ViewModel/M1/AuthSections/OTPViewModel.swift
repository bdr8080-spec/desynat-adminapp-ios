//
//  OTPViewModel.swift
//  DesynatUser
//
//  Created by Rakhi Kumari on 30/10/25.
//

import Foundation
import UIKit

class OTPViewModel: NSObject {
    private var hostVC: OTPViewController
    
    init(hostVC: OTPViewController) {
        self.hostVC = hostVC
    }
    
    func verifyOtpAPI() {
        let params: [String: Any] = [
            "admin_id": hostVC.userId,
            "otp": hostVC.otpDigits
        ]
        
        WebService.sharedInstance.verifyOTPService(withParams: params) { otp in
            switch self.hostVC.comingReason {
            case .forgotPassword:
                let vc = ResetPasswordViewController.instantiate(fromAppStoryboard: .Main)
                vc.userId = self.hostVC.userId
                self.hostVC.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    func resendOtpAPI() {
        var params: [String: Any] = ["email": hostVC.phoneNumber ?? ""]
        WebService.sharedInstance.resendOTPService(withParams: params){ otp in
            
        }
    }
}
