//
//  SellerPayoutListDataModel.swift
//  DesynatAdmin
//
//  Created by fluper_mac3 on 19/03/26.
//

import Foundation

// MARK: - SellerPayoutModel
struct SellerPayoutModel: Codable {
    let totalPayoutPending: String?
    let sellers: SellerPayoutListDataModel?

    enum CodingKeys: String, CodingKey {
        case totalPayoutPending = "total_payout_pending"
        case sellers
    }
}

// MARK: - Sellers
struct SellerPayoutListDataModel: Codable {
    let currentPage: Int?
    let data: [SellerPayoutListDataList]?
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

// MARK: - SellerPayoutListDataList
struct SellerPayoutListDataList: Codable {
    let id: Int?
    let type: String?
    let parentID: String?
    let profilePic: String?
    let firstName, lastName, countryCode, mobile: String?
    let email, password, acceptTerms, otp: String?
    let otpVerify, deviceType: String?
    let deviceToken: String?
    let adminVerify, storeInformation, bankInformation: String?
    let rejectReason: String?
    let lang: String?
    let isBlock: Int?
    let affilateCommission, fcmToken: String?
    let profileQr: String?
    let qrSellerURL: String?
    let createdAt, updatedAt: String?
    let notification, appNotification: Int?
    let nameAr, selectCategory, savePassword, deletedAt: String?
    let sellerName: String?
    let countryName, currencyCode, currencySymbol: String?
    let totalEarning, lastPayout: String?
    let lastPayoutDate: String?
    let pendingAmount: String?
    let storeInfo: StoreInfo?

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
        case sellerName = "seller_name"
        case countryName = "country_name"
        case currencyCode = "currency_code"
        case currencySymbol = "currency_symbol"
        case totalEarning = "total_earning"
        case lastPayout = "last_payout"
        case lastPayoutDate = "last_payout_date"
        case pendingAmount = "pending_amount"
        case storeInfo = "store_info"
    }
}

