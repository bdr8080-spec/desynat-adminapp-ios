//
//  GetCategoryModel.swift
//  DesynatAdmin
//
//  Created by Rakhi Kumari on 01/11/25.
//

import Foundation

// MARK: - GetCategoryModel
struct GetCategoryModel: Codable {
    let id: Int?
    let name, description: String?
    let image: String?
    var status: Int?
    let colorCode: String?
    let createdAt, updatedAt: String?
    let nameAr:String?

    enum CodingKeys: String, CodingKey {
        case id, name, description, image, status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case colorCode = "color_code"
        case nameAr = "name_ar"
    }
}
