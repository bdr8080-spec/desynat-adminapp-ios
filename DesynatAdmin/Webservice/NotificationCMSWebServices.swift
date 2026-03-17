//
//  NotificationCMSWebServices.swift
//  DesynatAdmin
//
//  Created by fluper_mac3 on 16/03/26.
//

import Foundation
import UIKit
import Alamofire
extension WebService {
    
    func getTermsConditionService(parameter:[String:Any],completion: @escaping(CMSTermsConditionDataModel) -> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.getTermsCondition),requestMethod: .get, requestParams: parameter,requestModel: CMSTermsConditionDataModel.self) { result, code in
            CommonUtils.showHud(show: false)
            self.evaluateWebServiceResponse(response: result) { response, message, error in
                guard let response = response else {
                    if let error {
                        UIApplication.shared.topViewController()?.showAlert(msg: error)
                    }
                    return
                }
                completion(response)
            }
        }
    }
    
    func getReturnPolicyService(parameter:[String:Any],completion: @escaping(CMSTermsConditionDataModel) -> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.getReturnPolicy),requestMethod: .get, requestParams: parameter,requestModel: CMSTermsConditionDataModel.self) { result, code in
            CommonUtils.showHud(show: false)
            self.evaluateWebServiceResponse(response: result) { response, message, error in
                guard let response = response else {
                    if let error {
                        UIApplication.shared.topViewController()?.showAlert(msg: error)
                    }
                    return
                }
                completion(response)
            }
        }
    }
    
    func getAboutUsPolicyService(parameter:[String:Any],completion: @escaping(CMSTermsConditionDataModel) -> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.getAboutUs),requestMethod: .get, requestParams: parameter,requestModel: CMSTermsConditionDataModel.self) { result, code in
            CommonUtils.showHud(show: false)
            self.evaluateWebServiceResponse(response: result) { response, message, error in
                guard let response = response else {
                    if let error {
                        UIApplication.shared.topViewController()?.showAlert(msg: error)
                    }
                    return
                }
                completion(response)
            }
        }
    }
    
    func getCancellationPolicyService(parameter:[String:Any],completion: @escaping(CMSTermsConditionDataModel) -> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.getCancellationPolicy),requestMethod: .get, requestParams: parameter,requestModel: CMSTermsConditionDataModel.self) { result, code in
            CommonUtils.showHud(show: false)
            self.evaluateWebServiceResponse(response: result) { response, message, error in
                guard let response = response else {
                    if let error {
                        UIApplication.shared.topViewController()?.showAlert(msg: error)
                    }
                    return
                }
                completion(response)
            }
        }
    }
    
    func getExchangePolicyService(parameter:[String:Any],completion: @escaping(CMSTermsConditionDataModel) -> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.getExchangePolicy),requestMethod: .get, requestParams: parameter,requestModel: CMSTermsConditionDataModel.self) { result, code in
            CommonUtils.showHud(show: false)
            self.evaluateWebServiceResponse(response: result) { response, message, error in
                guard let response = response else {
                    if let error {
                        UIApplication.shared.topViewController()?.showAlert(msg: error)
                    }
                    return
                }
                completion(response)
            }
        }
    }
    
    func getContactUsService(parameter:[String:Any],completion: @escaping(ContactUsDataModel) -> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.getContacts),requestMethod: .get, requestParams: parameter,requestModel: ContactUsDataModel.self) { result, code in
            CommonUtils.showHud(show: false)
            self.evaluateWebServiceResponse(response: result) { response, message, error in
                guard let response = response else {
                    if let error {
                        UIApplication.shared.topViewController()?.showAlert(msg: error)
                    }
                    return
                }
                completion(response)
            }
        }
    }
    
    func getFaqService(parameter:[String:Any],completion: @escaping([FAQListDataModel]) -> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.getFAQ),requestMethod: .get, requestParams: parameter,requestModel: [FAQListDataModel].self) { result, code in
            CommonUtils.showHud(show: false)
            self.evaluateWebServiceResponse(response: result) { response, message, error in
                guard let response = response else {
                    if let error {
                        UIApplication.shared.topViewController()?.showAlert(msg: error)
                    }
                    return
                }
                completion(response)
            }
        }
    }
    
    func getSentNotificationsListService(parameter:[String:Any], completion: @escaping(NotificationsListDataModel) -> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.getSentNotificationsList),requestMethod: .get, requestParams: parameter,requestModel: NotificationsListDataModel.self) { result, code in
            CommonUtils.showHud(show: false)
            self.evaluateWebServiceResponse(response: result) { response, message, error in
                guard let response = response else {
                    if let error {
                        UIApplication.shared.topViewController()?.showAlert(msg: error)
                    }
                    return
                }
                completion(response)
            }
        }
    }
    
    func getMyNotificationsListService(completion: @escaping([NotificationsList]) -> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.getMyNotificationsList),requestMethod: .get, requestModel: [NotificationsList].self) { result, code in
            CommonUtils.showHud(show: false)
            self.evaluateWebServiceResponse(response: result) { response, message, error in
                guard let response = response else {
                    if let error {
                        UIApplication.shared.topViewController()?.showAlert(msg: error)
                    }
                    return
                }
                completion(response)
            }
        }
    }
    
    func markReadNotificationsService(completion: @escaping(EmptyModel) -> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.markReadNotifications),requestMethod: .post, requestModel: EmptyModel.self) { result, code in
            CommonUtils.showHud(show: false)
            self.evaluateWebServiceResponse(response: result) { response, message, error in
                guard let response = response else {
                    if let error {
                        UIApplication.shared.topViewController()?.showAlert(msg: error)
                    }
                    return
                }
                completion(response)
            }
        }
    }
    
    func sendNotificationsService(parameter:[String:Any], completion: @escaping(EmptyModel) -> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.sendNotifications), requestMethod: .post, requestParams: parameter, requestModel: EmptyModel.self) { result, code in
            CommonUtils.showHud(show: false)
            self.evaluateWebServiceResponse(response: result) { response, message, error in
                guard let response = response else {
                    if let error {
                        UIApplication.shared.topViewController()?.showAlert(msg: error)
                    }
                    return
                }
                completion(response)
            }
        }
    }
}
