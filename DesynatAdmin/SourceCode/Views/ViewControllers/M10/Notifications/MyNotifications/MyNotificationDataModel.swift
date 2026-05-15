//
//  MyNotificationDataModel.swift
//  DesynatAdmin
//
//  Created by fluper_mac2 on 15/05/26.
//

import Foundation

// MARK: - MyNotificationsListDataModel
struct MyNotificationsListDataModel: Codable {
    let currentPage: Int?
    let data: [MyNotificationsList]?
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

// MARK: - MyNotificationsList
struct MyNotificationsList: Codable {
    let id, senderID, senderType, receiverID: Int?
    let receiverType: Int?
    let titleEnglish: String?
    let titleArabic: String?
    let descriptionEnglish: String?
    let descriptionArabic: String?
    let notificationType: String?
    let isRead: Int?
    let createdAt, updatedAt: String?
//    let receiverDetails: ReceiverDetails?
//    let senderDetails: SenderDetails?

    enum CodingKeys: String, CodingKey {
        case id
        case senderID = "sender_id"
        case senderType = "sender_type"
        case receiverID = "receiver_id"
        case receiverType = "receiver_type"
        case titleEnglish = "title_english"
        case titleArabic = "title_arabic"
        case descriptionEnglish = "description_english"
        case descriptionArabic = "description_arabic"
        case notificationType = "notification_type"
        case isRead = "is_read"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
//        case receiverDetails = "receiver_details"
//        case senderDetails = "sender_details"
    }
}
