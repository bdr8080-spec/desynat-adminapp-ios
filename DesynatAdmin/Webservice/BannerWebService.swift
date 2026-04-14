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
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(
            withAPI: .endpoint(.getBannerRequest),
            requestMethod: .get,
            requestParams: parameter,
            requestModel: BannerRequestModel.self
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
    
    
    func acceptBanners(id:String,completion: @escaping(EmptyModel) -> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(
            withAPI: .endpoint(.approveBannerRequest),
            requestMethod: .post,
            requestParams: [APIKeys.bannerId:id],
            encoding: JSONEncoding.default,
            requestModel: EmptyModel.self
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

    
    func rejectBanners(paramter:[String:Any],completion: @escaping(EmptyModel) -> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(
            withAPI: .endpoint(.rejectBannerRequest),
            requestMethod: .post,
            requestParams: paramter,
            encoding: JSONEncoding.default,
            requestModel: EmptyModel.self
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
