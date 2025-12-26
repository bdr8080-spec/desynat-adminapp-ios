//
//  OrderDataModel.swift
//  DesynatAdmin
//
//  Created by Chandra Prakash on 23/12/25.
//

import Foundation
struct OrderListModel: Codable {
  var currentPage: Int?
  var data: [OrderData]?
  var firstPageURL: String?
  var from, lastPage: Int?
  var lastPageURL: String?
  var links: [Link]?
  var nextPageURL: String?
  var path: String?
  var perPage: Int?
  var prevPageURL: String?
  var to, total: Int?
  
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
  var id: Int?
  var orderID: String?
  var userID, deliveryAddress: Int?
  var totalMrp, discountMrp, promocodeStatus: String?
  var promocodeID, promocodeValue: String?
  var giftcardAmount, giftcardID: String?
  var shippingFees, tax: String?
  var walletAmount: String?
  var totalAmount, paymentStatus, paymentMethod, deliveryStatus: String?
  var transactionID, deliveryBoyID: String?
  var assignStatus: String?
  var assignDate, notDeliveredReason: String?
  var createdAt, updatedAt: String?
  var deliveryDetails: DeliveryDetails?
  var orderDetails: [OrderDetail]?
  var driverDetails: DriverDetails?
  
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
    case notDeliveredReason = "not_delivered_reason"
    case createdAt = "created_at"
    case updatedAt = "updated_at"
    case deliveryDetails = "delivery_details"
    case orderDetails = "order_details"
    case driverDetails = "driver_details"
  }
}

struct DriverDetails: Codable {
  var id: Int?
  var profilePic: String?
  var fullNameEnglish, fullNameArabic, email, countryCode: String?
  var mobile, password, unhashedPassword, addressLine1: String?
  var addressLine2, city, state, driverDetailsLet: String?
  var long: String?
  var countryID, zoneID: Int?
  var otp, otpVerify, deviceType: String?
  var deviceToken: String?
  var vehicleName, vehicleRegNo, documentInformation, status: String?
  var onDuty, createdAt, updatedAt: String?
  var zoneInfo: ZoneInfos?
  
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
    case deviceType = "device_type"
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

// MARK: - ZoneInfo
struct ZoneInfos: Codable {
  var id, countryID, cityID: Int?
  var nameEnglish, nameArabic: String?
  var coordinates: [Coordinate]?
  var status: Int?
  var createdAt, updatedAt: String?
  
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

// MARK: - DeliveryDetails
struct DeliveryDetails: Codable {
  var id, userID: Int?
  var name, mobile, countryCode, address: String?
  var houseNo: String?
  var streetNo: String?
  var postalCode, city, state: String?
  var countryName, landmark: String?
  var saveAddressAs, status: Int?
  var latitude, longitude, createdAt, updatedAt: String?
  
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

// MARK: - OrderDetail
struct OrderDetail: Codable {
  var id, orderID, userID, productID: Int?
  var variantsID, quantity: Int?
  var amount, status, createdAt, updatedAt: String?
  var returnType, rEApprove: String?
  var returnReason,cancelReason, returnImage, exchangeReason, exchangeNewSize: String?
  var exchangeOldSize: String?
  var paymentStatus, deliveryStatus: String?
  var productDetails: ProductDetails?
  var variationDetails: VariationDetails?
  
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
    case cancelReason = "cancel_reason"
    case exchangeNewSize = "exchange_new_size"
    case exchangeOldSize = "exchange_old_size"
    case paymentStatus = "payment_status"
    case deliveryStatus = "delivery_status"
    case productDetails = "product_details"
    case variationDetails = "variation_details"
  }
}

// MARK: - ProductDetails
struct ProductDetails: Codable {
  var id: Int?
  var sellerID, storeID, categoryID, subcategoryID: String?
  var brandID: String?
  var otherEn, otherAr: String?
  var productNameEn, productNameAr, descriptionEn, descriptionAr: String?
  var minCardQuantity, maxCardQuantity, productReturn: String?
  var returnDays: String?
  var productExchangable: String?
  var exchangableDays: String?
  var reviewRating, affiliatedProduct: String?
  var affiliatedCommission: String?
  var customizedProduct, readyToShip, cashOnDelivery: String?
  var uploadSizeChart: String?
  var productActiveStatus: Int?
  var createdAt, updatedAt: String?
  var brand: Brand?
  var category: Category?
  var subcategory: Brand?
  var sellerDetails: SellerDetails?
  
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
  }
}

// MARK: - Brand
struct Brand: Codable {
  var id: Int?
  var nameEnglish: String?
  var nameArabic: String?
  var image: String?
  var status: Int?
  var createdAt, updatedAt: String?
  var categoryID: Int?
  
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
  var id: Int?
  var name: String?
  var description: String?
  var image: String?
  var status: Int?
  var colorCode: String?
  var createdAt: String?
  var updatedAt: String?
  
  enum CodingKeys: String, CodingKey {
    case id, name, description, image, status
    case colorCode = "color_code"
    case createdAt = "created_at"
    case updatedAt = "updated_at"
  }
}


// MARK: - VariationDetails
struct VariationDetails: Codable {
  var id, productID: Int?
  var parentChild: String?
  var variantImage: [String]?
  var colorID, sizeID: String?
  var bust, waist, hip, shoulder: String?
  var sleeveLength, length: String?
  var totalStock, sku: String?
  var skuThresholdValue: String?
  var actualPrice, discountType, discountValue, finalPrice: String?
  var status, createdAt, updatedAt: String?
  var color, size: Color?
  
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
  var id: Int?
  var name, hexCode: String?
  var createdAt, updatedAt: String?
  
  enum CodingKeys: String, CodingKey {
    case id, name
    case hexCode = "hex_code"
    case createdAt = "created_at"
    case updatedAt = "updated_at"
  }
}

struct StepImage {
  let selected: String
  let unselected: String
}
