//
//  SellerStoryRequestModel.swift
//  DesynatAdmin
//
//  Created by Fluper New Mac1 on 21/07/26.
//

import Foundation

// MARK: - DataClass
struct SellerStoryRequestManagementModel: Codable {
    var currentPage: Int?
    var data: [SellerStoryRequestManagementData]?
    var firstPageURL: String?
    var from, lastPage: Int?
    var lastPageURL: String?
    var links: [SellerStoryRequestManagementLink]?
    var nextPageURL, path: String?
    var perPage: Int?
    var prevPageURL: String?
    var to, total: Int?

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

// MARK: - Datum
struct SellerStoryRequestManagementData: Codable {
    var id, type, sellerID: Int?
    var file: String?
    var status: Int?
    var thumbnail: String?
    var createdAt, updatedAt, isPromotional, startDate: String?
    var endDate, totalDays, amount, adminVerify: String?
    var paymentStatus, transactionID: String?
    var rejectReason: String?
    var isSeen: Int?
    var sellerDetails: SellerStoryRequestManagementSellerDetails?

    enum CodingKeys: String, CodingKey {
        case id, type
        case sellerID = "seller_id"
        case file, status, thumbnail
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case isPromotional = "is_promotional"
        case startDate = "start_date"
        case endDate = "end_date"
        case totalDays = "total_days"
        case amount
        case adminVerify = "Admin_verify"
        case paymentStatus = "payment_status"
        case transactionID = "transaction_id"
        case rejectReason = "reject_reason"
        case isSeen = "is_seen"
        case sellerDetails = "seller_details"
    }
}

// MARK: - SellerDetails
struct SellerStoryRequestManagementSellerDetails: Codable {
    var id: Int?
    var type: String?
    var parentID: String?
    var profilePic: String?
    var firstName, lastName, countryCode, mobile: String?
    var email, password, acceptTerms, otp: String?
    var otpVerify, deviceType, deviceToken, adminVerify: String?
    var storeInformation, bankInformation: String?
    var rejectReason: String?
    var lang: String?
    var isBlock: Int?
    var affilateCommission, fcmToken: String?
    var profileQr: String?
    var qrSellerURL: String?
    var createdAt, updatedAt: String?
    var notification, appNotification: Int?
    var nameAr, selectCategory, savePassword, deletedAt: String?
    var storeInfo: SellerStoryRequestManagementStoreInfo?

    enum CodingKeys: String, CodingKey {
        case id, type
        case parentID = "parent_id"
        case profilePic = "profile_pic"
        case firstName = "first_name"
        case lastName = "last_name"
        case countryCode = "country_code"
        case mobile, email, password
        case acceptTerms = "accept_terms"
        case otp
        case otpVerify = "otp_verify"
        case deviceType = "device_type"
        case deviceToken = "device_token"
        case adminVerify = "admin_verify"
        case storeInformation = "store_information"
        case bankInformation = "bank_information"
        case rejectReason = "reject_reason"
        case lang
        case isBlock = "is_block"
        case affilateCommission = "affilate_commission"
        case fcmToken = "fcm_token"
        case profileQr = "profile_qr"
        case qrSellerURL = "qrSellerUrl"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case notification
        case appNotification = "app_notification"
        case nameAr = "name_ar"
        case selectCategory = "select_category"
        case savePassword = "save_password"
        case deletedAt = "deleted_at"
        case storeInfo = "store_info"
    }
}

// MARK: - StoreInfo
struct SellerStoryRequestManagementStoreInfo: Codable {
    var id, sellerID: Int?
    var storeImage: String?
    var storeName, country, storeAddress, addressLine1: String?
    var addressLine2, storePhone, countryCode, storeMailID: String?
    var storeAvailability: Int?
    var bio, storeInfoLet, long, createdAt: String?
    var updatedAt: String?
    var countryInfo: SellerStoryRequestManagementCountryInfo?

    enum CodingKeys: String, CodingKey {
        case id
        case sellerID = "seller_id"
        case storeImage = "store_image"
        case storeName = "store_name"
        case country
        case storeAddress = "store_address"
        case addressLine1 = "address_line1"
        case addressLine2 = "address_line2"
        case storePhone = "store_phone"
        case countryCode = "country_code"
        case storeMailID = "store_mail_id"
        case storeAvailability = "Store_Availability"
        case bio
        case storeInfoLet = "let"
        case long
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case countryInfo = "country_info"
    }
}

// MARK: - CountryInfo
struct SellerStoryRequestManagementCountryInfo: Codable {
    var id: Int?
    var name, nameAr, isoCode, currencyName: String?
    var currencyCode, currencyCodeAr, currencySymbol, dialCode: String?
    var flag: String?
    var flag1: String?
    var exchangeRateToKwd, createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id, name
        case nameAr = "name_ar"
        case isoCode = "iso_code"
        case currencyName = "currency_name"
        case currencyCode = "currency_code"
        case currencyCodeAr = "currency_code_ar"
        case currencySymbol = "currency_symbol"
        case dialCode = "dial_code"
        case flag, flag1
        case exchangeRateToKwd = "exchange_rate_to_kwd"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

// MARK: - Link
struct SellerStoryRequestManagementLink: Codable {
    var url: String?
    var label: String?
    var active: Bool?
}
