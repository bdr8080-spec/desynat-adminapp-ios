//
//  OrderDataModel.swift
//  DesynatAdmin
//
//  Created by Chandra Prakash on 23/12/25.
//

import Foundation

struct StepImage {
    let selected: String
    let unselected: String
}


// MARK: - OrderListModel
struct OrderListModel: Codable {
    let currentPage: Int?
    let data: [OrderData]?
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

// MARK: - OrderData
struct OrderData: Codable {
    let id, orderID, userID, productID: Int?
    let variantsID, quantity: Int?
    let amount, status, createdAt, updatedAt: String?
    let returnType, rEApprove: String?
    let returnReason, exchangeReason, exchangeNewSize: String?
    let returnImage: [String]?
    let exchangeOldSize: String?
    let paymentStatus, deliveryStatus, deliveryBoyID, assignStatus: String?
    let assignDate: String?
    let cancelReason: String?
    let isPicked: String?
    let notDeliveredReason: String?
    let order: OrderDetail?
    let productDetails: ProductDetails?
    let variationDetails: VariationDetails?
    let userRatingReviewProvide: UserRatingReviewProvide?
    let driverDetails: DriverDetails?
    let adminCommission: Double?
    let exchangeOrderDetails: ExchangeOrderDetails?
    
    enum CodingKeys: String, CodingKey {
        case id
        case orderID = "order_id"
        case userID = "user_id"
        case productID = "product_id"
        case variantsID = "variants_id"
        case quantity, amount, status
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
        case order
        case productDetails = "product_details"
        case variationDetails = "variation_details"
        case userRatingReviewProvide = "user_rating_review_provide"
        case driverDetails = "driver_details"
        case adminCommission = "admin_commission"
        case exchangeOrderDetails = "exchange_order_details"
    }
}

// MARK: - ExchangeOrderDetails
struct ExchangeOrderDetails: Codable {
    var id: Int?
    var rEType, pOrderdetailsID: String?
    var orderID, userID, productID, variantsID: Int?
    var quantity: Int?
    var amount, tax, shippingFees: String?
    var promocodeID, promocodeValue, giftcardID, giftcardAmount: String?
    var status, createdAt, updatedAt, returnType: String?
    var rEApprove: String?
    var returnReason, exchangeReason: String?
    var returnImage: [String]?
    var exchangeNewSize: String?
    var exchangeOldSize: String?
    var paymentStatus, deliveryStatus, deliveryBoyID, assignStatus: String?
    var assignDate: String?
    var cancelReason: String?
    var isPicked: String?
    var notDeliveredReason: String?
    var sellerID: String?
    var adminCommission, orderStatus: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case rEType = "r_e_type"
        case pOrderdetailsID = "p_orderdetails_id"
        case orderID = "order_id"
        case userID = "user_id"
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
        case sellerID = "seller_id"
        case adminCommission = "admin_commission"
        case orderStatus = "order_status"
    }
}

// MARK: - UserRatingReviewProvide
struct UserRatingReviewProvide: Codable {
    let id, userID, orderID, orderdetailsID: Int?
    let productID: Int?
    let productRating, productReview, productImage: String?
    let storeID: Int?
    let storeRating, storeReview, storeImage, createdAt: String?
    let updatedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case orderID = "order_id"
        case orderdetailsID = "orderdetails_id"
        case productID = "product_id"
        case productRating = "product_rating"
        case productReview = "product_review"
        case productImage = "product_image"
        case storeID = "store_id"
        case storeRating = "store_rating"
        case storeReview = "store_review"
        case storeImage = "store_image"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

// MARK: - DriverDetails
struct DriverDetails: Codable {
    let id: Int?
    let profilePic: String?
    let fullNameEnglish, fullNameArabic, email, countryCode: String?
    let mobile, password, unhashedPassword, addressLine1: String?
    let addressLine2, city, state, driverDetailsLet: String?
    let long: String?
    let countryID, zoneID: Int?
    let otp, otpVerify: String?
//    let otp, otpVerify, deviceType: String?
    let deviceToken: String?
    let vehicleName, vehicleRegNo, documentInformation, status: String?
    let onDuty, createdAt, updatedAt: String?
    let zoneInfo: ZoneInfoDetails?
    
