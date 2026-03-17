//
//  ContactUsDataModel.swift
//  DesynatAdmin
//
//  Created by fluper_mac3 on 17/03/26.
//

import Foundation

// MARK: - ContactUsDataModel
struct ContactUsDataModel: Codable {
    let id, type: Int?
    let title, slug: String?
    let contentEnglish: ContentEnglish?
    let contentArabic: ContentEnglish?
    let createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id, type, title, slug
        case contentEnglish = "content_english"
        case contentArabic = "content_arabic"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

// MARK: - ContentEnglish
struct ContentEnglish: Codable {
    let email, mobile, whatsapp: String?
}
