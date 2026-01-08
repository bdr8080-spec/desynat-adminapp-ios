//
//  AddAdvertisementModel.swift
//  DesynatAdmin
//
//  Created by fluper on 08/01/26.
//

import Foundation


// MARK: - AddAdvertisementModel
struct AddAdvertisementModel: Codable {
    let image: String?
    let countryID: Int?
    let title, startDate, endDate, updatedAt: String?
    let createdAt: String?
    let id: Int?

    enum CodingKeys: String, CodingKey {
        case image
        case countryID = "country_id"
        case title
        case startDate = "start_date"
        case endDate = "end_date"
        case updatedAt = "updated_at"
        case createdAt = "created_at"
        case id
    }
}
