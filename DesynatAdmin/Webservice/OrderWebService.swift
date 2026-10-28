//
//  OrderWebService.swift
//  DesynatAdmin
//
//  Created by Chandra Prakash on 22/12/25.
//

import Foundation
import UIKit
import Alamofire

extension WebService {
    
    func getActiveOrders(parameter:[String:Any],completion: @escaping(OrderListModel) -> Void) {
        Shimmer.shared.show(show: true)
        NetworkManager.shared.request(
            withAPI: .endpoint(.activeOrders),
            requestMethod: .get,
            requestParams: parameter,
            requestModel: OrderListModel.self
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
    
    func getReturnOrders(parameter:[String:Any],completion: @escaping(OrderListModel) -> Void) {
        Shimmer.shared.show(show: true)
        NetworkManager.shared.request(
            withAPI: .endpoint(.returnOrders),
            requestMethod: .get,
            requestParams: parameter,
            requestModel: OrderListModel.self
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
    
    func getCompletedOrders(parameter:[String:Any],completion: @escaping(OrderListModel) -> Void) {
        Shimmer.shared.show(show: true)
        NetworkManager.shared.request(
            withAPI: .endpoint(.completedOrders),
            requestMethod: .get,
            requestParams: parameter,
            requestModel: OrderListModel.self
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
    
    func getCancelledOrders(parameter:[String:Any],completion: @escaping(OrderListModel) -> Void) {
        Shimmer.shared.show(show: true)
        NetworkManager.shared.request(
            withAPI: .endpoint(.cancelledOrders),
            requestMethod: .get,
            requestParams: parameter,
            requestModel: OrderListModel.self
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
    
    func getOrderDetail(parameter:[String:Any],completion: @escaping(OrderData) -> Void) {
        Shimmer.shared.show(show: true)
        NetworkManager.shared.request(
            withAPI: .endpoint(.singleOrderDetail),
            requestMethod: .get,
            requestParams: parameter,
            requestModel: OrderData.self
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
    
    func getDeliveryBoy(parameter:[String:Any],completion: @escaping([DeliveryBoyListModel]) -> Void) {
        Shimmer.shared.show(show: true)
        NetworkManager.shared.request(
            withAPI: .endpoint(.getDriversAssign),
            requestMethod: .get,
            requestParams: parameter,
            requestModel: [DeliveryBoyListModel].self
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
    
    func assignDriver(parameter:[String:Any],completion: @escaping(EmptyModel) -> Void) {
        Shimmer.shared.show(show: true)
        NetworkManager.shared.request(
            withAPI: .endpoint(.assignDriver),
            requestMethod: .post,
            requestParams: parameter,
            requestModel: EmptyModel.self
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
