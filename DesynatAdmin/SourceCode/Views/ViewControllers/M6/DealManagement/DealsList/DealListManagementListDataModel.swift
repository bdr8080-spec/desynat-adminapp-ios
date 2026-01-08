//
//  DealListManagementListDataModel.swift
//  DesynatAdmin
//
//  Created by fluper on 08/01/26.
//

import Foundation

// MARK: - DealListManagementListDataModel
struct DealListManagementListDataModel: Codable {
    let currentPage: Int?
    let data: [DealListManagementList]?
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

// MARK: - DealListManagementList
struct DealListManagementList: Codable {
    let id: Int?
    let image: String?
    let nameEnglish, nameArabic: String?
    let categoryID, subCategoryID: Int?
    let discount, from, to: String?
    var status: Int?
    let createdAt, updatedAt: String?
    let categoryDetails: CategoryDetails?
    let subCategoryDetails: SubCategoryDetails?

    enum CodingKeys: String, CodingKey {
        case id, image
        case nameEnglish = "name_english"
        case nameArabic = "name_arabic"
        case categoryID = "category_id"
        case subCategoryID = "sub_category_id"
        case discount, from, to, status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case categoryDetails = "category_details"
        case subCategoryDetails = "sub_category_details"
    }
}

// MARK: - SubCategoryDetails
struct SubCategoryDetails: Codable {
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
