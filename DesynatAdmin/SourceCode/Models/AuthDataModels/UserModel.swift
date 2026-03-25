//
//  Welcome.swift
//  DesynatUser
//
//  Created by Rakhi Kumari on 30/10/25.
//


// MARK: - UserModel
struct UserModel: Codable {
    let id, deviceType: Int?
    let fullName, countryCode, mobile, email, profileImage: String?
    let emailVerifiedAt: String?
    let otp, otpVerify: String?
    let fcmToken: String?
    let createdAt, updatedAt, accessToken: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case fullName = "full_name"
        case countryCode = "country_code"
        case mobile, email
        case emailVerifiedAt = "email_verified_at"
        case otp
        case otpVerify = "otp_verify"
        case deviceType = "device_type"
        case fcmToken = "fcm_token"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case accessToken
        case profileImage = "profile_image"
    }
}
