//
//  OrderDataModel.swift
//  DesynatAdmin
//
//  Created by Chandra Prakash on 23/12/25.
//

import Foundation
//struct OrderListModel: Codable {
//  var currentPage: Int?
//  var data: [OrderData]?
//  var firstPageURL: String?
//  var from, lastPage: Int?
//  var lastPageURL: String?
//  var links: [Link]?
//  var nextPageURL: String?
//  var path: String?
//  var perPage: Int?
//  var prevPageURL: String?
//  var to, total: Int?
//
//  enum CodingKeys: String, CodingKey {
//    case currentPage = "current_page"
//    case data
//    case firstPageURL = "first_page_url"
//    case from
//    case lastPage = "last_page"
//    case lastPageURL = "last_page_url"
//    case links
//    case nextPageURL = "next_page_url"
//    case path
//    case perPage = "per_page"
//    case prevPageURL = "prev_page_url"
//    case to, total
//  }
//}

// MARK: - OrderData
//struct OrderData: Codable {
//  var id: Int?
//  var orderID: Int?
//  var userID, deliveryAddress: Int?
//  var totalMrp, discountMrp, promocodeStatus: String?
//  var promocodeID, promocodeValue: String?
//  var giftcardAmount, giftcardID: String?
//  var shippingFees, tax: String?
//  var walletAmount: String?
//  var totalAmount, paymentStatus, paymentMethod, deliveryStatus: String?
//  var transactionID, deliveryBoyID: String?
//  var assignStatus: String?
//  var assignDate, notDeliveredReason: String?
//  var createdAt, updatedAt: String?
//  var deliveryDetails: DeliveryDetails?
//  var orderDetails: OrderDetail?
//  var driverDetails: DriverDetails?
//
//  enum CodingKeys: String, CodingKey {
//    case id
//    case orderID = "order_id"
//    case userID = "user_id"
//    case deliveryAddress = "delivery_address"
//    case totalMrp = "total_mrp"
//    case discountMrp = "discount_mrp"
//    case promocodeStatus = "promocode_status"
//    case promocodeID = "promocode_id"
//    case promocodeValue = "promocode_value"
//    case giftcardAmount = "giftcard_amount"
//    case giftcardID = "giftcard_id"
//    case shippingFees = "shipping_fees"
//    case tax
//    case walletAmount = "wallet_amount"
//    case totalAmount = "total_amount"
//    case paymentStatus = "payment_status"
//    case paymentMethod = "payment_method"
//    case deliveryStatus = "delivery_status"
//    case transactionID = "transaction_id"
//    case deliveryBoyID = "delivery_boy_id"
//    case assignStatus = "assign_status"
//    case assignDate = "assign_date"
//    case notDeliveredReason = "not_delivered_reason"
//    case createdAt = "created_at"
//    case updatedAt = "updated_at"
//    case deliveryDetails = "delivery_details"
//    case orderDetails = "order_details"
//    case driverDetails = "driver_details"
//  }
//}

//struct DriverDetails: Codable {
//  var id: Int?
//  var profilePic: String?
//  var fullNameEnglish, fullNameArabic, email, countryCode: String?
//  var mobile, password, unhashedPassword, addressLine1: String?
//  var addressLine2, city, state, driverDetailsLet: String?
//  var long: String?
//  var countryID, zoneID: Int?
//  var otp, otpVerify, deviceType: String?
//  var deviceToken: String?
//  var vehicleName, vehicleRegNo, documentInformation, status: String?
//  var onDuty, createdAt, updatedAt: String?
//  var zoneInfo: ZoneInfos?
//
//  enum CodingKeys: String, CodingKey {
//    case id
//    case profilePic = "profile_pic"
//    case fullNameEnglish = "full_name_english"
//    case fullNameArabic = "full_name_arabic"
//    case email
//    case countryCode = "country_code"
//    case mobile, password
//    case unhashedPassword = "unhashed_password"
//    case addressLine1 = "address_line1"
//    case addressLine2 = "address_line2"
//    case city, state
//    case driverDetailsLet = "let"
//    case long
//    case countryID = "country_id"
//    case zoneID = "zone_id"
//    case otp
//    case otpVerify = "otp_verify"
//    case deviceType = "device_type"
//    case deviceToken = "device_token"
//    case vehicleName = "vehicle_name"
//    case vehicleRegNo = "vehicle_reg_no"
//    case documentInformation = "document_information"
//    case status
//    case onDuty = "on_duty"
//    case createdAt = "created_at"
//    case updatedAt = "updated_at"
//    case zoneInfo = "zone_info"
//  }
//}

