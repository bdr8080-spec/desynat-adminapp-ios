//
//  DeliveryBoyFilterDataModel.swift
//  DesynatAdmin
//
//  Created by fluper on 21/11/25.
//

import Foundation

struct DriverFilterModel {
    var fromDate: String?
    var toDate: String?
    
    var isEmpty: Bool {
        return fromDate == nil && toDate == nil
    }
}

struct ProductFilterModelOnBrand {
    var brandName: String?
    var brandId: Int?
    
    var isEmpty: Bool {
        return brandName == nil && brandId == nil
    }
}
