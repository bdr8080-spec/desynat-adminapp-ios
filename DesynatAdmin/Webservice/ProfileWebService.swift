//
import Foundation
import UIKit
import Alamofire
extension WebService {
    
    func getAllCountry(completion: @escaping([GetCountryDataModel]) -> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.getCountry), requestMethod: .get, requestModel: [GetCountryDataModel].self) { result, code in
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
    
    func getAllCategory(completion: @escaping([GetCategoryModel]) -> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.getCategory), requestMethod: .get, requestModel: [GetCategoryModel].self) { result, code in
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
    
    func getAllsubcategory(param: [String: Any], completion: @escaping (GetSubCategoryDataModel) -> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.getSubcategories), requestMethod: .get, requestParams: param, requestModel: GetSubCategoryDataModel.self) { result, code in
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
    
    func upadteSubcategoryStatus(param: [String:Any], completion: @escaping(GetSubCategoryDataList) -> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.changeSubcategoryStatus), requestMethod: .post, requestParams: param, requestModel: GetSubCategoryDataList.self) { result, code in
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
    
    func upadteCategory(param: [String:Any], completion: @escaping(GetCategoryModel) -> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.changeCategoryStatus), requestMethod: .post, requestParams: param, requestModel: GetCategoryModel.self) { result, code in
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
    
    func uploadFile(withParams file:MultipartUpload,
                    completion:@escaping (_ url:String, _ msg:String?, _ code:HTTPStatusCode?)-> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.requestMultiPart(url: .endpoint(.uploadFile), assets: [file], model: UploadFileDataModel.self) { result, code in
            CommonUtils.showHud(show: false)
            self.evaluateWebServiceResponse(response: result) { response, message, error in
                if let url = response?.url {
                    completion(url, message, code)
                } else if let error {
                    UIApplication.shared.topViewController()?.showAlert(msg: error)
                }
            }
        }
    }
  
  func uploadFullScreenBanner(withParams file:MultipartUpload, param: [String: Any],
                  completion:@escaping (_ url:String, _ msg:String?, _ code:HTTPStatusCode?)-> Void) {
      CommonUtils.showHud(show: true)
      NetworkManager.shared.requestMultiPart(url: .endpoint(.uploadFullScreenBanner), assets: [file], param: param, model: UploadFileDataModel.self) { result, code in
          CommonUtils.showHud(show: false)
          self.evaluateWebServiceResponse(response: result) { response, message, error in
              if let url = response?.url {
                  completion(url, message, code)
              } else if let error {
                  UIApplication.shared.topViewController()?.showAlert(msg: error)
              }
          }
      }
  }
    
    func addSubCategory(param: [String:Any], completion: @escaping(GetCategoryModel) -> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.addSubCategory), requestMethod: .post, requestParams: param, requestModel: GetCategoryModel.self) { result, code in
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
  
  func addAdvertisement(param: [String:Any], completion: @escaping(FullScreenBannerDataList) -> Void) { //AddAdvertisementModel
      CommonUtils.showHud(show: true)
      NetworkManager.shared.request(withAPI: .endpoint(.addFullScreenBanner), requestMethod: .post, requestParams: param, requestModel: FullScreenBannerDataList.self) { result, code in
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
  
  func editAdvertisement(param: [String:Any], completion: @escaping(FullScreenBannerDataList) -> Void) {
      CommonUtils.showHud(show: true)
      NetworkManager.shared.request(withAPI: .endpoint(.updateFullScreenBanner), requestMethod: .post, requestParams: param, requestModel: FullScreenBannerDataList.self) { result, code in
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
    
    func editSubCategory(param: [String:Any], completion: @escaping(GetSubCategoryDataList) -> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.editSubCategory), requestMethod: .post, requestParams: param, requestModel: GetSubCategoryDataList.self) { result, code in
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
  
  
    
    func deleteSubCategory(param: [String:Any], completion: @escaping(EmptyModel) -> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.deleteSubCategory), requestMethod: .post, requestParams: param, requestModel: EmptyModel.self) { result, code in
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
    
    func getAllBrands(param: [String: Any], completion: @escaping (GetBrandDataModel) -> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.getAllBrands), requestMethod: .get, requestParams: param, requestModel: GetBrandDataModel.self) { result, code in
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
  
  func getAllFullScreenBanners(param: [String: Any], completion: @escaping (FullScreenBannerDataModel) -> Void) {
      CommonUtils.showHud(show: true)
      NetworkManager.shared.request(withAPI: .endpoint(.getFullScreenBanners), requestMethod: .get, requestParams: param, requestModel: FullScreenBannerDataModel.self) { result, code in
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
    
    func upadteBrandStatus(param: [String:Any], completion: @escaping(GetBrandDataList) -> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.changeBrandStatus), requestMethod: .post, requestParams: param, requestModel: GetBrandDataList.self) { result, code in
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
    
    
    func upadteBannerRequestStatus(param: [String:Any], completion: @escaping(GetBrandDataList) -> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.updateBannerRequestStatus), requestMethod: .post, requestParams: param, requestModel: GetBrandDataList.self) { result, code in
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
    
    func deleteBrand(param: [String:Any], completion: @escaping(EmptyModel) -> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.deleteBrand), requestMethod: .post, requestParams: param, requestModel: EmptyModel.self) { result, code in
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
    
    func addNewBrand(param: [String:Any], completion: @escaping(GetCategoryModel) -> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.addNewBrands), requestMethod: .post, requestParams: param, requestModel: GetCategoryModel.self) { result, code in
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
    
    func editBrand(param: [String:Any], completion: @escaping(GetBrandDataList) -> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.updateBrand), requestMethod: .post, requestParams: param, requestModel: GetBrandDataList.self) { result, code in
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
    
    func logoutService(completion:@escaping (_ user:EmptyModel)-> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.logoutUser), requestMethod: .post, encoding: JSONEncoding.default, requestModel: EmptyModel.self) { result, code in
            
            CommonUtils.showHud(show: false)
            self.evaluateWebServiceResponse(response: result) { response, message,error in
                guard let user = response else {
                    if let error {
                        UIApplication.shared.topViewController()?.showAlert(msg: error)
                    }
                    return
                }
                CommonUtils.showToast(message: message ?? "")
                completion(user)
            }
        }
    }
  
  func getAllUsers(param: [String: Any], completion: @escaping (UsersManagmentListModel) -> Void) {
      CommonUtils.showHud(show: true)
      NetworkManager.shared.request(withAPI: .endpoint(.getUsers), requestMethod: .get, requestParams: param, requestModel: UsersManagmentListModel.self) { result, code in
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
  
  func getUserDetails(param: [String: Any], completion: @escaping (UsersListModel) -> Void) {
      CommonUtils.showHud(show: true)
      NetworkManager.shared.request(withAPI: .endpoint(.getUserDetails), requestMethod: .get, requestParams: param, requestModel: UsersListModel.self) { result, code in
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
  
  func updateUserStatus(param: [String: Any], completion: @escaping (EmptyModel) -> Void) {
      CommonUtils.showHud(show: true)
      NetworkManager.shared.request(withAPI: .endpoint(.updateUserStatus), requestMethod: .post, requestParams: param, requestModel: EmptyModel.self) { result, code in
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
  
  func addAmountUserStatus(param: [String: Any], completion: @escaping (EmptyModel) -> Void) {
      CommonUtils.showHud(show: true)
      NetworkManager.shared.request(withAPI: .endpoint(.addWalletAmount), requestMethod: .post, requestParams: param, requestModel: EmptyModel.self) { result, code in
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
  
  func getReasonsList(param: [String: Any], completion: @escaping (ReasonManagmentListModel) -> Void) {
      CommonUtils.showHud(show: true)
      NetworkManager.shared.request(withAPI: .endpoint(.getReasonsList), requestMethod: .get, requestParams: param, requestModel: ReasonManagmentListModel.self) { result, code in
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
  
  func updateReasonStatus(param: [String: Any], completion: @escaping (EmptyModel) -> Void) {
      CommonUtils.showHud(show: true)
      NetworkManager.shared.request(withAPI: .endpoint(.updateReasonStatus), requestMethod: .post, requestParams: param, requestModel: EmptyModel.self) { result, code in
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
  
  func editReason(param: [String: Any], completion: @escaping (EmptyModel) -> Void) {
      CommonUtils.showHud(show: true)
      NetworkManager.shared.request(withAPI: .endpoint(.updateReason), requestMethod: .post, requestParams: param, requestModel: EmptyModel.self) { result, code in
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
  
  func addReason(param: [String: Any], completion: @escaping (EmptyModel) -> Void) {
      CommonUtils.showHud(show: true)
      NetworkManager.shared.request(withAPI: .endpoint(.addReason), requestMethod: .post, requestParams: param, requestModel: EmptyModel.self) { result, code in
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
  
    func deleteReason(param: [String: Any], completion: @escaping (EmptyModel) -> Void) {
      CommonUtils.showHud(show: true)
      NetworkManager.shared.request(withAPI: .endpoint(.deleteReason), requestMethod: .post, requestParams: param, requestModel: EmptyModel.self) { result, code in
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
  
  func getAllDeliveryBoys(param: [String: Any], completion: @escaping (DeliveryBoysListDataModel) -> Void) {
      CommonUtils.showHud(show: true)
      NetworkManager.shared.request(withAPI: .endpoint(.getDeliveryBoysList), requestMethod: .get, requestParams: param, requestModel: DeliveryBoysListDataModel.self) { result, code in
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
  
  func deleteBoy(param: [String: Any], completion: @escaping (EmptyModel) -> Void) {
    CommonUtils.showHud(show: true)
    NetworkManager.shared.request(withAPI: .endpoint(.deleteDeliveryBoys), requestMethod: .post, requestParams: param, requestModel: EmptyModel.self) { result, code in
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
  
  func updateStatusBoy(param: [String: Any], completion: @escaping (EmptyModel) -> Void) {
    CommonUtils.showHud(show: true)
    NetworkManager.shared.request(withAPI: .endpoint(.updateDeliveryBoyStatus), requestMethod: .post, requestParams: param, requestModel: EmptyModel.self) { result, code in
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
  
  func getAllCountryListForDriver(completion: @escaping([DriverCounrtyListDataModel]) -> Void) {
      CommonUtils.showHud(show: true)
      NetworkManager.shared.request(withAPI: .endpoint(.getCountryListOfDriver), requestMethod: .get, requestModel: [DriverCounrtyListDataModel].self) { result, code in
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
  
  func getAllUsersCountryList(completion:@escaping (_ user:[GetAllUserCountryModel])-> Void) {
      CommonUtils.showHud(show: true)
      NetworkManager.shared.request(withAPI:.endpoint(.allUserCountry), requestMethod: .get,requestModel:[GetAllUserCountryModel].self) { result, code in
          
          CommonUtils.showHud(show: false)
          self.evaluateWebServiceResponse(response: result) { response, message,error in
              guard let user = response else {
                  if let error {
                      UIApplication.shared.topViewController()?.showAlert(msg: error)
                  }
                  return
              }
              completion(user)
          }
      }
  }
  
  func getAllZone(completion: @escaping([DriverZoneList]) -> Void) {
      CommonUtils.showHud(show: true)
      NetworkManager.shared.request(withAPI: .endpoint(.getZoneListOfDriver), requestMethod: .get, requestModel: [DriverZoneList].self) { result, code in
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
  
  func addDriver(param: [String:Any], completion: @escaping(EmptyModel) -> Void) {
      CommonUtils.showHud(show: true)
      NetworkManager.shared.request(withAPI: .endpoint(.addNewDriver), requestMethod: .post, requestParams: param, requestModel: EmptyModel.self) { result, code in
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
  
  func getDriverDetails(param: [String:Any], completion: @escaping(DeliveryBoysList) -> Void) {
      CommonUtils.showHud(show: true)
      NetworkManager.shared.request(withAPI: .endpoint(.getDriverDetails), requestMethod: .get, requestParams: param, requestModel: DeliveryBoysList.self) { result, code in
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
    
    func editDriverDetails(param: [String:Any], completion: @escaping(EmptyModel) -> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.editDriverDetails), requestMethod: .post, requestParams: param, requestModel: EmptyModel.self) { result, code in
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
  
  //M4
  
  func getShippingTaxes(completion: @escaping([ShippingChargesDataModel]) -> Void) {
      CommonUtils.showHud(show: true)
      NetworkManager.shared.request(withAPI: .endpoint(.getShippingTaxes), requestMethod: .get, requestModel: [ShippingChargesDataModel].self) { result, code in
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
  
  func getShippingTaxesCountryWise(params:[String: Any], completion: @escaping([ShippingChargesList]) -> Void) {
      CommonUtils.showHud(show: true)
      NetworkManager.shared.request(withAPI: .endpoint(.getShippingTaxesCountry), requestMethod: .get, requestParams: params,  requestModel: [ShippingChargesList].self) { result, code in
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
  
  func deleteShippingInfo(param: [String: Any], completion: @escaping([ShippingChargesDataModel]) -> Void) {
      CommonUtils.showHud(show: true)
      NetworkManager.shared.request(withAPI: .endpoint(.deleteShippingInfo), requestMethod: .post, requestParams: param, requestModel: [ShippingChargesDataModel].self) { result, code in
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
  
  func updateStatusOfShippingFees(param: [String: Any], completion: @escaping(EmptyModel) -> Void) {
      CommonUtils.showHud(show: true)
      NetworkManager.shared.request(withAPI: .endpoint(.updateStatusOfShippingFee), requestMethod: .post, requestParams: param, requestModel: EmptyModel.self) { result, code in
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
  
  
  func addShippingFees(param: [String: Any], completion: @escaping(EmptyModel) -> Void) {
      CommonUtils.showHud(show: true)
      NetworkManager.shared.request(withAPI: .endpoint(.addShippingFee), requestMethod: .post, requestParams: param, requestModel: EmptyModel.self) { result, code in
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
  
  
  func addNewShippingCharge(param: [String: Any], completion: @escaping(EmptyModel) -> Void) {
      CommonUtils.showHud(show: true)
      NetworkManager.shared.request(withAPI: .endpoint(.addShippingCharges), requestMethod: .post, requestParams: param, requestModel: EmptyModel.self) { result, code in
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
  
  func editShippingInfo(param: [String: Any], completion: @escaping(ShippingChargesDataModel) -> Void) {
      CommonUtils.showHud(show: true)
      NetworkManager.shared.request(withAPI: .endpoint(.editShippingInfo), requestMethod: .post, requestParams: param, requestModel: ShippingChargesDataModel.self) { result, code in
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
  
  func getGiftsList(param: [String: Any], completion: @escaping (GiftCardsListDataModel) -> Void) {
      CommonUtils.showHud(show: true)
      NetworkManager.shared.request(withAPI: .endpoint(.getGiftCardsList), requestMethod: .get, requestParams: param, requestModel: GiftCardsListDataModel.self) { result, code in
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
  
  func getFullScreenBannerDetailsList(param: [String: Any], completion: @escaping (FullScreenBannerDataList) -> Void) {
      CommonUtils.showHud(show: true)
      NetworkManager.shared.request(withAPI: .endpoint(.getFullScreenDetailsBanners), requestMethod: .get, requestParams: param, requestModel: FullScreenBannerDataList.self) { result, code in
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
  
  func upadteGiftCardStatus(param: [String:Any], completion: @escaping(GiftCardsList) -> Void) {
      CommonUtils.showHud(show: true)
      NetworkManager.shared.request(withAPI: .endpoint(.updateStatusOfGiftCards), requestMethod: .post, requestParams: param, requestModel: GiftCardsList.self) { result, code in
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
  
  func deleteCard(param: [String:Any], completion: @escaping(EmptyModel) -> Void) {
      CommonUtils.showHud(show: true)
      NetworkManager.shared.request(withAPI: .endpoint(.deleteGiftCard), requestMethod: .post, requestParams: param, requestModel: EmptyModel.self) { result, code in
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
  
  func deleteFullScreenBanner(param: [String:Any], completion: @escaping(EmptyModel) -> Void) {
      CommonUtils.showHud(show: true)
      NetworkManager.shared.request(withAPI: .endpoint(.deleteFullScreenBanner), requestMethod: .post, requestParams: param, requestModel: EmptyModel.self) { result, code in
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
  
  func editCardDetails(param: [String:Any], completion: @escaping(GiftCardsList) -> Void) {
      CommonUtils.showHud(show: true)
      NetworkManager.shared.request(withAPI: .endpoint(.editGiftCard), requestMethod: .post, requestParams: param, requestModel: GiftCardsList.self) { result, code in
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
  
  func addNewCard(param: [String:Any], completion: @escaping(GiftCardsList) -> Void) {
      CommonUtils.showHud(show: true)
      NetworkManager.shared.request(withAPI: .endpoint(.addGiftCard), requestMethod: .post, requestParams: param, requestModel: GiftCardsList.self) { result, code in
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
  
  func getBannersPerDay(param: [String:Any], completion: @escaping([BannersPerDayListDataModel]) -> Void) {
      CommonUtils.showHud(show: true)
      NetworkManager.shared.request(withAPI: .endpoint(.getBannersList), requestMethod: .get, requestParams: param, requestModel: [BannersPerDayListDataModel].self) { result, code in
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
  
  func addPriceBannersPerDay(param: [String:Any], completion: @escaping(EmptyModel) -> Void) {
      CommonUtils.showHud(show: true)
      NetworkManager.shared.request(withAPI: .endpoint(.addPriceBanners), requestMethod: .post, requestParams: param, requestModel: EmptyModel.self) { result, code in
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
  
  func getAllPromoCode(param: [String:Any], completion: @escaping(PromocodeListDataModel) -> Void) {
      CommonUtils.showHud(show: true)
      NetworkManager.shared.request(withAPI: .endpoint(.getPromocode), requestMethod: .get, requestParams: param, requestModel: PromocodeListDataModel.self) { result, code in
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
  
  func upadtePromocodeStatus(param: [String:Any], completion: @escaping(PromocodeList) -> Void) {
      CommonUtils.showHud(show: true)
      NetworkManager.shared.request(withAPI: .endpoint(.updateStatusPromocode), requestMethod: .post, requestParams: param, requestModel: PromocodeList.self) { result, code in
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
  
  func deletePromoCode(param: [String:Any], completion: @escaping(EmptyModel) -> Void) {
      CommonUtils.showHud(show: true)
      NetworkManager.shared.request(withAPI: .endpoint(.deletePromocode), requestMethod: .post, requestParams: param, requestModel: EmptyModel.self) { result, code in
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
  
  func addPromoCode(param: [String:Any], completion: @escaping(EmptyModel) -> Void) {
      CommonUtils.showHud(show: true)
      NetworkManager.shared.request(withAPI: .endpoint(.addPromocode), requestMethod: .post, requestParams: param, requestModel: EmptyModel.self) { result, code in
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
  
  func editPromoCode(param: [String:Any], completion: @escaping(EmptyModel) -> Void) {
      CommonUtils.showHud(show: true)
      NetworkManager.shared.request(withAPI: .endpoint(.editPromocode), requestMethod: .post, requestParams: param, requestModel: EmptyModel.self) { result, code in
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
  
  func getActiveDeals(param: [String: Any], completion: @escaping (DealListManagementListDataModel) -> Void) {
      CommonUtils.showHud(show: true)
      NetworkManager.shared.request(withAPI: .endpoint(.getAllActiveDeals), requestMethod: .get, requestParams: param, requestModel: DealListManagementListDataModel.self) { result, code in
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
  
  func getExpiredDeals(param: [String: Any], completion: @escaping (DealListManagementListDataModel) -> Void) {
      CommonUtils.showHud(show: true)
      NetworkManager.shared.request(withAPI: .endpoint(.getAllExpiredDeals), requestMethod: .get, requestParams: param, requestModel: DealListManagementListDataModel.self) { result, code in
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
  
  func editDealsDetails(param: [String:Any], completion: @escaping(EmptyModel) -> Void) {
      CommonUtils.showHud(show: true)
      NetworkManager.shared.request(withAPI: .endpoint(.editDealDetails), requestMethod: .post, requestParams: param, requestModel: EmptyModel.self) { result, code in
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
  
  func addNewDeal(param: [String:Any], completion: @escaping(EmptyModel) -> Void) {
      CommonUtils.showHud(show: true)
      NetworkManager.shared.request(withAPI: .endpoint(.addNewDeal), requestMethod: .post, requestParams: param, requestModel: EmptyModel.self) { result, code in
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
  
  func getDealDetailsList(param: [String: Any], completion: @escaping (DealListManagementList) -> Void) {
      CommonUtils.showHud(show: true)
      NetworkManager.shared.request(withAPI: .endpoint(.getDealDetails), requestMethod: .get, requestParams: param, requestModel: DealListManagementList.self) { result, code in
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
  
  func dealDetailsStatusUpdate(param: [String:Any], completion: @escaping(DealListManagementList) -> Void) {
      CommonUtils.showHud(show: true)
      NetworkManager.shared.request(withAPI: .endpoint(.updateDealStatus), requestMethod: .post, requestParams: param, requestModel: DealListManagementList.self) { result, code in
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
  
  func deleteDealDetails(param: [String:Any], completion: @escaping(EmptyModel) -> Void) {
      CommonUtils.showHud(show: true)
      NetworkManager.shared.request(withAPI: .endpoint(.deleteDealDetails), requestMethod: .post, requestParams: param, requestModel: EmptyModel.self) { result, code in
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
  
  func addTimeSlot(param: [String:Any], completion: @escaping(EmptyModel) -> Void) {
      CommonUtils.showHud(show: true)
      NetworkManager.shared.request(withAPI: .endpoint(.addTimeSlots), requestMethod: .post, requestParams: param, requestModel: EmptyModel.self) { result, code in
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
  
  func editTimeSlot(param: [String:Any], completion: @escaping(EmptyModel) -> Void) {
      CommonUtils.showHud(show: true)
      NetworkManager.shared.request(withAPI: .endpoint(.editTimeSlots), requestMethod: .post, requestParams: param, requestModel: EmptyModel.self) { result, code in
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
  
  func getAllLiveRequestTimeSlot(param: [String: Any], completion: @escaping([LiveRequestListDataModel]) -> Void) {
      CommonUtils.showHud(show: true)
      NetworkManager.shared.request(withAPI: .endpoint(.getLiveRequestTimeSlots), requestMethod: .get, requestParams: param, requestModel: [LiveRequestListDataModel].self) { result, code in
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
  
  func updateLiveRequestTimeslotStatus(param: [String: Any], completion: @escaping (EmptyModel) -> Void) {
      CommonUtils.showHud(show: true)
      NetworkManager.shared.request(withAPI: .endpoint(.updateStatusLiveRequestTimeSlots), requestMethod: .post, requestParams: param, requestModel: EmptyModel.self) { result, code in
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
  
  func deleteTimeSlots(param: [String: Any], completion: @escaping (EmptyModel) -> Void) {
    CommonUtils.showHud(show: true)
    NetworkManager.shared.request(withAPI: .endpoint(.deleteLiveRequestTimeSlots), requestMethod: .post, requestParams: param, requestModel: EmptyModel.self) { result, code in
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
  
  func getAllLiveRequest(param: [String: Any], completion: @escaping(LiveRequestPermissionDataModel) -> Void) {
      CommonUtils.showHud(show: true)
      NetworkManager.shared.request(withAPI: .endpoint(.getLiveRequestTime), requestMethod: .get, requestParams: param, requestModel: LiveRequestPermissionDataModel.self) { result, code in
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
    
  func acceptLiveRequest(param: [String: Any], completion: @escaping (EmptyModel) -> Void) {
    CommonUtils.showHud(show: true)
    NetworkManager.shared.request(withAPI: .endpoint(.acceptLiveRequest), requestMethod: .post, requestParams: param, requestModel: EmptyModel.self) { result, code in
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
  
  func rejectLiveRequest(param: [String: Any], completion: @escaping (EmptyModel) -> Void) {
    CommonUtils.showHud(show: true)
    NetworkManager.shared.request(withAPI: .endpoint(.rejectLiveRequest), requestMethod: .post, requestParams: param, requestModel: EmptyModel.self) { result, code in
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
  
  func getAdminStoriesList(param: [String: Any], completion: @escaping (AdminStoriesDataModel) -> Void) {
      CommonUtils.showHud(show: true)
      NetworkManager.shared.request(withAPI: .endpoint(.getAdminStories), requestMethod: .get, requestParams: param, requestModel: AdminStoriesDataModel.self) { result, code in
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
  
  func deleteAdminStories(param: [String: Any], completion: @escaping (EmptyModel) -> Void) {
    CommonUtils.showHud(show: true)
    NetworkManager.shared.request(withAPI: .endpoint(.deleteAdminStories), requestMethod: .post, requestParams: param, requestModel: EmptyModel.self) { result, code in
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
  
  func uploadVideoAndImage(withParams file:MultipartUpload,
                  completion:@escaping (_ url:String, _ msg:String?, _ code:HTTPStatusCode?)-> Void) {
      CommonUtils.showHud(show: true)
      NetworkManager.shared.requestMultiPartForVideoAndAudio(url: .endpoint(.uploadImageAndVideo), assets: [file], model: UploadFileDataModel.self) { result, code in
          CommonUtils.showHud(show: false)
          self.evaluateWebServiceResponse(response: result) { response, message, error in
              if let url = response?.url {
                  completion(url, message, code)
              } else if let error {
                  UIApplication.shared.topViewController()?.showAlert(msg: error)
              }
          }
      }
  }
  
  func uploadAdminStories(param: [String: Any], completion: @escaping (EmptyModel) -> Void) {
    CommonUtils.showHud(show: true)
    NetworkManager.shared.request(withAPI: .endpoint(.uploadAdminStory), requestMethod: .post, requestParams: param, requestModel: EmptyModel.self) { result, code in
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
    
    func getNewAffilaitedUsersRequest(param: [String: Any], completion: @escaping (AffilitaitedUsersListDataModel) -> Void) {
      CommonUtils.showHud(show: true)
      NetworkManager.shared.request(withAPI: .endpoint(.getNewAffilaitedUsers), requestMethod: .get, requestParams: param, requestModel: AffilitaitedUsersListDataModel.self) { result, code in
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
    
    func getApprovedAffilaitedUsersRequest(param: [String: Any], completion: @escaping (AffilitaitedUsersListDataModel) -> Void) {
      CommonUtils.showHud(show: true)
      NetworkManager.shared.request(withAPI: .endpoint(.getApprovedAffilaitedUsers), requestMethod: .get, requestParams: param, requestModel: AffilitaitedUsersListDataModel.self) { result, code in
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
    
    func getRejectedAffilaitedUsersRequest(param: [String: Any], completion: @escaping (AffilitaitedUsersListDataModel) -> Void) {
      CommonUtils.showHud(show: true)
      NetworkManager.shared.request(withAPI: .endpoint(.getRejectedAffilaitedUsers), requestMethod: .get, requestParams: param, requestModel: AffilitaitedUsersListDataModel.self) { result, code in
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
    
    func getAffilaitedUsersDetailsRequest(param: [String: Any], completion: @escaping (AffilitaitedUsersDataModel) -> Void) {
      CommonUtils.showHud(show: true)
      NetworkManager.shared.request(withAPI: .endpoint(.getAffilaitedUsersDetails), requestMethod: .get, requestParams: param, requestModel: AffilitaitedUsersDataModel.self) { result, code in
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
    
    func acceptAffilaitedUsersRequest(param: [String: Any], completion: @escaping (EmptyModel) -> Void) {
      CommonUtils.showHud(show: true)
      NetworkManager.shared.request(withAPI: .endpoint(.acceptAffilaitedUsers), requestMethod: .post, requestParams: param, requestModel: EmptyModel.self) { result, code in
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
    
    func rejectAffilaitedUsersRequest(param: [String: Any], completion: @escaping (EmptyModel) -> Void) {
      CommonUtils.showHud(show: true)
      NetworkManager.shared.request(withAPI: .endpoint(.rejectAffilaitedUsers), requestMethod: .post, requestParams: param, requestModel: EmptyModel.self) { result, code in
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
    
    func blockUnblockAffilaitedUsersRequest(param: [String: Any], completion: @escaping (EmptyModel) -> Void) {
      CommonUtils.showHud(show: true)
      NetworkManager.shared.request(withAPI: .endpoint(.blockUnblockAffilaitedUsers), requestMethod: .post, requestParams: param, requestModel: EmptyModel.self) { result, code in
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
    
    func getAllProductsInDealRequest(param: [String: Any], completion: @escaping (ProductsListInDealListDataModel) -> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.getDealProductsList), requestMethod: .get, requestParams: param, requestModel: ProductsListInDealListDataModel.self) { result, code in
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
    
    func getAllBrandsListForFilter(completion: @escaping (GetBrandDataModel) -> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.getAllBrands), requestMethod: .get, requestModel: GetBrandDataModel.self) { result, code in
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

