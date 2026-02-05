//
//  GetPromotionalBannersList.swift
//  DesynatAdmin
//
//  Created by fluper_mac3 on 05/02/26.
//

import Foundation

// MARK: - GetPromotionalBannersDataModel
struct GetPromotionalBannersDataModel: Codable {
    let currentPage: Int?
    let data: [GetPromotionalBannersList]?
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

// MARK: - GetPromotionalBannersList
struct GetPromotionalBannersList: Codable {
    let id: Int?
    let orderID: String?
    let sellerID: String?
    let bannerPosition: String?
    let category, subcatgory: String?
    let startDate, endDate, totalDays: String?
    let uploadBanner: String?
    let price: String?
    let addedBy, adminVerify, paymentStatus: String?
    let transactionID, cancelledReason: String?
    let status, createdAt, updatedAt: String?
    let categoryDetails: CategoryDetails?
    let subcategoryDetails: SubcategoryDetails?

    enum CodingKeys: String, CodingKey {
        case id
        case orderID = "order_id"
        case sellerID = "seller_id"
        case bannerPosition = "banner_position"
        case category, subcatgory
        case startDate = "start_date"
        case endDate = "end_date"
        case totalDays = "total_days"
        case uploadBanner = "upload_banner"
        case price
        case addedBy = "added_by"
        case adminVerify = "Admin_verify"
        case paymentStatus = "payment_status"
        case transactionID = "transaction_id"
        case cancelledReason = "cancelled_reason"
        case status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case categoryDetails = "category_details"
        case subcategoryDetails = "subcategory_details"
    }
}
