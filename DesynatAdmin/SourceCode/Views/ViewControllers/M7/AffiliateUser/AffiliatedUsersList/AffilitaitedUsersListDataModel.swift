//
//  AffilitaitedUsersListDataModel.swift
//  DesynatAdmin
//
//  Created by fluper_mac3 on 23/01/26.
//

import Foundation

// MARK: - AffilitaitedUsersListDataModel
struct AffilitaitedUsersListDataModel: Codable {
    let currentPage: Int?
    let data: [AffilitaitedUsersDataModel]?
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

// MARK: - AffilitaitedUsersDataModel
struct AffilitaitedUsersDataModel: Codable {
    let id, userID: Int?
    let profileImage, fullName, countryCode, mobile: String?
    let email: String?
    let emailVerifiedAt: String?
    let password, document1, document2, otp: String?
    let otpVerify: String?
//    let otpVerify, deviceType: String?
    let deviceToken, datumLet, long: String?
    let addressUpdateStatus, bankUpdateStatus, adminVerify: String?
    let rejectReason, rememberToken: String?
    let status, createdAt, updatedAt: String?
    let addressDetails: AddressDetails?
    let bankDetails: [BankDetails]?
    let countryDetails: CountryDetails?

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case profileImage = "profile_image"
        case fullName = "full_name"
        case countryCode = "country_code"
        case mobile, email
        case emailVerifiedAt = "email_verified_at"
        case password, document1, document2, otp
        case otpVerify = "otp_verify"
//        case deviceType = "device_type"
        case deviceToken = "device_token"
        case datumLet = "let"
        case long
        case addressUpdateStatus = "address_update_status"
        case bankUpdateStatus = "bank_update_status"
        case adminVerify = "admin_verify"
        case rejectReason = "reject_reason"
        case rememberToken = "remember_token"
        case status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case addressDetails = "address_details"
        case bankDetails = "bank_details"
        case countryDetails = "country_details"
    }
}

// MARK: - AddressDetails
struct AddressDetails: Codable {
    let id, affiliateID: Int?
    let country, locations, address1, address2: String?
    let pincode, town, state, city: String?
    let addressDetailsLet, long, createdAt, updatedAt: String?
    let countryDetails: CountryDetails?

    enum CodingKeys: String, CodingKey {
        case id
        case affiliateID = "affiliate_id"
        case country, locations, address1, address2, pincode, town, state, city
        case addressDetailsLet = "let"
        case long
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case countryDetails = "country_details"
    }
}

// MARK: - BankDetails
struct BankDetails: Codable {
    let id: Int?
    let userID, type, accountType, accountNo: String?
    let iban, swift, bankName, accountHolderName: String?
    let uploadProof: String?
    let createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case type
        case accountType = "account_type"
        case accountNo = "account_no"
        case iban, swift
        case bankName = "bank_name"
        case accountHolderName = "account_holder_name"
        case uploadProof = "upload_proof"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

//extension AddressDetails {
//
//    var fullAddress: String {
//        let components: [String?] = [
//            address1,
//            address2,
//            addressDetailsLet,
//            locations,
//            town,
//            city,
//            state,
//            country,
//            pincode
//        ]
//
//        // Remove nil, empty, and duplicates (case-insensitive)
//        var seen = Set<String>()
//        let uniqueParts = components
//            .compactMap { $0?.trimmingCharacters(in: .whitespacesAndNewlines) }
//            .filter { !$0.isEmpty }
//            .filter {
//                let key = $0.lowercased()
//                if seen.contains(key) {
//                    return false
//                } else {
//                    seen.insert(key)
//                    return true
//                }
//            }
//
//        return uniqueParts.joined(separator: ", ")
//    }
//}

extension AddressDetails {

    var fullAddress: String {

        let components: [String?] = [
            address1,
            address2,
            addressDetailsLet,
            locations,
            town,
            city,
            state,
            country
            // ❌ pincode removed from here on purpose
        ]

        var seenWords = Set<String>()
        var finalComponents: [String] = []

        for component in components {
            guard let text = component?
                .trimmingCharacters(in: .whitespacesAndNewlines),
                  !text.isEmpty else { continue }

            let words = text
                .components(separatedBy: .whitespaces)
                .map { $0.trimmingCharacters(in: .punctuationCharacters) }
                .filter { !$0.isEmpty }

            var uniqueWords: [String] = []

            for word in words {
                let key = word.lowercased()
                if !seenWords.contains(key) {
                    seenWords.insert(key)
                    uniqueWords.append(word)
                }
            }

            if !uniqueWords.isEmpty {
                finalComponents.append(uniqueWords.joined(separator: " "))
            }
        }

        // ✅ Append pincode at the end (no word repetition check needed)
        if let pincode = pincode?.trimmingCharacters(in: .whitespacesAndNewlines),
           !pincode.isEmpty {
            finalComponents.append(pincode)
        }

        return finalComponents.joined(separator: ", ")
    }
}
