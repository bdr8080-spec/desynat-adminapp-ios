//
//  LiveRequestListDataModel.swift
//  DesynatAdmin
//
//  Created by fluper on 08/01/26.
//

import Foundation

// MARK: - LiveRequestListDataModel
struct LiveRequestListDataModel: Codable {
  let id, countryID: Int?
  let date, from, to: String?
  let status: Int?
  let createdAt, updatedAt: String?
  let countryInfo: CountryCodeInfo?
  
  enum CodingKeys: String, CodingKey {
    case id
    case countryID = "country_id"
    case date, from, to, status
    case createdAt = "created_at"
    case updatedAt = "updated_at"
    case countryInfo = "country_info"
  }
}

// MARK: - CountryCodeInfo
struct CountryCodeInfo: Codable {
  let id: Int?
  let name, isoCode, currencyName, currencyCode: String?
  let currencySymbol, dialCode, flag: String?
  let flag1: String?
  let exchangeRateToKwd, createdAt, updatedAt: String?
  
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
  }
}
