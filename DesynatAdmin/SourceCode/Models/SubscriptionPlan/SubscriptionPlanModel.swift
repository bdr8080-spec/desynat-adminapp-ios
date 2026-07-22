//
//  SubscriptionPlanModel.swift
//  DesynatAdmin
//
//  Created by Meet Goti on 10/11/25.
//

import Foundation
struct PurchasedPlanDataModel:Codable {
    var id: Int?
    var transactionId: String?
    var sellerId: Int?
    var planId: Int?
    var status: String?
    var amount: String?
    var planStartDate: String?
    var planEndDate: String?
    var planInfo: SubscriptionPlanDataModel?
    @DefaultCodable<DefaultNilStrategy> var onlineTransactionId: String?
    @DefaultCodable<DefaultNilStrategy> var paymentMethod: String?
    var paymentStatus: String?
    var createdAt: String?
    var updatedAt: String?
    
    enum CodingKeys: String,CodingKey {
        case id
        case transactionId = "transaction_id"
        case sellerId = "seller_id"
        case planId = "plan_id"
        case status = "status"
        case amount = "amount"
        case planStartDate = "plan_start_date"
        case planEndDate = "plan_end_date"
        case planInfo = "plan_info"
        case onlineTransactionId = "online_transaction_id"
        case paymentMethod = "payment_method"
        case paymentStatus = "payment_status"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
    
}

struct SubscriptionPlanDataModel: Codable {

    var id: Int?
    var countryId: Int?
    var planNameEnglish: String?
    var planNameArabic: String?
    var duration: Double?
    var durationType: Int?
    var newduration: Double?
    var newdurationType: Int?
    var noOfVideos: Int?
    var noOfProducts: Int?
    var noOfHighlights: Int?
    var noOfEmployee: Int?
    var stories: Int?
    var price: Double?
    var discountedPrice: Double?
    var commission: Int?
    var commissionPercentage: Double?
    var status: Int?
    var createdAt: String?
    var updatedAt: String?
    var countryInfo: GetCountryDataModel?

    // ✅ FIXED FIELDS
    var isFreeMonths: Int?
    var noOfFreeMonths: Int?
    var productType: Int?
    var showInRecommendedStores:Int?

    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case countryId = "country_id"
        case planNameEnglish = "plan_name_english"
        case planNameArabic = "plan_name_arabic"
        case duration = "duration"
        case durationType = "duration_type"
        case newduration = "new_duration"
        case newdurationType = "new_duration_type"
        case noOfVideos = "no_of_videos"
        case noOfProducts = "no_of_products"
        case noOfHighlights = "no_of_highlights"
        case noOfEmployee = "no_of_employee"
        case stories = "stories"
        case price = "price"
        case discountedPrice = "discounted_price"
        case commission = "commission"
        case commissionPercentage = "commission_percentage"
        case status = "status"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case countryInfo = "country_info"

        // ✅ IMPORTANT
        case productType = "product_type"
        case noOfFreeMonths = "no_of_free_months"
        case isFreeMonths = "is_free_months"
        case showInRecommendedStores = "show_in_recommended_stores"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.id = try container.decodeIfPresent(Int.self, forKey: .id)
        self.countryId = try container.decodeIfPresent(Int.self, forKey: .countryId)
        self.planNameEnglish = try container.decodeIfPresent(String.self, forKey: .planNameEnglish)
        self.planNameArabic = try container.decodeIfPresent(String.self, forKey: .planNameArabic)

        // Duration
        if let value = try? container.decodeIfPresent(Int.self, forKey: .duration) {
            self.duration = Double(value)
        } else if let value = try? container.decodeIfPresent(Double.self, forKey: .duration) {
            self.duration = value
        }

        self.durationType = try container.decodeIfPresent(Int.self, forKey: .durationType)

        // New Duration
        if let value = try? container.decodeIfPresent(Int.self, forKey: .newduration) {
            self.newduration = Double(value)
        } else if let value = try? container.decodeIfPresent(Double.self, forKey: .newduration) {
            self.newduration = value
        }

        self.newdurationType = try container.decodeIfPresent(Int.self, forKey: .newdurationType)

        self.noOfVideos = try container.decodeIfPresent(Int.self, forKey: .noOfVideos)
        self.noOfProducts = try container.decodeIfPresent(Int.self, forKey: .noOfProducts)
        self.noOfHighlights = try container.decodeIfPresent(Int.self, forKey: .noOfHighlights)
        self.noOfEmployee = try container.decodeIfPresent(Int.self, forKey: .noOfEmployee)
        self.stories = try container.decodeIfPresent(Int.self, forKey: .stories)

        // Price
        if let value = try? container.decodeIfPresent(Int.self, forKey: .price) {
            self.price = Double(value)
        } else if let value = try? container.decodeIfPresent(Double.self, forKey: .price) {
            self.price = value
        }

        // Discounted Price
        if let value = try? container.decodeIfPresent(Int.self, forKey: .discountedPrice) {
            self.discountedPrice = Double(value)
        } else if let value = try? container.decodeIfPresent(Double.self, forKey: .discountedPrice) {
            self.discountedPrice = value
        }

        self.commission = try container.decodeIfPresent(Int.self, forKey: .commission)

        if let value = try? container.decodeIfPresent(Int.self, forKey: .commissionPercentage) {
            self.commissionPercentage = Double(value)
        } else if let value = try? container.decodeIfPresent(Double.self, forKey: .commissionPercentage) {
            self.commissionPercentage = value
        }

        self.status = try container.decodeIfPresent(Int.self, forKey: .status)
        self.createdAt = try container.decodeIfPresent(String.self, forKey: .createdAt)
        self.updatedAt = try container.decodeIfPresent(String.self, forKey: .updatedAt)
        self.countryInfo = try container.decodeIfPresent(GetCountryDataModel.self, forKey: .countryInfo)

        // ✅ SAFE DECODING (INT + STRING SUPPORT)

        // product_type
        if let value = try? container.decodeIfPresent(Int.self, forKey: .productType) {
            self.productType = value
        } else if let value = try? container.decodeIfPresent(String.self, forKey: .productType) {
            self.productType = Int(value)
        }

        // is_free_months
        if let value = try? container.decodeIfPresent(Int.self, forKey: .isFreeMonths) {
            self.isFreeMonths = value
        } else if let value = try? container.decodeIfPresent(String.self, forKey: .isFreeMonths) {
            self.isFreeMonths = Int(value)
        }

        // no_of_free_months
        if let value = try? container.decodeIfPresent(Int.self, forKey: .noOfFreeMonths) {
            self.noOfFreeMonths = value
        } else if let value = try? container.decodeIfPresent(String.self, forKey: .noOfFreeMonths) {
            self.noOfFreeMonths = Int(value)
        }
    }
}