    enum CodingKeys: String, CodingKey {
        case id
        case profilePic = "profile_pic"
        case fullNameEnglish = "full_name_english"
        case fullNameArabic = "full_name_arabic"
        case email
        case countryCode = "country_code"
        case mobile, password
        case unhashedPassword = "unhashed_password"
        case addressLine1 = "address_line1"
        case addressLine2 = "address_line2"
        case city, state
        case driverDetailsLet = "let"
        case long
        case countryID = "country_id"
        case zoneID = "zone_id"
        case otp
        case otpVerify = "otp_verify"
//        case deviceType = "device_type"
        case deviceToken = "device_token"
        case vehicleName = "vehicle_name"
        case vehicleRegNo = "vehicle_reg_no"
        case documentInformation = "document_information"
        case status
        case onDuty = "on_duty"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case zoneInfo = "zone_info"
    }
}

// MARK: - ZoneInfoDetails
struct ZoneInfoDetails: Codable {
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

// MARK: - OrderDetail
struct OrderDetail: Codable {
    let id: Int?
    let orderID: String?
    let userID, deliveryAddress: Int?
    let totalMrp, discountMrp, promocodeStatus: String?
    let promocodeID, promocodeValue: String?
    let giftcardAmount: String?
    let giftcardID: String?
    let shippingFees, tax: String?
    let walletAmount: String?
    let totalAmount, paymentStatus, paymentMethod, deliveryStatus: String?
    let transactionID: String?
    let deliveryBoyID: String?
    let assignStatus: String?
    let assignDate: String?
    let createdAt, updatedAt: String?
    let cancelReason: String?
    let deliveryDetails: DeliveryDetails?
    let giftCardDetails: String?
    let promocodeDetails: PromocodeDetails?
    
    enum CodingKeys: String, CodingKey {
        case id
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
        case deliveryDetails = "delivery_details"
        case giftCardDetails = "gift_card_details"
        case promocodeDetails = "promocode_details"
    }
}

// MARK: - PromocodeDetails
struct PromocodeDetails: Codable {
    let id, countryID: Int?
    let nameEnglish, nameArabic, descriptionEnglish, descriptionArabic: String?
    let applicableFor: Int?
    let discountPercent, minOrderValue, uptoDiscount, startDate: String?
    let endDate: String?
    let status: Int?
    let createdAt, updatedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case countryID = "country_id"
        case nameEnglish = "name_english"
        case nameArabic = "name_arabic"
        case descriptionEnglish = "description_english"
        case descriptionArabic = "description_arabic"
        case applicableFor = "applicable_for"
        case discountPercent = "discount_percent"
        case minOrderValue = "min_order_value"
        case uptoDiscount = "upto_discount"
        case startDate = "start_date"
        case endDate = "end_date"
        case status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

// MARK: - DeliveryDetails
struct DeliveryDetails: Codable {
    let id, userID: Int?
    let name, mobile, countryCode, address: String?
    let houseNo: String?
    let streetNo: String?
    let postalCode, city, state, countryName: String?
    let landmark: String?
    let saveAddressAs, status: Int?
    let latitude, longitude, createdAt, updatedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case name, mobile
        case countryCode = "country_code"
        case address
        case houseNo = "house_no"
        case streetNo = "street_no"
        case postalCode = "postal_code"
        case city, state
        case countryName = "country_name"
        case landmark
        case saveAddressAs = "save_address_as"
        case status, latitude, longitude
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

// MARK: - ProductDetails
struct ProductDetails: Codable {
    let id: Int?
    let sellerID, storeID, categoryID, subcategoryID: String?
    let brandID, otherEn, otherAr, productNameEn: String?
    let productNameAr, descriptionEn, descriptionAr, minCardQuantity: String?
    let maxCardQuantity, productReturn: String?
    let returnDays: String?
    let productExchangable: String?
    let exchangableDays: String?
    let reviewRating, affiliatedProduct: String?
    let affiliatedCommission: String?
    let customizedProduct, readyToShip, cashOnDelivery: String?
    let uploadSizeChart: String?
    let productActiveStatus: Int?
    let createdAt, updatedAt: String?
    let brand: Brand?
    let category: Category?
    let subcategory: Brand?
    let sellerDetails: SellerDetails?
    let store: Store?
    let productVariants: [ProductVariant]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case sellerID = "seller_id"
        case storeID = "store_id"
        case categoryID = "category_id"
        case subcategoryID = "subcategory_id"
        case brandID = "brand_id"
        case otherEn = "other_en"
        case otherAr = "other_ar"
        case productNameEn = "product_name_en"
        case productNameAr = "product_name_ar"
        case descriptionEn = "description_en"
        case descriptionAr = "description_ar"
        case minCardQuantity = "min_card_quantity"
        case maxCardQuantity = "max_card_quantity"
        case productReturn = "product_return"
        case returnDays = "return_days"
        case productExchangable = "product_exchangable"
        case exchangableDays = "exchangable_days"
        case reviewRating = "review_rating"
        case affiliatedProduct = "affiliated_product"
        case affiliatedCommission = "affiliated_commission"
        case customizedProduct = "customized_product"
        case readyToShip = "ready_to_ship"
        case cashOnDelivery = "cash_on_delivery"
        case uploadSizeChart = "upload_size_chart"
        case productActiveStatus = "product_active_status"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case brand, category, subcategory
        case sellerDetails = "seller_details"
        case store
        case productVariants = "product_variants"
    }
}

// MARK: - Brand
struct Brand: Codable {
    let id: Int?
    let nameEnglish, nameArabic: String?
    let image: String?
    let status: Int?
    let createdAt, updatedAt: String?
    let categoryID: Int?
    
