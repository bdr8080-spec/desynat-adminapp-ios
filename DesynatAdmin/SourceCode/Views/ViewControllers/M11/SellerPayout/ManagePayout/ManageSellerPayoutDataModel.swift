//
//  ManageSellerPayoutDataModel.swift
//  DesynatAdmin
//
//  Created by fluper_mac3 on 19/03/26.
//

import Foundation

// MARK: - SellerPayoutDetails
struct SellerPayoutDetails: Codable {
    let sellerID: Int?
    let totalPaid: String?
    let pendingAmount: String?
    let payoutHistory: PayoutHistoryList?

    enum CodingKeys: String, CodingKey {
        case sellerID = "seller_id"
        case totalPaid = "total_paid"
        case pendingAmount = "pending_amount"
        case payoutHistory = "payout_history"
    }
}

// MARK: - PayoutHistoryList
struct PayoutHistoryList: Codable {
    let currentPage: Int?
    let data: [PayoutHistory]?
    let firstPageURL: String?
    let from: Int?
    let lastPage: Int?
    let lastPageURL: String?
    let links: [Link]?
    let nextPageURL: String?
    let path: String?
    let perPage: Int?
    let prevPageURL: String?
    let to: Int?
    let total: Int?

    enum CodingKeys: String, CodingKey {
        case currentPage = "current_page"
        case data = "data"
        case firstPageURL = "first_page_url"
        case from = "from"
        case lastPage = "last_page"
        case lastPageURL = "last_page_url"
        case links = "links"
        case nextPageURL = "next_page_url"
        case path = "path"
        case perPage = "per_page"
        case prevPageURL = "prev_page_url"
        case to = "to"
        case total = "total"
    }
}

// MARK: - PayoutHistory
struct PayoutHistory: Codable {
    let id: Int?
    let requestID: String?
    let sellerID: Int?
    let amount: String?
    let transactionID: String?
    let payoutDate: String?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case requestID = "request_id"
        case sellerID = "seller_id"
        case amount = "amount"
        case transactionID = "transaction_id"
        case payoutDate = "payout_date"
    }
}
