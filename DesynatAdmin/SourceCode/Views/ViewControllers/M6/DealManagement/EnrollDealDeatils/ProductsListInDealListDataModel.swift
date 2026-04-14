//
//  ProductsListInDealListDataModel.swift
//  DesynatAdmin
//
//  Created by fluper_mac3 on 29/01/26.
//

import Foundation

// MARK: - ProductsListInDealListDataModel
struct ProductsListInDealListDataModel: Codable {
    let id: Int?
    let image: String?
    let nameEnglish, nameArabic: String?
    let categoryID: Int?
    let subCategoryID: [String]?
    let discount, from, to: String?
    let status: Int?
    let createdAt, updatedAt: String?
    let categoryDetails: CategoryDetails?
    let subCategoryDetails: SubCategoryDetails?
    let sellerDealrecords: [SellerDealrecord]?

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
        case sellerDealrecords = "seller_dealrecords"
    }
}

