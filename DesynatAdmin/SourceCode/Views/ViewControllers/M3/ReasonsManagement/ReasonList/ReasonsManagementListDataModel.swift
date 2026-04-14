//
//  ReasonsManagementListDataModel.swift
//  DesynatAdmin
//
//  Created by fluper on 21/11/25.
//

import Foundation

// MARK: - ReasonManagmentListModel
struct ReasonManagmentListModel: Codable {
    let currentPage: Int?
    let data: [ReasonsListModel]?
    let firstPageURL: String?
    let from, lastPage: Int?
    let lastPageURL: String?
    let links: [Link]?
    let nextPageURL, path: String?
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

// MARK: - ReasonsListModel
struct ReasonsListModel: Codable {
    let id: Int?
    let reasonEnglish, reasonArabic: String?
    let type: Int?
    var status: Int?
    let createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case reasonEnglish = "reason_english"
        case reasonArabic = "reason_arabic"
        case type, status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
