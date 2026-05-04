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
    
    func getMyNotificationsListService(param: [String:Any], completion: @escaping(NotificationsListDataModel) -> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.getMyNotificationsList),requestMethod: .get, requestParams: param, requestModel: NotificationsListDataModel.self) { result, code in
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
    
    func markReadNotificationsService(param: [String:Any], completion: @escaping(EmptyModel) -> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.markReadNotifications),requestMethod: .post, requestParams: param, requestModel: EmptyModel.self) { result, code in
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
    
    func markAllReadNotificationsService(param: [String:Any], completion: @escaping(EmptyModel) -> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.markAllReadNotifications),requestMethod: .post, requestParams: param, requestModel: EmptyModel.self) { result, code in
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
    
    func createUpdateTermsServices(parameter: [String:Any], completion: @escaping(EmptyModel) -> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.createUpdateTermsCondition), requestMethod: .post, requestParams: parameter, requestModel: EmptyModel.self) { result, code in
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
    
    func createUpdateReturnServices(parameter: [String:Any], completion: @escaping(EmptyModel) -> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.createUpdateReturn), requestMethod: .post, requestParams: parameter, requestModel: EmptyModel.self) { result, code in
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
    
    func createUpdateAboutUsServices(parameter: [String:Any], completion: @escaping(EmptyModel) -> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.createUpdateAboutUs), requestMethod: .post, requestParams: parameter, requestModel: EmptyModel.self) { result, code in
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
    
    func createUpdateCancellationServices(parameter: [String:Any], completion: @escaping(EmptyModel) -> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.createUpdateCancellation), requestMethod: .post, requestParams: parameter, requestModel: EmptyModel.self) { result, code in
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
    
    func createUpdateExchangePolicyServices(parameter: [String:Any], completion: @escaping(EmptyModel) -> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.createUpdateExchangePolicy), requestMethod: .post, requestParams: parameter, requestModel: EmptyModel.self) { result, code in
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
    
    func addFAQService(parameter:[String:Any], completion: @escaping(EmptyModel) -> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.addFAQ), requestMethod: .post, requestParams: parameter, requestModel: EmptyModel.self) { result, code in
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
    
    func updateFAQService(parameter:[String:Any], completion: @escaping(EmptyModel) -> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.updateFAQ), requestMethod: .post, requestParams: parameter, requestModel: EmptyModel.self) { result, code in
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
    
    func deleteFaqService(parameter:[String:Any],completion: @escaping(EmptyModel) -> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.deleteFAQ),requestMethod: .post, requestParams: parameter,requestModel: EmptyModel.self) { result, code in
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
    
    func updateContactUsService(parameter:[String:Any], completion: @escaping(EmptyModel) -> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.createUpdateContactUs),requestMethod: .post, requestParams: parameter, requestModel: EmptyModel.self) { result, code in
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
    
    func getAllAdminModulesService(completion: @escaping([GetAllAdminModulesDataModel]) -> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.getAdminPanelList),requestMethod: .get, requestModel: [GetAllAdminModulesDataModel].self) { result, code in
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
    
    func addSubAdminService(param: [String: Any], completion: @escaping(EmptyModel) -> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.addSubAdmin),requestMethod: .post, requestParams: param, encoding: JSONEncoding.default, requestModel: EmptyModel.self) { result, code in
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
    
    func shareSubAdminCeredentialService(param: [String: Any], completion: @escaping(EmptyModel) -> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.shareCeredential),requestMethod: .post, requestParams: param, encoding: JSONEncoding.default, requestModel: EmptyModel.self) { result, code in
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
    
    func updateSubAdminService(param: [String: Any], completion: @escaping(EmptyModel) -> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.editSubAdmin),requestMethod: .post, requestParams: param, encoding: JSONEncoding.default, requestModel: EmptyModel.self) { result, code in
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
    
    func getSubAdminService(param: [String: Any], completion: @escaping(StaffDetailsDataModel) -> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.getSubAdmin),requestMethod: .get, requestParams: param, requestModel: StaffDetailsDataModel.self) { result, code in
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
    
    func getActiveSubAdminService(param: [String: Any], completion: @escaping(StaffDetailsDataModel) -> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.getActiveSubAdmin),requestMethod: .get, requestParams: param, requestModel: StaffDetailsDataModel.self) { result, code in
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
    
    func getInactiveSubAdminService(param: [String: Any], completion: @escaping(StaffDetailsDataModel) -> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.getInactiveSubAdmin),requestMethod: .get, requestParams: param, requestModel: StaffDetailsDataModel.self) { result, code in
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
    
    func updateSubAdminStatusService(param: [String: Any], completion: @escaping(UpdateStatusProfileDataModel) -> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.updateSubAdminStatus),requestMethod: .post, requestParams: param, requestModel: UpdateStatusProfileDataModel.self) { result, code in
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
    
    func deleteSubAdminService(param: [String: Any], completion: @escaping(EmptyModel) -> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.deleteSubAdmin),requestMethod: .post, requestParams: param, requestModel: EmptyModel.self) { result, code in
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
    
    func getSubAdminProfileDetailsService(param: [String: Any], completion: @escaping(StaffDetails) -> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.getSubAdminProfileDetails),requestMethod: .get, requestParams: param, requestModel: StaffDetails.self) { result, code in
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
    
    func getAllRefundDataService(param: [String: Any], completion: @escaping(RefundMangementDataModel) -> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.getRefundOrders),requestMethod: .get, requestParams: param, requestModel: RefundMangementDataModel.self) { result, code in
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
    
    func getDashboardDataService(param: [String:Any], completion: @escaping(HomeDataModel) -> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.getHomeData),requestMethod: .get, requestParams: param, requestModel: HomeDataModel.self) { result, code in
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
