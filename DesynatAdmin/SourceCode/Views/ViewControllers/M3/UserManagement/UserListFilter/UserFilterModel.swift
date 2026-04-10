//
//  UserFilterModel.swift
//  DesynatAdmin
//
//  Created by fluper on 21/11/25.
//


struct UserFilterModel {
    var countryId: Int?
    var fromDate: String?
    var toDate: String?
    
    var isEmpty: Bool {
        return countryId == nil && fromDate == nil && toDate == nil
    }
}

struct FullScreenBannerFilterModel {
    var bannerType: Int?
    var bannerName: String?
    var countryName: String?
    var fromDate: String?
    var toDate: String?
    
    var isEmpty: Bool {
        return bannerType == nil && bannerName == nil && countryName == nil && fromDate == nil && toDate == nil
    }
}

struct PaymentFilterModel {
    var countryId: Int?
    var fromDate: String?
    var toDate: String?
    var status: String?
    
    var isEmpty: Bool {
        return countryId == nil && fromDate == nil && toDate == nil && status == nil
    }
}
