//
//  SellerDataModel.swift
//  DesynatAdmin
//
//  Created by Meet Goti on 07/11/25.
//

import Foundation
struct SellerModel:Codable {
    var currentPage: Int?
    var data: [SellerDataModel]?
    var firstPageURL: String?
    var from, lastPage: Int?
    var lastPageURL: String?
    var links: [Link]?
    var nextPageURL: String?
    var path: String?
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

struct SellerDataModel: Codable {

    var id: Int?
    var profilePic: String?
    var firstName: String?
    var lastName: String?
    var countryCode: String?
    var mobile: String?
    var email: String?
    var password: String?
    var acceptTerms: String?
    var otp: String?
    var otpVerify: String?
    var deviceType: String?
    var deviceToken: String?
    var adminVerify: String?
    var storeInformation: String?
    var bankInformation: String?
    var rejectReason: String?
    @DefaultCodable<DefaultNilStrategy> var lang: [String]?
    var isBlock: Int?
    var createdAt: String?
    var updatedAt: String?
    var storeInfo: StoreInfo?
    var ownerDocument: [OwnerDocument]?
    var storeDocument: [StoreDocument]?
    var sellerBankDetails: SellerBankDetails?

    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case profilePic = "profile_pic"
        case firstName = "first_name"
        case lastName = "last_name"
        case countryCode = "country_code"
        case mobile = "mobile"
        case email = "email"
        case password = "password"
        case acceptTerms = "accept_terms"
        case otp = "otp"
        case otpVerify = "otp_verify"
        case deviceType = "device_type"
        case deviceToken = "device_token"
        case adminVerify = "admin_verify"
        case storeInformation = "store_information"
        case bankInformation = "bank_information"
        case rejectReason = "reject_reason"
        case lang = "lang"
        case isBlock = "is_block"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case storeInfo = "store_info"
        case ownerDocument = "owner_document"
        case storeDocument = "store_document"
        case sellerBankDetails = "seller_bank_details"
    }

}
struct StoreInfo: Codable {

    var id: Int?
    var sellerId: Int?
    var storeImage: String?
    var storeName: String?
    var country: String?
    var countryInfo: GetCountryDataModel?
    var storeAddress: String?
    var addressLine1: String?
    var addressLine2: String?
    var storePhone: String?
    var countryCode: String?
    var storeMailId: String?
    var bio: String?
    var letField: String?
    var long: String?
    var createdAt: String?
    var updatedAt: String?

    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case sellerId = "seller_id"
        case storeImage = "store_image"
        case storeName = "store_name"
        case country = "country"
        case countryInfo = "country_info"
        case storeAddress = "store_address"
        case addressLine1 = "address_line1"
        case addressLine2 = "address_line2"
        case storePhone = "store_phone"
        case countryCode = "country_code"
        case storeMailId = "store_mail_id"
        case bio = "bio"
        case letField = "let"
        case long = "long"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }

}
struct OwnerDocument: Codable {

    var id: Int?
    var sellerId: Int?
    var documentType: String?
    var documentPath: String?
    var status: String?
    var createdAt: String?
    var updatedAt: String?

    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case sellerId = "seller_id"
        case documentType = "document_type"
        case documentPath = "document_path"
        case status = "status"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }

}


struct StoreDocument: Codable {

    var id: Int?
    var sellerId: Int?
    var documentType: String?
    var documentPath: String?
    var status: String?
    var createdAt: String?
    var updatedAt: String?

    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case sellerId = "seller_id"
        case documentType = "document_type"
        case documentPath = "document_path"
        case status = "status"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }

}
struct SellerBankDetails: Codable {

    var id: Int?
    var userId: String?
    var type: String?
    var accountType: String?
    @DefaultCodable<DefaultNilStrategy> var iban: String?
    @DefaultCodable<DefaultNilStrategy> var swift: String?
    var bankName: String?
    var accountHolderName: String?
    var uploadProof: String?
    var createdAt: String?
    var updatedAt: String?

    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case userId = "user_id"
        case type = "type"
        case accountType = "account_type"
        case iban = "iban"
        case swift = "swift"
        case bankName = "bank_name"
        case accountHolderName = "account_holder_name"
        case uploadProof = "upload_proof"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }

}
