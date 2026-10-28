//
//  BannerWebService.swift
//  DesynatAdmin
//
//  Created by Chandra Prakash on 22/12/25.
//

import Foundation
import UIKit
import Alamofire

extension WebService {
    
    func getNewBanners(parameter:[String:Any],completion: @escaping(BannerRequestModel) -> Void) {
        Shimmer.shared.show(show: true)
        NetworkManager.shared.request(
            withAPI: .endpoint(.getBannerRequest),
            requestMethod: .get,
            requestParams: parameter,
            requestModel: BannerRequestModel.self
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
    
    
    func acceptBanners(id:String,completion: @escaping(EmptyModel) -> Void) {
        Shimmer.shared.show(show: true)
        NetworkManager.shared.request(
            withAPI: .endpoint(.approveBannerRequest),
            requestMethod: .post,
            requestParams: [APIKeys.bannerId:id],
            encoding: JSONEncoding.default,
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

    
    func rejectBanners(paramter:[String:Any],completion: @escaping(EmptyModel) -> Void) {
        Shimmer.shared.show(show: true)
        NetworkManager.shared.request(
            withAPI: .endpoint(.rejectBannerRequest),
            requestMethod: .post,
            requestParams: paramter,
            encoding: JSONEncoding.default,
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
    
    func getNewSellerStories(parameter:[String:Any],completion: @escaping(SellerStoryRequestManagementModel) -> Void) {
        Shimmer.shared.show(show: true)
        NetworkManager.shared.request(
            withAPI: .endpoint(.getSellerPromoStory),
            requestMethod: .post,
            requestParams: parameter,
            requestModel: SellerStoryRequestManagementModel.self
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
    
    func acceptSellerStories(id:String,completion: @escaping(EmptyModel) -> Void) {
        Shimmer.shared.show(show: true)
        NetworkManager.shared.request(
            withAPI: .endpoint(.approveSellerStoryRequest),
            requestMethod: .post,
            requestParams: [APIKeys.storyId:id],
            encoding: JSONEncoding.default,
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

    
    func rejectSellerStories(paramter:[String:Any],completion: @escaping(EmptyModel) -> Void) {
        Shimmer.shared.show(show: true)
        NetworkManager.shared.request(
            withAPI: .endpoint(.rejectSellerStoryRequest),
            requestMethod: .post,
            requestParams: paramter,
            encoding: JSONEncoding.default,
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
