//
//  ProductDetailsViewModel.swift
//  DesynatAdmin
//
//  Created by fluper_mac3 on 13/02/26.
//


import Foundation
import UIKit

class ProductDetailsViewModel {
  
  private var hostVC: ProductDetailViewController
  var productDetails: ProductsList?
  
  init(hostVC: ProductDetailViewController) {
    self.hostVC = hostVC
  }
  
  func updateActiveStatus(param: [String: Any], completion: @escaping (Bool) -> Void) {
//      WebService.sharedInstance.updateProductActiveStatus(param: param){ response in
//          completion(true)
//      }
  }
  
    func getProductDetailsService() {
//        let param: [String: Any] = ["product_id" :hostVC.productId]
//        WebService.sharedInstance.getProductDetailsService(param: param){ [weak self] response in
//      guard let self = self else { return }
//          productDetails = response
//            hostVC.configData(data: response)
//    }
  }
  
}
