//
//  AffiliatedCommissionDataModel.swift
//  DesynatAdmin
//
//  Created by fluper on 16/12/25.
//

import Foundation

// MARK: - CommissionPercentageModel
struct CommissionPercentageModel: Codable {
    var id: Int?
    var name,nameAr, isoCode, currencyName, currencyCode: String?
    var currencySymbol, dialCode, flag: String?
    var flag1: String?
    var exchangeRateToKwd, createdAt, updatedAt: String?
    var affiliateCommissionInfo: AffiliateCommissionInfo?

    enum CodingKeys: String, CodingKey {
        case id, name
        case isoCode = "iso_code"
        case currencyName = "currency_name"
        case currencyCode = "currency_code"
        case currencySymbol = "currency_symbol"
        case dialCode = "dial_code"
        case flag, flag1
        case exchangeRateToKwd = "exchange_rate_to_kwd"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case affiliateCommissionInfo = "affiliate_commission_info"
        case nameAr = "name_ar"
    }
}

// MARK: - AffiliateCommissionInfo
struct AffiliateCommissionInfo: Codable {
    var id, countryID: Int?
    var commission: String?
    var status: Int?
    var createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case countryID = "country_id"
        case commission, status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
