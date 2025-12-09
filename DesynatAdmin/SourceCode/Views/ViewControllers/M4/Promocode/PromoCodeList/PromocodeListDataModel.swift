//
//  PromocodeListDataModel.swift
//  DesynatAdmin
//
//  Created by fluper on 09/12/25.
//

import Foundation

// MARK: - PromocodeListDataModel
struct PromocodeListDataModel: Codable {
    let currentPage: Int?
    let data: [PromocodeList]?
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

// MARK: - PromocodeList
struct PromocodeList: Codable {
    let id, countryID: Int?
    let nameEnglish, nameArabic, descriptionEnglish, descriptionArabic: String?
    let applicableFor: Int?
    let discountPercent, minOrderValue, uptoDiscount, startDate: String?
    let endDate: String?
    let status: Int?
    let createdAt, updatedAt: String?
    let countryInfo: CountryInfo?

    enum CodingKeys: String, CodingKey {
        case id
        case countryID = "country_id"
        case nameEnglish = "name_english"
        case nameArabic = "name_arabic"
        case descriptionEnglish = "description_english"
        case descriptionArabic = "description_arabic"
        case applicableFor = "applicable_for"
        case discountPercent = "discount_percent"
        case minOrderValue = "min_order_value"
        case uptoDiscount = "upto_discount"
        case startDate = "start_date"
        case endDate = "end_date"
        case status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case countryInfo = "country_info"
    }
}

