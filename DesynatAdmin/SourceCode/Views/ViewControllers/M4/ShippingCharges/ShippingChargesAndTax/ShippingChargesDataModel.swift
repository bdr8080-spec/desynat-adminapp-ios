//
//  ShippingChargesDataModel.swift
//  DesynatAdmin
//
//  Created by fluper on 09/12/25.
//

import Foundation

// MARK: - ShippingChargesList
struct ShippingChargesList: Codable {
    let id, countryID: Int?
    let rangeFrom, rangeTo, shippingFee: String?
    var status: Int?
    let createdAt, updatedAt: String?
    let countryInfo: CountryInfo?

    enum CodingKeys: String, CodingKey {
        case id
        case countryID = "country_id"
        case rangeFrom = "range_from"
        case rangeTo = "range_to"
        case shippingFee = "shipping_fee"
        case status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case countryInfo = "country_info"
    }
}
