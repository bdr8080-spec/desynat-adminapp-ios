//
//  FullScreenBannerModel.swift
//  DesynatAdmin
//
//  Created by fluper on 08/01/26.
//

import Foundation

// MARK: - FullScreenBannerDataModel
struct FullScreenBannerDataModel: Codable {
    let currentPage: Int?
    let data: [FullScreenBannerDataList]?
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

// MARK: - FullScreenBannerDataList
struct FullScreenBannerDataList: Codable {
    let id: Int?
    let image, type: String?
//    let countryID: String?
    let title, startDate, endDate: String?
    let status: Int?
    let createdAt, updatedAt: String?
    let countryInfo: CountryInfo?

    enum CodingKeys: String, CodingKey {
        case id, image
//        case countryID = "country_id"
        case title, type
        case startDate = "start_date"
        case endDate = "end_date"
        case status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case countryInfo = "country_info"
    }
}

