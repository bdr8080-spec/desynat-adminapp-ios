//
//  SubscriptionPlanModel.swift
//  DesynatAdmin
//
//  Created by Meet Goti on 10/11/25.
//

import Foundation
struct SubscriptionPlanDataModel: Codable {

    var id: Int?
    var countryId: Int?
    var planNameEnglish: String?
    var planNameArabic: String?
    var duration: Double?
    var durationType: Int?
    var noOfVideos: Int?
    var noOfProducts: Int?
    var noOfHighlights: Int?
    var noOfEmployee: Int?
    var stories: Int?
    var price: Double?
    var commission: Int?
    var commissionPercentage: Double?
    var status: Int?
    var createdAt: String?
    var updatedAt: String?
    var countryInfo: GetCountryDataModel?

    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case countryId = "country_id"
        case planNameEnglish = "plan_name_english"
        case planNameArabic = "plan_name_arabic"
        case duration = "duration"
        case durationType = "duration_type"
        case noOfVideos = "no_of_videos"
        case noOfProducts = "no_of_products"
        case noOfHighlights = "no_of_highlights"
        case noOfEmployee = "no_of_employee"
        case stories = "stories"
        case price = "price"
        case commission = "commission"
        case commissionPercentage = "commission_percentage"
        case status = "status"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case countryInfo = "country_info"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try? decoder.container(keyedBy: CodingKeys.self)
        self.id = try container?.decodeIfPresent(Int.self, forKey: .id)
        self.countryId = try container?.decodeIfPresent(Int.self, forKey: .countryId)
        self.planNameEnglish = try container?.decodeIfPresent(String.self, forKey: .planNameEnglish)
        self.planNameArabic = try container?.decodeIfPresent(String.self, forKey: .planNameArabic)
        if let intValue = try? container?.decodeIfPresent(Int.self, forKey: .duration) {
            self.duration = Double(intValue)
        } else if let intValue = try? container?.decodeIfPresent(Double.self, forKey: .duration) {
            self.duration = Double(intValue)
        }
        self.durationType = try container?.decodeIfPresent(Int.self, forKey: .durationType)
        self.noOfVideos = try container?.decodeIfPresent(Int.self, forKey: .noOfVideos)
        self.noOfProducts = try container?.decodeIfPresent(Int.self, forKey: .noOfProducts)
        self.noOfHighlights = try container?.decodeIfPresent(Int.self, forKey: .noOfHighlights)
        self.noOfEmployee = try container?.decodeIfPresent(Int.self, forKey: .noOfEmployee)
        self.stories = try container?.decodeIfPresent(Int.self, forKey: .stories)
        if let intValue = try? container?.decodeIfPresent(Int.self, forKey: .price) {
            self.price = Double(intValue)
        } else if let intValue = try? container?.decodeIfPresent(Double.self, forKey: .price) {
            self.price = Double(intValue)
        }
        self.commission = try container?.decodeIfPresent(Int.self, forKey: .commission)
        if let intValue = try? container?.decodeIfPresent(Int.self, forKey: .commissionPercentage) {
            self.commissionPercentage = Double(intValue)
        } else if let intValue = try? container?.decodeIfPresent(Double.self, forKey: .commissionPercentage) {
            self.commissionPercentage = Double(intValue)
        }
        self.status = try container?.decodeIfPresent(Int.self, forKey: .status)
        self.createdAt = try container?.decodeIfPresent(String.self, forKey: .createdAt)
        self.updatedAt = try container?.decodeIfPresent(String.self, forKey: .updatedAt)
        self.countryInfo = try container?.decodeIfPresent(GetCountryDataModel.self, forKey: .countryInfo)
    }

}
