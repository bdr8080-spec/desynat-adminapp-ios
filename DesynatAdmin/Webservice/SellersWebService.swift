//
//  SellersWebService.swift
//  DesynatAdmin
//
//  Created by Meet Goti on 07/11/25.
//

import Foundation
import UIKit
import Alamofire
extension WebService {
    
    func getNewSellers(parameter:[String:Any],completion: @escaping(SellerModel) -> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(
            withAPI: .endpoint(.getNewSellers),
            requestMethod: .get,
            requestParams: parameter,
            requestModel: SellerModel.self
        ) { result, code in
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
    func getApprovedSellers(parameter:[String:Any],completion: @escaping(SellerModel) -> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(
            withAPI: .endpoint(.getApprovedSellers),
            requestMethod: .get,
            requestParams: parameter,
            requestModel: SellerModel.self
        ) { result, code in
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
    
    func getApprovedSellersWithoutPagination(completion: @escaping([SellerDataModel]) -> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(
            withAPI: .endpoint(.getApprovedSellers),
            requestMethod: .get,
            requestModel: [SellerDataModel].self
        ) { result, code in
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
    
    func getRejectSellers(parameter:[String:Any],completion: @escaping(SellerModel) -> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(
            withAPI: .endpoint(.getRejectedSellers),
            requestMethod: .get,
            requestParams: parameter,
            requestModel: SellerModel.self
        ) { result, code in
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
    func approveSellers(id:String,completion: @escaping(SellerDataModel) -> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(
            withAPI: .endpoint(.acceptSeller),
            requestMethod: .post,
            requestParams: [APIKeys.seller_id:id],
            encoding: JSONEncoding.default,
            requestModel: SellerDataModel.self
        ) { result, code in
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
    func updateStatusSellers(id:String,completion: @escaping(SellerDataModel) -> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(
            withAPI: .endpoint(.blockUnBlockSeller),
            requestMethod: .post,
            requestParams: [APIKeys.seller_id:id],
            encoding: JSONEncoding.default,
            requestModel: SellerDataModel.self
        ) { result, code in
            CommonUtils.showHud(show: false)
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
    func rejectSellers(paramter:[String:Any],completion: @escaping(SellerDataModel) -> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(
            withAPI: .endpoint(.rejectSeller),
            requestMethod: .post,
            requestParams: paramter,
            encoding: JSONEncoding.default,
            requestModel: SellerDataModel.self
        ) { result, code in
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
    func getSellerDetail(id:String,completion: @escaping(SellerDataModel) -> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(
            withAPI: .endpoint(.getSellerDetail),
            requestMethod: .get,
            requestParams: [APIKeys.seller_id:id],
            requestModel: SellerDataModel.self
        ) { result, code in
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
