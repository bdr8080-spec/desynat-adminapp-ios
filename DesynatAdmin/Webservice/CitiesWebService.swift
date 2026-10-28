//
//  CitiesWebService.swift
//  DesynatAdmin
//
//  Created by Meet Goti on 11/11/25.
//

import Foundation
import UIKit
import Alamofire
extension WebService {
    func getServiceCities(parameter:[String:Any],completion: @escaping(AdminCityModel) -> Void) {
        Shimmer.shared.show(show: true)
        NetworkManager.shared.request(
            withAPI: .endpoint(.getServiceCitites),
            requestMethod: .get,
            requestParams: parameter,
            requestModel: AdminCityModel.self
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
    func getZones(parameter:[String:Any],completion: @escaping(AdminZoneModel) -> Void) {
        Shimmer.shared.show(show: true)
        NetworkManager.shared.request(
            withAPI: .endpoint(.getZone),
            requestMethod: .get,
            requestParams: parameter,
            requestModel: AdminZoneModel.self
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
    func getCities(countryId:String,completion: @escaping([CountryCitiesDataModel]) -> Void) {
        Shimmer.shared.show(show: true)
        NetworkManager.shared.request(
            withAPI: .endpoint(.getCitites),
            requestMethod: .get,
            requestParams: [APIKeys.country_id:countryId],
            requestModel: [CountryCitiesDataModel].self
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
    func addCity(cityId:String,completion: @escaping(CountryCitiesDataModel) -> Void) {
        Shimmer.shared.show(show: true)
        NetworkManager.shared.request(
            withAPI: .endpoint(.addServiceCity),
            requestMethod: .post,
            requestParams: [APIKeys.city_id:cityId],
            encoding: JSONEncoding.default,
            requestModel: CountryCitiesDataModel.self
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
    func addZone(parameter:[String:Any],completion: @escaping(ZoneDataModel) -> Void) {
        Shimmer.shared.show(show: true)
        NetworkManager.shared.request(
            withAPI: .endpoint(.addZone),
            requestMethod: .post,
            requestParams: parameter,
            encoding: JSONEncoding.default,
            requestModel: ZoneDataModel.self
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
    func updateZone(parameter:[String:Any],completion: @escaping(ZoneDataModel) -> Void) {
        Shimmer.shared.show(show: true)
        NetworkManager.shared.request(
            withAPI: .endpoint(.updateZone),
            requestMethod: .post,
            requestParams: parameter,
            encoding: JSONEncoding.default,
            requestModel: ZoneDataModel.self
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
    func deleteCity(cityId:String,completion: @escaping(CountryCitiesDataModel?) -> Void) {
        Shimmer.shared.show(show: true)
        NetworkManager.shared.request(
            withAPI: .endpoint(.deleteServiceCity),
            requestMethod: .post,
            requestParams: [APIKeys.city_id:cityId],
            encoding: JSONEncoding.default,
            requestModel: CountryCitiesDataModel?.self
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
    func deleteZone(zoneId:String,completion: @escaping(ZoneDataModel?) -> Void) {
        Shimmer.shared.show(show: true)
        NetworkManager.shared.request(
            withAPI: .endpoint(.delteZone),
            requestMethod: .post,
            requestParams: [APIKeys.zone_id:zoneId],
            encoding: JSONEncoding.default,
            requestModel: ZoneDataModel?.self
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
    func changeCityStatus(cityId:String,completion: @escaping(CountryCitiesDataModel) -> Void) {
        Shimmer.shared.show(show: true)
        NetworkManager.shared.request(
            withAPI: .endpoint(.changeServiceCityStatus),
            requestMethod: .post,
            requestParams: [APIKeys.city_id:cityId],
            encoding: JSONEncoding.default,
            requestModel: CountryCitiesDataModel.self
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
    func changeZoneStatus(zoneID:String,completion: @escaping(ZoneDataModel) -> Void) {
        Shimmer.shared.show(show: true)
        NetworkManager.shared.request(
            withAPI: .endpoint(.changeUpdateZoneStatus),
            requestMethod: .post,
            requestParams: [APIKeys.zone_id:zoneID],
            encoding: JSONEncoding.default,
            requestModel: ZoneDataModel.self
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
}
