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
  var status: Int?
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


// MARK: - DataClass
struct LiveRequestPermissionDataModel: Codable {
    let currentPage: Int?
    let data: [LiveRequestPermissionList]?
    let firstPageURL: String?
    let from, lastPage: Int?
    let lastPageURL: String?
    let links: [Link]?
    let nextPageURL: String?
    let path: String?
    let perPage: Int?
    let prevPageURL: String?
    let to, total: Int?

    enum CodingKeys: String, CodingKey {
        case currentPage = "current_page"
        case data
        case firstPageURL = "first_page_url"
        case from
        case lastPage = "last_page"
        case lastPageURL = "last_page_url"
        case links
        case nextPageURL = "next_page_url"
        case path
        case perPage = "per_page"
        case prevPageURL = "prev_page_url"
        case to, total
    }
}

// MARK: - LiveRequestPermissionList
struct LiveRequestPermissionList: Codable {
    let id, timeslotID, sellerID, orderID: Int?
    let adminVerify: Int?
    let rejectReason: String?
    let createdAt, updatedAt: String?
    let timeslotDetails: TimeslotDetails?
    let sellerDetails: SellerDetails?

    enum CodingKeys: String, CodingKey {
        case id
        case timeslotID = "timeslot_id"
        case sellerID = "seller_id"
        case orderID = "order_id"
        case adminVerify = "admin_verify"
        case rejectReason = "reject_reason"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case timeslotDetails = "timeslot_details"
        case sellerDetails = "seller_details"
    }
}

// MARK: - TimeslotDetails
struct TimeslotDetails: Codable {
    let id, countryID: Int?
    let date, from, to: String?
    let status: Int?
    let createdAt, updatedAt: String?
    let countryInfo: CountryDetails?

    enum CodingKeys: String, CodingKey {
        case id
        case countryID = "country_id"
        case date, from, to, status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case countryInfo = "country_info"
    }
}
