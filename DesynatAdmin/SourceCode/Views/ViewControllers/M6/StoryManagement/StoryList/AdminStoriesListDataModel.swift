//
//  AdminStoriesListDataModel.swift
//  DesynatAdmin
//
//  Created by fluper on 09/01/26.
//

import Foundation

// MARK: - AdminStoriesDataModel
struct AdminStoriesDataModel: Codable {
    let currentPage: Int?
    let data: [AdminStoriesList]?
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

// MARK: - AdminStoriesList
struct AdminStoriesList: Codable {
    let id, type: Int?
    let sellerID: String?
    let file, thumbnail: String?
    let status: Int?
    let createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id, type
        case sellerID = "seller_id"
        case file, status, thumbnail
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
//
//// MARK: - Link
//struct Link: Codable {
//    let url: String?
//    let label: String?
//    let active: Bool?
//}
