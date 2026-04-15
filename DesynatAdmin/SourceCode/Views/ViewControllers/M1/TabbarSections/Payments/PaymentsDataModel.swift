//
//  PaymentsDataModel.swift
//  DesynatAdmin
//
//  Created by fluper_mac3 on 09/04/26.
//

import Foundation

// MARK: - PaymentListDataModel
struct PaymentListDataModel: Codable {
    let orders: PaymentListData?
    let totalRevenue, totalCustomOrderRevenue: Double?
    let totalCommission: Double?

    enum CodingKeys: String, CodingKey {
        case orders
        case totalRevenue = "total_revenue"
        case totalCustomOrderRevenue = "total_custom_order_revenue"
        case totalCommission = "total_commission"
    }
}

// MARK: - PaymentListData
struct PaymentListData: Codable {
    let currentPage: Int?
    let data: [PaymentList]?
    let firstPageURL: String?
    let from, lastPage: Int?
    let lastPageURL: String?
    let links: [Link]?
    let nextPageURL, path: String?
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

// MARK: - PaymentList
struct PaymentList: Codable {
    let id: Int?
    let rEType, pOrderdetailsID: String?
    let orderID: String?
    let orderType: String?
    let productID, variantsID, quantity: Int?
//    let userID: Int?
    let amount, tax,price, shippingFees: String?
    let promocodeID, promocodeValue, giftcardID, giftcardAmount: String?
    let status, createdAt, updatedAt, returnType: String?
    let rEApprove: String?
    let returnReason, returnImage, exchangeReason, exchangeNewSize: String?
    let exchangeOldSize: String?
    let paymentStatus, deliveryStatus, deliveryBoyID, assignStatus: String?
    let assignDate: String?
    let cancelReason: String?
    let isPicked: String?
    let notDeliveredReason: String?
//    let sellerID: String?
    let adminCommission: String?
    let orderStatus: String?
    let returntostore: String?
    let uniqueID, referenceLink, affiliateID: String?
    let affiliateCommission, affiliateAdminCommission: String?
    let totalDiscount, total_paid_amount: Double?
    let variationDetails: VariationDetails?
    let productDetails: ProductDetails?
    let userDetails: UserDetails?
    let order: Order?
    let sellerDetails: SellerDetails?
    let planInfo: PlanInformation?
    let giftDetails: GiftCardsList?
    let transactionId: String?
    let paymentMethod: String?

    enum CodingKeys: String, CodingKey {
        case id
        case rEType = "r_e_type"
        case pOrderdetailsID = "p_orderdetails_id"
        case orderID = "order_id"
        case orderType = "order_type"
//        case userID = "user_id"
        case productID = "product_id"
        case variantsID = "variants_id"
        case quantity, amount, tax
        case shippingFees = "shipping_fees"
        case promocodeID = "promocode_id"
        case promocodeValue = "promocode_value"
        case giftcardID = "giftcard_id"
        case giftcardAmount = "giftcard_amount"
        case status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case returnType = "return_type"
        case rEApprove = "r_e_approve"
        case returnReason = "return_reason"
        case returnImage = "return_image"
        case exchangeReason = "exchange_reason"
        case exchangeNewSize = "exchange_new_size"
        case exchangeOldSize = "exchange_old_size"
        case paymentStatus = "payment_status"
        case deliveryStatus = "delivery_status"
        case deliveryBoyID = "delivery_boy_id"
        case assignStatus = "assign_status"
        case assignDate = "assign_date"
        case cancelReason = "cancel_reason"
        case isPicked = "is_picked"
        case notDeliveredReason = "not_delivered_reason"
//        case sellerID = "seller_id"
        case adminCommission = "admin_commission"
        case orderStatus = "order_status"
        case returntostore
        case uniqueID = "unique_id"
        case referenceLink = "reference_link"
        case affiliateID = "affiliate_id"
        case affiliateCommission = "affiliate_commission"
        case affiliateAdminCommission = "affiliate_admin_commission"
        case totalDiscount = "total_discount"
        case variationDetails = "variation_details"
        case productDetails = "product_details"
        case userDetails = "user_details"
        case order, price
        case sellerDetails = "seller_details"
        case planInfo = "plan_info"
        case giftDetails = "gift_details"
        case transactionId = "transaction_id"
        case paymentMethod = "payment_method"
        case total_paid_amount
    }
    
    // ✅ Custom Decoder
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            id = try container.decodeIfPresent(Int.self, forKey: .id)
            rEType = try container.decodeIfPresent(String.self, forKey: .rEType)
            pOrderdetailsID = try container.decodeIfPresent(String.self, forKey: .pOrderdetailsID)

