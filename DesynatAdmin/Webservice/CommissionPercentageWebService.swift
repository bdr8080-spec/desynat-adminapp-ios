//
//  CommissionPercentageWebService.swift
//  DesynatAdmin
//
//  Created by Chandra Prakash on 22/12/25.
//

import Foundation
import UIKit
import Alamofire

extension WebService {
    
    func getAffiliateCommissionByCities(completion: @escaping([CommissionPercentageModel]) -> Void) {
        Shimmer.shared.show(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.countriesWithAffiliateCommission), requestMethod: .get, requestModel: [CommissionPercentageModel].self) { result, code in
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
    
    func updateCommissionByCities(param: [String:Any], completion: @escaping(EmptyModel) -> Void) {
        Shimmer.shared.show(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.updateAffiliateCommission), requestMethod: .post, requestParams: param, requestModel: EmptyModel.self) { result, code in
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
