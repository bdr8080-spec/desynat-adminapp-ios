//
//  GetSubCategoryDataModel.swift
//  DesynatAdmin
//
//  Created by Rakhi Kumari on 01/11/25.
//

import Foundation

// MARK: - GetSubCategoryDataModel
struct GetSubCategoryDataModel: Codable {
    let currentPage: Int?
    let data: [GetSubCategoryDataList]?
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

// MARK: - GetSubCategoryDataList
struct GetSubCategoryDataList: Codable {
    let id, categoryID: Int?
    let nameEnglish, nameArabic: String?
    let image: String?
    let status: Int?
    let createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case categoryID = "category_id"
        case nameEnglish = "name_english"
        case nameArabic = "name_arabic"
        case image, status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

// MARK: - Link
struct Link: Codable {
    let url: String?
    let label: String?
    let active: Bool?
}
