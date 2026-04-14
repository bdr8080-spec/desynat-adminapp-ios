//
//  AuthenticationServices.swift
//  CruzeUserApp
//

import Foundation
import UIKit
import Alamofire

extension WebService {
    
    static let shared = WebService()
    
    func verifyOTPService(withParams dictParams: Dictionary<String, Any>, completion: @escaping (_ user: UserModel) -> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.verifyOTP), requestMethod: .post, requestParams: dictParams, encoding: JSONEncoding.default, requestModel: UserModel.self) { result, code in
            CommonUtils.showHud(show: false)
            self.evaluateWebServiceResponse(response: result) { response, message, error in
                if let error {
                    UIApplication.shared.topViewController()?.showAlert(msg: error)
                } else if let response {
                    completion(response)
                }
            }
        }
    }
    
    func loginUserService(withParams dictParams: Dictionary<String, Any>, completion: @escaping (_ user: UserModel) -> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.loginUser), requestMethod: .post, requestParams: dictParams, encoding: JSONEncoding.default, requestModel: UserModel.self) { result, code in
            CommonUtils.showHud(show: false)
            self.evaluateWebServiceResponse(response: result) { response, message, error in
                if let error {
                    UIApplication.shared.topViewController()?.showAlert(msg: error)
                } else if let response {
                    Global.shared.user = response
                    kSharedUserDefaults.saveModelFor(key: .user, value: response)
                    kSharedUserDefaults.saveStringFor(Key: .accessToken, value: String.getString(response.accessToken))
                    kSharedUserDefaults.setUserLoggedIn(userLoggedIn: true)
                    CommonUtils.showToast(message: "Login Succesfully")
                    completion(response)
                }
            }
        }
    }
    
    func forgotPasswordService(withParams dictParams: Dictionary<String, Any>, completion: @escaping (_ user: UserModel) -> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.forgotPassword), requestMethod: .post, requestParams: dictParams, encoding: JSONEncoding.default, requestModel: UserModel.self) { result, code in
            CommonUtils.showHud(show: false)
            self.evaluateWebServiceResponse(response: result) { response, message, error in
                if let error {
                    UIApplication.shared.topViewController()?.showAlert(msg: error)
                } else if let response {
                    CommonUtils.showToastForOTP(message: "OTP sent to your email address succesfully")
                    completion(response)
                }
            }
        }
    }
    
    func createPasswordService(withParams dictParams: Dictionary<String, Any>, completion: @escaping (_ user: UserModel) -> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.createPassword), requestMethod: .post, requestParams: dictParams, encoding: JSONEncoding.default, requestModel: UserModel.self) { result, code in
            CommonUtils.showHud(show: false)
            self.evaluateWebServiceResponse(response: result) { response, message, error in
                if let error {
                    UIApplication.shared.topViewController()?.showAlert(msg: error)
                } else if let response {
                    completion(response)
                }
            }
        }
    }
    
    func resendOTPService(withParams dictParams: Dictionary<String, Any>, completion: @escaping (_ user: UserModel) -> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.resendOTP), requestMethod: .post, requestParams: dictParams, encoding: JSONEncoding.default, requestModel: UserModel.self) { result, code in
            CommonUtils.showHud(show: false)
            self.evaluateWebServiceResponse(response: result) { response, message, error in
                if let error {
                    UIApplication.shared.topViewController()?.showAlert(msg: error)
                } else if let response {
                    CommonUtils.showToastForOTP(message: message ?? "OTP Sent Successfully")
                    completion(response)
                }
            }
        }
    }
    
}