// MARK: - ZoneInfo
//struct ZoneInfos: Codable {
//  var id, countryID, cityID: Int?
//  var nameEnglish, nameArabic: String?
//  var coordinates: [Coordinate]?
//  var status: Int?
//  var createdAt, updatedAt: String?
//
//  enum CodingKeys: String, CodingKey {
//    case id
//    case countryID = "country_id"
//    case cityID = "city_id"
//    case nameEnglish = "name_english"
//    case nameArabic = "name_arabic"
//    case coordinates, status
//    case createdAt = "created_at"
//    case updatedAt = "updated_at"
//  }
//}

// MARK: - DeliveryDetails
//struct DeliveryDetails: Codable {
//  var id, userID: Int?
//  var name, mobile, countryCode, address: String?
//  var houseNo: String?
//  var streetNo: String?
//  var postalCode, city, state: String?
//  var countryName, landmark: String?
//  var saveAddressAs, status: Int?
//  var latitude, longitude, createdAt, updatedAt: String?
//
//  enum CodingKeys: String, CodingKey {
//    case id
//    case userID = "user_id"
//    case name, mobile
//    case countryCode = "country_code"
//    case address
//    case houseNo = "house_no"
//    case streetNo = "street_no"
//    case postalCode = "postal_code"
//    case city, state
//    case countryName = "country_name"
//    case landmark
//    case saveAddressAs = "save_address_as"
//    case status, latitude, longitude
//    case createdAt = "created_at"
//    case updatedAt = "updated_at"
//  }
//}

// MARK: - OrderDetail
//struct OrderDetail: Codable {
//  var id, userID, productID: Int?
//  var orderID: String?
//  var variantsID, quantity: Int?
//  var amount, status, createdAt, updatedAt: String?
//  var returnType, rEApprove: String?
//  var returnReason,cancelReason, returnImage, exchangeReason, exchangeNewSize: String?
//  var exchangeOldSize: String?
//  var paymentStatus, deliveryStatus: String?
//  var productDetails: ProductDetails?
//  var variationDetails: VariationDetails?
//
//  enum CodingKeys: String, CodingKey {
//    case id
//    case orderID = "order_id"
//    case userID = "user_id"
//    case productID = "product_id"
//    case variantsID = "variants_id"
//    case quantity, amount, status
//    case createdAt = "created_at"
//    case updatedAt = "updated_at"
//    case returnType = "return_type"
//    case rEApprove = "r_e_approve"
//    case returnReason = "return_reason"
//    case returnImage = "return_image"
//    case exchangeReason = "exchange_reason"
//    case cancelReason = "cancel_reason"
//    case exchangeNewSize = "exchange_new_size"
//    case exchangeOldSize = "exchange_old_size"
//    case paymentStatus = "payment_status"
//    case deliveryStatus = "delivery_status"
//    case productDetails = "product_details"
//    case variationDetails = "variation_details"
//  }
//}

// MARK: - ProductDetails
//struct ProductDetails: Codable {
//  var id: Int?
//  var sellerID, storeID, categoryID, subcategoryID: String?
//  var brandID: String?
//  var otherEn, otherAr: String?
//  var productNameEn, productNameAr, descriptionEn, descriptionAr: String?
//  var minCardQuantity, maxCardQuantity, productReturn: String?
//  var returnDays: String?
//  var productExchangable: String?
//  var exchangableDays: String?
//  var reviewRating, affiliatedProduct: String?
//  var affiliatedCommission: String?
//  var customizedProduct, readyToShip, cashOnDelivery: String?
//  var uploadSizeChart: String?
//  var productActiveStatus: Int?
//  var createdAt, updatedAt: String?
//  var brand: Brand?
//  var category: Category?
//  var subcategory: Brand?
//  var sellerDetails: SellerDetails?
//
//  enum CodingKeys: String, CodingKey {
//    case id
//    case sellerID = "seller_id"
//    case storeID = "store_id"
//    case categoryID = "category_id"
//    case subcategoryID = "subcategory_id"
//    case brandID = "brand_id"
//    case otherEn = "other_en"
//    case otherAr = "other_ar"
//    case productNameEn = "product_name_en"
//    case productNameAr = "product_name_ar"
//    case descriptionEn = "description_en"
//    case descriptionAr = "description_ar"
//    case minCardQuantity = "min_card_quantity"
//    case maxCardQuantity = "max_card_quantity"
//    case productReturn = "product_return"
//    case returnDays = "return_days"
//    case productExchangable = "product_exchangable"
//    case exchangableDays = "exchangable_days"
//    case reviewRating = "review_rating"
//    case affiliatedProduct = "affiliated_product"
//    case affiliatedCommission = "affiliated_commission"
//    case customizedProduct = "customized_product"
//    case readyToShip = "ready_to_ship"
//    case cashOnDelivery = "cash_on_delivery"
//    case uploadSizeChart = "upload_size_chart"
//    case productActiveStatus = "product_active_status"
//    case createdAt = "created_at"
//    case updatedAt = "updated_at"
//    case brand, category, subcategory
//    case sellerDetails = "seller_details"
//  }
//}

