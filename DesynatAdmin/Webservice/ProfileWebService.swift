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
    
}

