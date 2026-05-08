//
//  GetCountryDataModel.swift
//  DesynatAdmin
//
//  Created by Rakhi Kumari on 01/11/25.
//

import Foundation

// MARK: - GetCountryDataModel
struct GetCountryDataModel: Codable {
    let id: Int?
    let name,nameAr, isoCode, currencyName, currencyCode: String?
    let currencySymbol, dialCode, flag, exchangeRateToKwd: String?
    let createdAt, updatedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case isoCode = "iso_code"
        case currencyName = "currency_name"
        case currencyCode = "currency_code"
        case currencySymbol = "currency_symbol"
        case dialCode = "dial_code"
        case flag
        case exchangeRateToKwd = "exchange_rate_to_kwd"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case nameAr = "name_ar"
    }
}


struct GetCityDataModel: Codable {
    let id: Int?
    let countryId: Int?
    let name: String?
    let createdAt, updatedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case countryId = "country_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
