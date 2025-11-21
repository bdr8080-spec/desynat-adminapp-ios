//
//  DriverZneListDataModel.swift
//  DesynatAdmin
//
//  Created by fluper on 21/11/25.
//

import Foundation


// MARK: - DriverZoneList
struct DriverZoneList: Codable {
    let id, countryID, cityID: Int?
    let nameEnglish, nameArabic: String?
    let coordinates: [Coordinate]?
    let status: Int?
    let createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case countryID = "country_id"
        case cityID = "city_id"
        case nameEnglish = "name_english"
        case nameArabic = "name_arabic"
        case coordinates, status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
