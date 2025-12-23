//
//  DeliveryBoyListModel.swift
//  DesynatAdmin
//
//  Created by Chandra Prakash on 23/12/25.
//

import Foundation

// MARK: - DeliveryBoyListModel
struct DeliveryBoyListModel: Codable {
    var id: Int?
    var profilePic: String?
    var fullNameEnglish, fullNameArabic, email, countryCode: String?
    var mobile, password, unhashedPassword, addressLine1: String?
    var addressLine2, city, state, datumLet: String?
    var long: String?
    var countryID, zoneID: Int?
    var otp, otpVerify, deviceType, deviceToken: String?
    var vehicleName, vehicleRegNo, documentInformation, status: String?
    var onDuty, createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case profilePic = "profile_pic"
        case fullNameEnglish = "full_name_english"
        case fullNameArabic = "full_name_arabic"
        case email
        case countryCode = "country_code"
        case mobile, password
        case unhashedPassword = "unhashed_password"
        case addressLine1 = "address_line1"
        case addressLine2 = "address_line2"
        case city, state
        case datumLet = "let"
        case long
        case countryID = "country_id"
        case zoneID = "zone_id"
        case otp
        case otpVerify = "otp_verify"
        case deviceType = "device_type"
        case deviceToken = "device_token"
        case vehicleName = "vehicle_name"
        case vehicleRegNo = "vehicle_reg_no"
        case documentInformation = "document_information"
        case status
        case onDuty = "on_duty"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
