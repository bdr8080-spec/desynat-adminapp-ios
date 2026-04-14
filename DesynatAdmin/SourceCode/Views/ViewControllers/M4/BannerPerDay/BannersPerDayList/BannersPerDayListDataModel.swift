//
//  BannersPerDayListDataModel.swift
//  DesynatAdmin
//
//  Created by fluper on 09/12/25.
//

import Foundation

// MARK: - BannersPerDayListDataModel
struct BannersPerDayListDataModel: Codable {
    let id, countryID, type: Int?
    let perDayPrice, createdAt, updatedAt: String?
    let countryInfo: CountryInfo?

    enum CodingKeys: String, CodingKey {
        case id
        case countryID = "country_id"
        case type
        case perDayPrice = "per_day_price"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case countryInfo = "country_info"
    }
}