            // 🔥 Handle order_id as Int OR String
            if let intValue = try? container.decode(Int.self, forKey: .orderID) {
                orderID = String(intValue)
            } else if let stringValue = try? container.decode(String.self, forKey: .orderID) {
                orderID = stringValue
            } else {
                orderID = nil
            }

            orderType = try container.decodeIfPresent(String.self, forKey: .orderType)
            total_paid_amount = try container.decodeIfPresent(Double.self, forKey: .total_paid_amount)
            productID = try container.decodeIfPresent(Int.self, forKey: .productID)
            variantsID = try container.decodeIfPresent(Int.self, forKey: .variantsID)
            quantity = try container.decodeIfPresent(Int.self, forKey: .quantity)
            amount = try container.decodeIfPresent(String.self, forKey: .amount)
            price = try container.decodeIfPresent(String.self, forKey: .price)
            tax = try container.decodeIfPresent(String.self, forKey: .tax)
            shippingFees = try container.decodeIfPresent(String.self, forKey: .shippingFees)
            promocodeID = try container.decodeIfPresent(String.self, forKey: .promocodeID)
            promocodeValue = try container.decodeIfPresent(String.self, forKey: .promocodeValue)
            giftcardID = try container.decodeIfPresent(String.self, forKey: .giftcardID)
            giftcardAmount = try container.decodeIfPresent(String.self, forKey: .giftcardAmount)
            status = try container.decodeIfPresent(String.self, forKey: .status)
            createdAt = try container.decodeIfPresent(String.self, forKey: .createdAt)
            updatedAt = try container.decodeIfPresent(String.self, forKey: .updatedAt)
            returnType = try container.decodeIfPresent(String.self, forKey: .returnType)
            rEApprove = try container.decodeIfPresent(String.self, forKey: .rEApprove)
            returnReason = try container.decodeIfPresent(String.self, forKey: .returnReason)
            returnImage = try container.decodeIfPresent(String.self, forKey: .returnImage)
            exchangeReason = try container.decodeIfPresent(String.self, forKey: .exchangeReason)
            exchangeNewSize = try container.decodeIfPresent(String.self, forKey: .exchangeNewSize)
            exchangeOldSize = try container.decodeIfPresent(String.self, forKey: .exchangeOldSize)
            paymentStatus = try container.decodeIfPresent(String.self, forKey: .paymentStatus)
            deliveryStatus = try container.decodeIfPresent(String.self, forKey: .deliveryStatus)
            deliveryBoyID = try container.decodeIfPresent(String.self, forKey: .deliveryBoyID)
            assignStatus = try container.decodeIfPresent(String.self, forKey: .assignStatus)
            assignDate = try container.decodeIfPresent(String.self, forKey: .assignDate)
            cancelReason = try container.decodeIfPresent(String.self, forKey: .cancelReason)
            isPicked = try container.decodeIfPresent(String.self, forKey: .isPicked)
            notDeliveredReason = try container.decodeIfPresent(String.self, forKey: .notDeliveredReason)
            adminCommission = try container.decodeIfPresent(String.self, forKey: .adminCommission)
            orderStatus = try container.decodeIfPresent(String.self, forKey: .orderStatus)
            returntostore = try container.decodeIfPresent(String.self, forKey: .returntostore)
            uniqueID = try container.decodeIfPresent(String.self, forKey: .uniqueID)
            referenceLink = try container.decodeIfPresent(String.self, forKey: .referenceLink)
            affiliateID = try container.decodeIfPresent(String.self, forKey: .affiliateID)
            affiliateCommission = try container.decodeIfPresent(String.self, forKey: .affiliateCommission)
            affiliateAdminCommission = try container.decodeIfPresent(String.self, forKey: .affiliateAdminCommission)
            totalDiscount = try container.decodeIfPresent(Double.self, forKey: .totalDiscount)
            variationDetails = try container.decodeIfPresent(VariationDetails.self, forKey: .variationDetails)
            productDetails = try container.decodeIfPresent(ProductDetails.self, forKey: .productDetails)
            userDetails = try container.decodeIfPresent(UserDetails.self, forKey: .userDetails)
            order = try container.decodeIfPresent(Order.self, forKey: .order)
            sellerDetails = try container.decodeIfPresent(SellerDetails.self, forKey: .sellerDetails)
            planInfo = try container.decodeIfPresent(PlanInformation.self, forKey: .planInfo)
            giftDetails = try container.decodeIfPresent(GiftCardsList.self, forKey: .giftDetails)
            transactionId = try container.decodeIfPresent(String.self, forKey: .transactionId)
            paymentMethod = try container.decodeIfPresent(String.self, forKey: .paymentMethod)
        }
}

