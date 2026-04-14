//
//  CMSTermsConditionDataModel.swift
//  DesynatAdmin
//
//  Created by fluper_mac3 on 16/03/26.
//

import Foundation

// MARK: - CMSTermsConditionDataModel
struct CMSTermsConditionDataModel: Codable {
    let id, type: Int?
    let title, slug, contentEnglish, contentArabic: String?
    let createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id, type, title, slug
        case contentEnglish = "content_english"
        case contentArabic = "content_arabic"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