// MARK: - Brand
//struct Brand: Codable {
//  var id: Int?
//  var nameEnglish: String?
//  var nameArabic: String?
//  var image: String?
//  var status: Int?
//  var createdAt, updatedAt: String?
//  var categoryID: Int?
//
//  enum CodingKeys: String, CodingKey {
//    case id
//    case nameEnglish = "name_english"
//    case nameArabic = "name_arabic"
//    case image, status
//    case createdAt = "created_at"
//    case updatedAt = "updated_at"
//    case categoryID = "category_id"
//  }
//}

// MARK: - Category
//struct Category: Codable {
//  var id: Int?
//  var name: String?
//  var description: String?
//  var image: String?
//  var status: Int?
//  var colorCode: String?
//  var createdAt: String?
//  var updatedAt: String?
//
//  enum CodingKeys: String, CodingKey {
//    case id, name, description, image, status
//    case colorCode = "color_code"
//    case createdAt = "created_at"
//    case updatedAt = "updated_at"
//  }
//}


// MARK: - VariationDetails
//struct VariationDetails: Codable {
//  var id, productID: Int?
//  var parentChild: String?
//  var variantImage: [String]?
//  var colorID, sizeID: String?
//  var bust, waist, hip, shoulder: String?
//  var sleeveLength, length: String?
//  var totalStock, sku: String?
//  var skuThresholdValue: String?
//  var actualPrice, discountType, discountValue, finalPrice: String?
//  var status, createdAt, updatedAt: String?
//  var color, size: Color?
//
//  enum CodingKeys: String, CodingKey {
//    case id
//    case productID = "product_id"
//    case parentChild = "parent_child"
//    case variantImage = "variant_image"
//    case colorID = "color_id"
//    case sizeID = "size_id"
//    case bust, waist, hip, shoulder
//    case sleeveLength = "sleeve_length"
//    case length
//    case totalStock = "total_stock"
//    case sku
//    case skuThresholdValue = "sku_threshold_value"
//    case actualPrice = "actual_price"
//    case discountType = "discount_type"
//    case discountValue = "discount_value"
//    case finalPrice = "final_price"
//    case status
//    case createdAt = "created_at"
//    case updatedAt = "updated_at"
//    case color, size
//  }
//}

// MARK: - Color
//struct Color: Codable {
//  var id: Int?
//  var name, hexCode: String?
//  var createdAt, updatedAt: String?
//
//  enum CodingKeys: String, CodingKey {
//    case id, name
//    case hexCode = "hex_code"
//    case createdAt = "created_at"
//    case updatedAt = "updated_at"
//  }
//}

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
  let returnReason, returnImage, exchangeReason, exchangeNewSize: String?
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
  let otp, otpVerify, deviceType: String?
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

// MARK: - Coordinate
//struct Coordinate: Codable {
//    let lat, lng: String?
//}

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

// MARK: - SellerDetails
//struct SellerDetails: Codable {
//    let id: Int?
//    let profilePic: String?
//    let firstName, lastName, countryCode, mobile: String?
//    let email, password, acceptTerms, otp: String?
//    let otpVerify: String?
//    let deviceType, deviceToken: String?
//    let adminVerify, storeInformation, bankInformation: String?
//    let rejectReason, lang: String?
//    let isBlock: Int?
//    let affilateCommission: String?
//    let createdAt, updatedAt: String?
//
//    enum CodingKeys: String, CodingKey {
//        case id
//        case profilePic = "profile_pic"
//        case firstName = "first_name"
//        case lastName = "last_name"
//        case countryCode = "country_code"
//        case mobile, email, password
//        case acceptTerms = "accept_terms"
//        case otp
//        case otpVerify = "otp_verify"
//        case deviceType = "device_type"
//        case deviceToken = "device_token"
//        case adminVerify = "admin_verify"
//        case storeInformation = "store_information"
//        case bankInformation = "bank_information"
//        case rejectReason = "reject_reason"
//        case lang
//        case isBlock = "is_block"
//        case affilateCommission = "affilate_commission"
//        case createdAt = "created_at"
//        case updatedAt = "updated_at"
//    }
//}

// MARK: - Store
struct Store: Codable {
  let id, sellerID: Int?
  let storeImage: String?
  let storeName, country, storeAddress, addressLine1: String?
  let addressLine2, storePhone, countryCode, storeMailID: String?
  let storeAvailability: Int?
  let bio, storeLet, long, createdAt: String?
  let updatedAt: String?
  
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
