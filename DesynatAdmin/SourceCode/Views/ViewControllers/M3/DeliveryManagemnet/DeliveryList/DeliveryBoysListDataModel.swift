//
//  DeliveryBoysListDataModel.swift
//  DesynatAdmin
//
//  Created by fluper on 21/11/25.
//

import Foundation

// MARK: - DeliveryBoysListDataModel
struct DeliveryBoysListDataModel: Codable {
    let currentPage: Int?
    let data: [DeliveryBoysList]?
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

// MARK: - DeliveryBoysList
struct DeliveryBoysList: Codable {
    let id: Int?
    let profilePic: String?
    let fullNameEnglish, fullNameArabic, email, countryCode: String?
    let mobile, password: String?
    let unhashedPassword: String?
    let addressLine1, addressLine2, city, state: String?
    let datumLet, long: String?
    let countryID, zoneID: Int?
    let otp: String?
    let otpVerify, deviceType: String?
    let deviceToken: String?
    let vehicleName, vehicleRegNo, documentInformation: String?
    var status: String?
    let createdAt, updatedAt: String?
    let vehicleImage, identityProof, drivingLicense, vehicleInsurance: [DrivingLicense]?
    let pollutionPaper, registrationCertificate: [DrivingLicense]?
    let zoneInfo: DriverBoyZoneInfo?

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
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case vehicleImage = "vehicle_image"
        case identityProof = "identity_proof"
        case drivingLicense = "driving_license"
        case vehicleInsurance = "vehicle_insurance"
        case pollutionPaper = "pollution_paper"
        case registrationCertificate = "registration_certificate"
        case zoneInfo = "zone_info"
    }
}

// MARK: - DrivingLicense
struct DrivingLicense: Codable {
    let id, deliveryBoyID: Int?
    let documentType: String?
    let documentPath: String?
    let isFront, status: Int?
    let createdAt, updatedAt: AtedAt?

    enum CodingKeys: String, CodingKey {
        case id
        case deliveryBoyID = "delivery_boy_id"
        case documentType = "document_type"
        case documentPath = "document_path"
        case isFront = "is_front"
        case status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

enum AtedAt: String, Codable {
    case the20251119T103835000000Z = "2025-11-19T10:38:35.000000Z"
    case the20251120T064623000000Z = "2025-11-20T06:46:23.000000Z"
}

// MARK: - DriverBoyZoneInfo
struct DriverBoyZoneInfo: Codable {
    let id, countryID, cityID: Int?
    let nameEnglish, nameArabic: String?
    let coordinates: [Coordinate]?
    let status: Int?
    let createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case countryID = "country_id"
        case cityID = "city_id"
        case nameEnglish = "name_english"
        case nameArabic = "name_arabic"
        case coordinates, status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

// MARK: - Coordinate
struct Coordinate: Codable {
    let lat, lng: String?
}

