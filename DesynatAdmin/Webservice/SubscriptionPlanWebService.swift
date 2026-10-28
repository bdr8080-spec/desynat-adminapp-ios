//
//  SubscriptionPlanWebService.swift
//  DesynatAdmin
//
//  Created by Meet Goti on 10/11/25.
//

import Foundation
import Alamofire
import UIKit
extension WebService {
    
    func addPlan(paramter:[String:Any],completion: @escaping(SubscriptionPlanDataModel) -> Void) {
        Shimmer.shared.show(show: true)
        NetworkManager.shared.request(
            withAPI: .endpoint(.addPlan),
            requestMethod: .post,
            requestParams: paramter,
            encoding: JSONEncoding.default,
            requestModel: SubscriptionPlanDataModel.self
        ) { result, code in
            Shimmer.shared.show(show: false)
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
    func getSubscriptionPlan(countryId:String,completion: @escaping([SubscriptionPlanDataModel]) -> Void) {
        Shimmer.shared.show(show: true)
        NetworkManager.shared.request(
            withAPI: .endpoint(.getPlans),
            requestMethod: .get,
            requestParams: [APIKeys.country_id: countryId],
            requestModel: [SubscriptionPlanDataModel].self
        ) { result, code in
            Shimmer.shared.show(show: false)
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
    func getSubscriptionPlanDetail(id:String,completion: @escaping(SubscriptionPlanDataModel) -> Void) {
        Shimmer.shared.show(show: true)
        NetworkManager.shared.request(
            withAPI: .endpoint(.getPlanDetails),
            requestMethod: .get,
            requestParams: [APIKeys.plan_id:id],
            requestModel: SubscriptionPlanDataModel.self
        ) { result, code in
            Shimmer.shared.show(show: false)
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
    func updateStatusPlan(id:String,completion: @escaping(SubscriptionPlanDataModel) -> Void) {
        Shimmer.shared.show(show: true)
        NetworkManager.shared.request(
            withAPI: .endpoint(.changePlanStatus),
            requestMethod: .post,
            requestParams: [APIKeys.plan_id:id],
            encoding: JSONEncoding.default,
            requestModel: SubscriptionPlanDataModel.self
        ) { result, code in
            Shimmer.shared.show(show: false)
            self.evaluateWebServiceResponse(response: result) { response, message, error in
                guard let response = response else {
                    if let error {
                        UIApplication.shared.topViewController()?.showAlert(msg: error)
                    }
                    return
                }
                CommonUtils.showToast(message: message ?? "")
                completion(response)
            }
        }
    }
    func deletePlan(id:String,completion: @escaping(SubscriptionPlanDataModel) -> Void) {
        Shimmer.shared.show(show: true)
        NetworkManager.shared.request(
            withAPI: .endpoint(.deltePlan),
            requestMethod: .post,
            requestParams: [APIKeys.plan_id:id],
            encoding: JSONEncoding.default,
            requestModel: SubscriptionPlanDataModel.self
        ) { result, code in
            Shimmer.shared.show(show: false)
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
    func editPlan(paramter:[String:Any],completion: @escaping(SubscriptionPlanDataModel) -> Void) {
        Shimmer.shared.show(show: true)
        NetworkManager.shared.request(
            withAPI: .endpoint(.updatePlan),
            requestMethod: .post,
            requestParams: paramter,
            encoding: JSONEncoding.default,
            requestModel: SubscriptionPlanDataModel.self
        ) { result, code in
            Shimmer.shared.show(show: false)
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
