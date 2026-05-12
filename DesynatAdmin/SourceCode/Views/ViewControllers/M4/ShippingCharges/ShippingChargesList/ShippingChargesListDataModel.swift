//
//  ShippingChargesListDataModel.swift
//  DesynatAdmin
//
//  Created by fluper on 09/12/25.
//

import Foundation

// MARK: - ShippingChargesDataModel
struct ShippingChargesDataModel: Codable {
    let id: Int?
    let name,nameAr, isoCode, currencyName, currencyCode: String?
    let currencySymbol, dialCode, flag: String?
    let flag1: String?
    let exchangeRateToKwd, createdAt, updatedAt: String?
    let taxInfo: TaxInfo?
    var shippingInfo: [ShippingInfo]?

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
        case taxInfo = "tax_info"
        case shippingInfo = "shipping_info"
        case nameAr = "name_ar"
    }
}

// MARK: - ShippingInfo
struct ShippingInfo: Codable {
    let id, countryID: Int?
    let rangeFrom, rangeTo, shippingFee: String?
    var status: Int?
    let createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case countryID = "country_id"
        case rangeFrom = "range_from"
        case rangeTo = "range_to"
        case shippingFee = "shipping_fee"
        case status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

// MARK: - TaxInfo
struct TaxInfo: Codable {
    let id, countryID: Int?
    let tax: String?
    let status: Int?
    let createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case countryID = "country_id"
        case tax, status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
