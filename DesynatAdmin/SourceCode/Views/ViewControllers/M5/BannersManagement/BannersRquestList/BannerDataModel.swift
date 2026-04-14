//
//  BannerDataModel.swift
//  DesynatAdmin
//
//  Created by Chandra Prakash on 22/12/25.
//

import Foundation

struct BannerRequestModel: Codable {
    var currentPage: Int?
    var data: [BannerRequestData]?
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

// MARK: - BannerRequestData
struct BannerRequestData: Codable {
    var id: Int?
    var orderID: String?
    var sellerID: Int?
    var status: String?
    var bannerPosition: String?
    var category, subcatgory: String?
    var startDate, endDate, totalDays: String?
    var uploadBanner: String?
    var price, adminVerify, paymentStatus: String?
    var transactionID, cancelledReason: String?
    var createdAt, updatedAt: String?
    var categoryDetails: CategoryDetails?
    var subcategoryDetails: SubcategoryDetails?
    var sellerDetails: SellerDetails?
    var store: Store?

    enum CodingKeys: String, CodingKey {
        case id
        case orderID = "order_id"
        case sellerID = "seller_id"
        case bannerPosition = "banner_position"
        case category, subcatgory, store
        case startDate = "start_date"
        case endDate = "end_date"
        case totalDays = "total_days"
        case uploadBanner = "upload_banner"
        case price
        case adminVerify = "Admin_verify"
        case status = "status"
        case paymentStatus = "payment_status"
        case transactionID = "transaction_id"
        case cancelledReason = "cancelled_reason"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case categoryDetails = "category_details"
        case subcategoryDetails = "subcategory_details"
        case sellerDetails = "seller_details"
    }
    
    init(id: Int? = nil, orderID: String? = nil, sellerID: Int? = nil, bannerPosition: String? = nil, category: String? = nil, subcatgory: String? = nil, startDate: String? = nil, endDate: String? = nil, totalDays: String? = nil, uploadBanner: String? = nil, price: String? = nil, adminVerify: String? = nil, paymentStatus: String? = nil, transactionID: String? = nil, cancelledReason: String? = nil, createdAt: String? = nil, updatedAt: String? = nil, categoryDetails: CategoryDetails? = nil, subcategoryDetails: SubcategoryDetails? = nil,status: String? = nil, sellerDetails: SellerDetails? = nil) {
        self.id = id
        self.orderID = orderID
        self.sellerID = sellerID
        self.bannerPosition = bannerPosition
        self.category = category
        self.subcatgory = subcatgory
        self.startDate = startDate
        self.endDate = endDate
        self.totalDays = totalDays
        self.uploadBanner = uploadBanner
        self.price = price
        self.adminVerify = adminVerify
        self.paymentStatus = paymentStatus
        self.transactionID = transactionID
        self.cancelledReason = cancelledReason
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.status = status
        self.categoryDetails = categoryDetails
        self.subcategoryDetails = subcategoryDetails
        self.sellerDetails = sellerDetails
    }
}

// MARK: - CategoryDetails
struct CategoryDetails: Codable {
    var id: Int?
    var name, description: String?
    var image: String?
    var status: Int?
    var colorCode, createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id, name, description, image, status
        case colorCode = "color_code"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

// MARK: - SellerDetails
struct SellerDetails: Codable {
    var id: Int?
    var profilePic: String?
    var firstName, lastName, countryCode, mobile: String?
    var email, password, acceptTerms, otp: String?
    var otpVerify: String?
    var deviceToken: String?
//    var deviceType, deviceToken: String?
    var adminVerify, storeInformation, bankInformation: String?
    var rejectReason, lang: String?
    var isBlock: Int?
    var affilateCommission: String?
    var createdAt, updatedAt: String?
    var countryDetails: CountryDetails?
    var storeInfo: StoreInfo?

