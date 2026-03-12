//
//  AffiliatedWithdrawalRequestDataModel.swift
//  DesynatAdmin
//
//  Created by fluper_mac3 on 10/03/26.
//

import Foundation

// MARK: - AffiliatedWithdrawalRequestDataModel
struct AffiliatedWithdrawalRequestDataModel: Codable {
    let currentPage: Int?
    let data: [AffiliatedWithdrawalList]?
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

// MARK: - AffiliatedWithdrawalList
struct AffiliatedWithdrawalList: Codable {
    let id: Int?
    let requestID: String?
    let type, userID, bankdetailsID: Int?
    let amount: String?
    let adminVerify: Int?
    let rejectReason: String?
    let transactionID, paymentStatus, createdAt, updatedAt: String?
    let totalEarning: String?
    let bankDetails: BankDetails?
    let affiliateDetails: AffiliateDetails?

    enum CodingKeys: String, CodingKey {
        case id
        case requestID = "request_id"
        case type
        case userID = "user_id"
        case bankdetailsID = "bankdetails_id"
        case amount
        case adminVerify = "admin_verify"
        case rejectReason = "reject_reason"
        case transactionID = "transaction_id"
        case paymentStatus = "payment_status"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case totalEarning = "total_earning"
        case bankDetails = "bank_details"
        case affiliateDetails = "affiliate__details"
    }
}

// MARK: - AffiliateDetails
struct AffiliateDetails: Codable {
    let id, userID: Int?
    let profileImage: String?
    let fullName, countryCode, mobile, email: String?
    let emailVerifiedAt: String?
    let password: String?
    let passwordOld: String?
    let document1: String?
    let document2, otp: String?
    let otpVerify, deviceType: String?
    let deviceToken, affiliateDetailsLet, long: String?
    let addressUpdateStatus, bankUpdateStatus, adminVerify: String?
    let rejectReason, rememberToken: String?
    let status: String?
    let lang: String?
    let createdAt, updatedAt: String?
    let countryDetails: CountryDetails?
    let addressDetails: AddressDetails?

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case profileImage = "profile_image"
        case fullName = "full_name"
        case countryCode = "country_code"
        case mobile, email
        case emailVerifiedAt = "email_verified_at"
        case password
        case passwordOld = "password_old"
        case document1, document2, otp
        case otpVerify = "otp_verify"
        case deviceType = "device_type"
        case deviceToken = "device_token"
        case affiliateDetailsLet = "let"
        case long
        case addressUpdateStatus = "address_update_status"
        case bankUpdateStatus = "bank_update_status"
        case adminVerify = "admin_verify"
        case rejectReason = "reject_reason"
        case rememberToken = "remember_token"
        case status, lang
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case countryDetails = "country_details"
        case addressDetails = "address_details"
    }
}
