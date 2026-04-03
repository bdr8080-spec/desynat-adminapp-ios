//
//  CurrentRequest.swift
//  DesynatAdmin
//
//  Created by fluper_mac3 on 03/04/26.
//

// MARK: - AgroaTokenDataModel
struct AgroaTokenDataModel: Codable {
    let token: String?
    let uid: UInt?
}

struct ShowLiveEvenetsDataModel: Codable {
    let id: Int?
    let timeslotId: Int?
    let sellerId: Int?
    let orderId: Int?
    let adminVerify: Int?
    let rejectReason: String?
    let cancelReason: String?
    let channelId: String?
    let uid: UInt?  // 700773128
    let liveToken: String?
    let createdAt: String?
    let updatedAt: String?
    let sellerDetails: SellerDetails?
    let timeslotDetails: TimeslotDetails?
    
    enum CodingKeys: String, CodingKey {
        case id, uid
        case timeslotId = "timeslot_id"
        case sellerId = "seller_id"
        case orderId = "order_id"
        case adminVerify = "admin_verify"
        case rejectReason = "reject_reason"
        case cancelReason = "cancel_reason"
        case channelId = "channel_id"
        case liveToken = "liveToken"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case sellerDetails = "seller_details"
        case timeslotDetails = "timeslot_details"
    }
}

//struct SellerDetails: Codable {
//    let id: Int
//    let profilePic: String?
//    let firstName: String
//    let lastName: String
//    let countryCode: String
//    let mobile: String
//    let email: String
//    let adminVerify: String
//    let storeInformation: String
//    let bankInformation: String
//    let lang: String
//    let isBlock: Int
//    let profileQr: String?
//    let qrSellerUrl: String?
//    
//    enum CodingKeys: String, CodingKey {
//        case id
//        case profilePic = "profile_pic"
//        case firstName = "first_name"
//        case lastName = "last_name"
//        case countryCode = "country_code"
//        case mobile
//        case email
//        case adminVerify = "admin_verify"
//        case storeInformation = "store_information"
//        case bankInformation = "bank_information"
//        case lang
//        case isBlock = "is_block"
//        case profileQr = "profile_qr"
//        case qrSellerUrl = "qrSellerUrl"
//    }