    enum CodingKeys: String, CodingKey {
        case id
        case profilePic = "profile_pic"
        case firstName = "first_name"
        case lastName = "last_name"
        case countryCode = "country_code"
        case mobile, email, password
        case acceptTerms = "accept_terms"
        case otp
        case otpVerify = "otp_verify"
//        case deviceType = "device_type"
        case deviceToken = "device_token"
        case adminVerify = "admin_verify"
        case storeInformation = "store_information"
        case storeInfo = "store_info"
        case bankInformation = "bank_information"
        case rejectReason = "reject_reason"
        case lang
        case isBlock = "is_block"
        case affilateCommission = "affilate_commission"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case countryDetails = "country_details"
    }
    
    init(id: Int? = nil, profilePic: String? = nil, firstName: String? = nil, lastName: String? = nil, countryCode: String? = nil, mobile: String? = nil, email: String? = nil, password: String? = nil, acceptTerms: String? = nil, otp: String? = nil, otpVerify: String? = nil, deviceType: String? = nil, deviceToken: String? = nil, adminVerify: String? = nil, storeInformation: String? = nil, bankInformation: String? = nil, rejectReason: String? = nil, lang: String? = nil, isBlock: Int? = nil, affilateCommission: String? = nil, createdAt: String? = nil, updatedAt: String? = nil, countryDetails: CountryDetails? = nil) {
        self.id = id
        self.profilePic = profilePic
        self.firstName = firstName
        self.lastName = lastName
        self.countryCode = countryCode
        self.mobile = mobile
        self.email = email
        self.password = password
        self.acceptTerms = acceptTerms
        self.otp = otp
        self.otpVerify = otpVerify
//        self.deviceType = deviceType
        self.deviceToken = deviceToken
        self.adminVerify = adminVerify
        self.storeInformation = storeInformation
        self.bankInformation = bankInformation
        self.rejectReason = rejectReason
        self.lang = lang
        self.isBlock = isBlock
        self.affilateCommission = affilateCommission
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.countryDetails = countryDetails
    }
}

// MARK: - CountryDetails
struct CountryDetails: Codable {
    var id: Int?
    var name, isoCode, currencyName, currencyCode: String?
    var currencySymbol, dialCode, flag: String?
    var flag1: String?
    var exchangeRateToKwd, createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id, name
        case isoCode = "iso_code"
        case currencyName = "currency_name"
        case currencyCode = "currency_code"
        case currencySymbol = "currency_symbol"
        case dialCode = "dial_code"
        case flag, flag1
        case exchangeRateToKwd = "exchange_rate_to_kwd"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
    
    init(id: Int? = nil, name: String? = nil, isoCode: String? = nil, currencyName: String? = nil, currencyCode: String? = nil, currencySymbol: String? = nil, dialCode: String? = nil, flag: String? = nil, flag1: String? = nil, exchangeRateToKwd: String? = nil, createdAt: String? = nil, updatedAt: String? = nil) {
        self.id = id
        self.name = name
        self.isoCode = isoCode
        self.currencyName = currencyName
        self.currencyCode = currencyCode
        self.currencySymbol = currencySymbol
        self.dialCode = dialCode
        self.flag = flag
        self.flag1 = flag1
        self.exchangeRateToKwd = exchangeRateToKwd
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

// MARK: - SubcategoryDetails
struct SubcategoryDetails: Codable {
    var id, categoryID: Int?
    var nameEnglish, nameArabic: String?
    var image: String?
    var status: Int?
    var createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case categoryID = "category_id"
        case nameEnglish = "name_english"
        case nameArabic = "name_arabic"
        case image, status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
    
    init(id: Int? = nil, categoryID: Int? = nil, nameEnglish: String? = nil, nameArabic: String? = nil, image: String? = nil, status: Int? = nil, createdAt: String? = nil, updatedAt: String? = nil) {
        self.id = id
        self.categoryID = categoryID
        self.nameEnglish = nameEnglish
        self.nameArabic = nameArabic
        self.image = image
        self.status = status
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
