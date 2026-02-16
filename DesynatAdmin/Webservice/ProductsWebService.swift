//
//  ProductsWebService.swift
//  DesynatAdmin
//
//  Created by fluper_mac3 on 16/02/26.
//

import Foundation
import UIKit

extension WebService {
    
    //M8 API
    func getAllProductsList(param: [String:Any], completion: @escaping (ProductsListDataModel) -> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.getProductsList), requestMethod: .get, requestParams: param, requestModel: ProductsListDataModel.self) { result, code in
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
    
    func updateProductsstatus(param: [String:Any], completion: @escaping (EmptyModel) -> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.blcokUnblockProduct), requestMethod: .post, requestParams: param, requestModel: EmptyModel.self) { result, code in
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
    
    func getProductsDetails(param: [String:Any], completion: @escaping (ProductsList) -> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.getProductDetails), requestMethod: .get, requestParams: param, requestModel: ProductsList.self) { result, code in
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
    
    func getDefaultDeliveryFees(param: [String:Any], completion: @escaping (GetDefaultShippingFees) -> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.getDefaultShippingFees), requestMethod: .get, requestParams: param, requestModel: GetDefaultShippingFees.self) { result, code in
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
    
    func addDefaultShippingFees(param: [String: Any], completion: @escaping(EmptyModel) -> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.updateDefaultShippingFees), requestMethod: .post, requestParams: param, requestModel: EmptyModel.self) { result, code in
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
