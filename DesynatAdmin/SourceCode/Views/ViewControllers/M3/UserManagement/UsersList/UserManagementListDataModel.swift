//
//  UserManagementListDataModel.swift
//  DesynatAdmin
//
//  Created by fluper on 21/11/25.
//

import Foundation

// MARK: - UsersManagmentListModel
struct UsersManagmentListModel: Codable {
    let currentPage: Int?
    let data: [UsersListModel]?
    let firstPageURL: String?
    let from, lastPage: Int?
    let lastPageURL: String?
    let links: [Link]?
    let nextPageURL, path: String?
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

// MARK: - UsersListModel
struct UsersListModel: Codable {
    let id: Int?
    let profileImage: String?
    let fullName, countryCode, mobile, email: String?
    let emailVerifiedAt: String?
    let otp: String?
    let otpVerify, deviceType: String?
    let deviceToken, datumLet, long: String?
    var status: String?
    let createdAt, updatedAt: String?
    let countryInfo: CountryInfo?
    let walletInfo: WalletInfo?

    enum CodingKeys: String, CodingKey {
        case id
        case profileImage = "profile_image"
        case fullName = "full_name"
        case countryCode = "country_code"
        case mobile, email
        case emailVerifiedAt = "email_verified_at"
        case otp
        case otpVerify = "otp_verify"
        case deviceType = "device_type"
        case deviceToken = "device_token"
        case datumLet = "let"
        case long, status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case countryInfo = "country_info"
        case walletInfo = "wallet_info"
    }
}

// MARK: - CountryInfo
struct CountryInfo: Codable {
    let id: Int?
    let name, code, isoCode, isoCodeNumber: String?
    let currencyName, currencyCode, currencySymbol, exchangeRateToUsd: String?
    let dialCode: String?
    let flag: String?

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
    }
}

// MARK: - WalletInfo
struct WalletInfo: Codable {
    let id, userID: Int?
    let amount, createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case amount
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