    enum CodingKeys: String, CodingKey {
        case id
        case nameEnglish = "name_english"
        case nameArabic = "name_arabic"
        case image, status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case categoryID = "category_id"
    }
}

// MARK: - Category
struct Category: Codable {
    let id: Int?
    let name, description: String?
    let image: String?
    let status: Int?
    let colorCode, createdAt, updatedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name, description, image, status
        case colorCode = "color_code"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

// MARK: - ProductVariant
struct ProductVariant: Codable {
    let id, productID: Int?
    let parentChild: String?
    let variantImage: [String]?
    let colorID, sizeID, bust, waist: String?
    let hip, shoulder, sleeveLength, length: String?
    let totalStock, sku: String?
    let skuThresholdValue: String?
    let actualPrice, discountType, discountValue, finalPrice: String?
    let status, createdAt, updatedAt: String?
    let dealDiscountPrice: Double?
    let color, size: Color?
    
    enum CodingKeys: String, CodingKey {
        case id
        case productID = "product_id"
        case parentChild = "parent_child"
        case variantImage = "variant_image"
        case colorID = "color_id"
        case sizeID = "size_id"
        case bust, waist, hip, shoulder, color, size
        case sleeveLength = "sleeve_length"
        case length
        case totalStock = "total_stock"
        case sku
        case skuThresholdValue = "sku_threshold_value"
        case actualPrice = "actual_price"
        case discountType = "discount_type"
        case discountValue = "discount_value"
        case finalPrice = "final_price"
        case status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case dealDiscountPrice = "deal_discount_price"
    }
}

// MARK: - Store
struct Store: Codable {
    let id, sellerID: Int?
    let storeImage: String?
    let storeName, country, storeAddress, addressLine1: String?
    let addressLine2, storePhone, countryCode, storeMailID: String?
    let storeAvailability: Int?
    let bio, storeLet, long, createdAt: String?
    let updatedAt: String?
    let countryInfo: CountryInfo?
    
    enum CodingKeys: String, CodingKey {
        case id
        case sellerID = "seller_id"
        case storeImage = "store_image"
        case storeName = "store_name"
        case country
        case storeAddress = "store_address"
        case addressLine1 = "address_line1"
        case addressLine2 = "address_line2"
        case storePhone = "store_phone"
        case countryCode = "country_code"
        case storeMailID = "store_mail_id"
        case storeAvailability = "Store_Availability"
        case bio
        case storeLet = "let"
        case long
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case countryInfo = "country_info"
    }
}

// MARK: - VariationDetails
struct VariationDetails: Codable {
    let id, productID: Int?
    let parentChild: String?
    let variantImage: [String]?
    let colorID, sizeID: String?
    let bust, waist, hip, shoulder: String?
    let sleeveLength, length: String?
    let totalStock, sku: String?
    let skuThresholdValue: String?
    let actualPrice, discountType, discountValue, finalPrice: String?
    let status, createdAt, updatedAt: String?
    let color, size: Color?
    
    enum CodingKeys: String, CodingKey {
        case id
        case productID = "product_id"
        case parentChild = "parent_child"
        case variantImage = "variant_image"
        case colorID = "color_id"
        case sizeID = "size_id"
        case bust, waist, hip, shoulder
        case sleeveLength = "sleeve_length"
        case length
        case totalStock = "total_stock"
        case sku
        case skuThresholdValue = "sku_threshold_value"
        case actualPrice = "actual_price"
        case discountType = "discount_type"
        case discountValue = "discount_value"
        case finalPrice = "final_price"
        case status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case color, size
    }
}

// MARK: - Color
struct Color: Codable {
    let id: Int?
    let name, hexCode, createdAt, updatedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case hexCode = "hex_code"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
