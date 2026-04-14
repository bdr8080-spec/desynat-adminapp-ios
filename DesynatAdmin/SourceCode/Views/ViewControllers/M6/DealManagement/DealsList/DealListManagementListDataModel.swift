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
    let categoryID: Int?
    let subCategoryID: [String]?
    let discount, from, to: String?
    var status: Int?
    let createdAt, updatedAt: String?
    let categoryDetails: CategoryDetails?
    let subCategoryDetails: [SubCategoryDetails]?
    let sellerDealrecords: [SellerDealrecord]?
    let sellerEnrolled: SellerEnrolled?
    
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
        case subCategoryDetails = "subCategory_details" //subCategory_details
        case sellerDealrecords = "seller_dealrecords"
        case sellerEnrolled = "seller_enrolled"
    }
}

// MARK: - SellerEnrolled
struct SellerEnrolled: Codable {
    let dealID, sellerCount: Int?

    enum CodingKeys: String, CodingKey {
        case dealID = "deal_id"
        case sellerCount = "seller_count"
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

// MARK: - SellerDealrecord
struct SellerDealrecord: Codable {
    let dealID: Int?
    let sellerID: String?
    let productCount: Int?
    let sellerDetails: SellerDetails?
    let products: [Product]?

    enum CodingKeys: String, CodingKey {
        case dealID = "deal_id"
        case sellerID = "seller_id"
        case productCount = "product_count"
        case sellerDetails = "seller_details"
        case products
    }
}

// MARK: - Product
struct Product: Codable {
    let id, dealID: Int?
    let sellerID: String?
    let productID: Int?
    let discount, createdAt, updatedAt: String?
    let productDetails: ProductDetails?

    enum CodingKeys: String, CodingKey {
        case id
        case dealID = "deal_id"
        case sellerID = "seller_id"
        case productID = "product_id"
        case discount
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case productDetails = "product_details"
    }
}
