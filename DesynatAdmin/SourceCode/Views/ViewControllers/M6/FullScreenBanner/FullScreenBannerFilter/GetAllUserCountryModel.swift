//
//  GetAllUserCountryModel.swift
//  DesynatAdmin
//
//  Created by fluper on 08/01/26.
//


// MARK: - GetAllUserCountryModel
struct GetAllUserCountryModel: Codable {
  let id: Int?
  let name,nameAr, code, isoCode: String?
  let isoCodeNumber: String?
  let currencyName, currencyCode, currencySymbol: String?
  let exchangeRateToUsd: String?
  let dialCode: String?
  let flag: String?
  let flag1: String?
  
  enum CodingKeys: String, CodingKey {
    case id, name, code
    case isoCode = "iso_code"
    case isoCodeNumber = "iso_code_number"
    case currencyName = "currency_name"
    case currencyCode = "currency_code"
    case currencySymbol = "currency_symbol"
    case exchangeRateToUsd = "exchange_rate_to_usd"
    case dialCode = "dial_code"
    case flag
    case flag1 = "flag1"
    case nameAr = "name_ar"
  }
}
