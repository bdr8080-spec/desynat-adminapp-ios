//
//  SubAdminListDataModel.swift
//  DesynatAdmin
//
//  Created by fluper_mac3 on 20/04/26.
//

import Foundation

// MARK: - StaffDetailsDataModel
struct StaffDetailsDataModel: Codable {
    let list: StaffDetailsDataList?
    let totalCount: Int?
    let totalActiveCount: Int?
    let totalInactiveCount: Int?
    
    enum CodingKeys: String, CodingKey {
        case list
        case totalCount = "total_count"
        case totalActiveCount = "total_active_count"
        case totalInactiveCount = "total_inactive_count"
    }
}

// MARK: - StaffDetailsDataList
struct StaffDetailsDataList: Codable {
    let currentPage: Int?
    let data: [StaffDetails]?
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

// MARK: - StaffDetails
struct StaffDetails: Codable {
    let id: Int?
    let type: String?
    let profilePic: String?
    let fullName, fullNameInArabic, countryID, countryCode, mobile: String?
    let email: String?
    let emailVerifiedAt: String?
    let password, unhashedPassword: String?
    let otp: String?
    let otpVerify, deviceType: String?
    let fcmToken, rememberToken: String?
    var status: String?
    let createdAt, updatedAt: String?
    let notification, appNotification, selectedRole: Int?
    let countryInfo: CountryInfo?
    let permissionDetails: [PermissionDetail]?
    
    enum CodingKeys: String, CodingKey {
        case id, type
        case profilePic = "profile_pic"
        case fullName = "full_name"
        case countryID = "country_id"
        case countryCode = "country_code"
        case mobile, email
        case emailVerifiedAt = "email_verified_at"
        case password
        case unhashedPassword = "unhashed_password"
        case otp
        case otpVerify = "otp_verify"
        case deviceType = "device_type"
        case fcmToken = "fcm_token"
        case rememberToken = "remember_token"
        case status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case notification
        case appNotification = "app_notification"
        case countryInfo = "country_info"
        case permissionDetails = "permission_details"
        case fullNameInArabic = "full_name_ar"
        case selectedRole = "selected_role"
    }
}

// MARK: - PermissionDetail
struct PermissionDetail: Codable {
    let id, adminID, moduleID, canView: Int?
    let canAction: Int?
    let createdAt, updatedAt: String?
    let moduleDetails: ModuleDetails?
    
    enum CodingKeys: String, CodingKey {
        case id
        case adminID = "admin_id"
        case moduleID = "module_id"
        case canView = "can_view"
        case canAction = "can_action"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case moduleDetails = "module_details"
    }
}

// MARK: - ModuleDetails
struct ModuleDetails: Codable {
    let id: Int?
    let name,icon, displayName, createdAt, updatedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name, icon
        case displayName = "display_name"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