// MARK: - Order
struct Order: Codable {
    let id: Int?
    let orderType, orderID: String?
    let userID, deliveryAddress: Int?
    let totalMrp, discountMrp, promocodeStatus: String?
    let promocodeID, promocodeValue, giftcardAmount, giftcardID: String?
    let shippingFees, tax: String?
    let walletAmount: String?
    let totalAmount, paymentStatus, paymentMethod, deliveryStatus: String?
    let transactionID, deliveryBoyID: String?
    let assignStatus: String?
    let assignDate: String?
    let createdAt, updatedAt: String?
    //let cancelReason, uniqueID, promocodeDetails, giftCardDetails: String?
    let cancelReason, uniqueID, giftCardDetails : String?
    let promocodeDetails: PromocodeDetails?
    
    enum CodingKeys: String, CodingKey {
        case id
        case orderType = "order_type"
        case orderID = "order_id"
        case userID = "user_id"
        case deliveryAddress = "delivery_address"
        case totalMrp = "total_mrp"
        case discountMrp = "discount_mrp"
        case promocodeStatus = "promocode_status"
        case promocodeID = "promocode_id"
        case promocodeValue = "promocode_value"
        case giftcardAmount = "giftcard_amount"
        case giftcardID = "giftcard_id"
        case shippingFees = "shipping_fees"
        case tax
        case walletAmount = "wallet_amount"
        case totalAmount = "total_amount"
        case paymentStatus = "payment_status"
        case paymentMethod = "payment_method"
        case deliveryStatus = "delivery_status"
        case transactionID = "transaction_id"
        case deliveryBoyID = "delivery_boy_id"
        case assignStatus = "assign_status"
        case assignDate = "assign_date"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case cancelReason = "cancel_reason"
        case uniqueID = "unique_id"
        case promocodeDetails = "promocode_details"
        case giftCardDetails = "gift_card_details"
    }
}


// MARK: - UserDetails
struct UserDetails: Codable {
    let id: Int?
    let profileImage: String?
    let fullName, countryCode, mobile, email: String?
    let emailVerifiedAt: String?
    let otp, otpVerify, deviceType: String?
    let deviceToken, userDetailsLet, long: String?
    let status, bannerView, lang, createdAt: String?
    let updatedAt, accessToken, fcmToken: String?
    let affiliatedUserdetails: String?
    let countryInfo: CountryInfo?

    enum CodingKeys: String, CodingKey {
        case id
        case profileImage = "profile_image"
        case fullName = "full_name"
        case countryCode = "country_code"
        case mobile, email
        case emailVerifiedAt = "email_verified_at"
        case otp
        case otpVerify = "otp_verify"
        case deviceType = "device_type"
        case deviceToken = "device_token"
        case userDetailsLet = "let"
        case long, status
        case bannerView = "banner_view"
        case lang
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case accessToken
        case fcmToken = "fcm_token"
        case affiliatedUserdetails = "affiliated_userdetails"
        case countryInfo = "country_info"
    }
}

// MARK: - PlanInformation
struct PlanInformation: Codable {
    let id, countryID: Int?
    let planNameEnglish, planNameArabic: String?
    let duration, durationType: Int?
    let newDuration: Int?
//    let newDurationType: JSONNull?
    let noOfVideos: Int?
    let productType: String?
//    let noOfProducts: JSONNull?
    let noOfHighlights, noOfEmployee, stories: Int?
    let discountedPrice, price: Double?
    let commission, commissionPercentage: Double?
    let isFreeMonths, noOfFreeMonths: String?
    let status: Int?
    let createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case countryID = "country_id"
        case planNameEnglish = "plan_name_english"
        case planNameArabic = "plan_name_arabic"
        case duration
        case durationType = "duration_type"
        case newDuration = "new_duration"
//        case newDurationType = "new_duration_type"
        case noOfVideos = "no_of_videos"
        case productType = "product_type"
//        case noOfProducts = "no_of_products"
        case noOfHighlights = "no_of_highlights"
        case noOfEmployee = "no_of_employee"
        case stories, price
        case discountedPrice = "discounted_price"
        case commission
        case commissionPercentage = "commission_percentage"
        case isFreeMonths = "is_free_months"
        case noOfFreeMonths = "no_of_free_months"
        case status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
