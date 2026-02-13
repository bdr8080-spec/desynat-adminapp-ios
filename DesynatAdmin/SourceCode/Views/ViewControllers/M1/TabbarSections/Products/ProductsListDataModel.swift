//
//  ProductsListDataModel.swift
//  DesynatAdmin
//
//  Created by fluper_mac3 on 13/02/26.
//


import Foundation

// MARK: - ProductsListDataModel
struct ProductsListDataModel: Codable {
    let allProductCount, activeProductCount, inactiveProductCount: Int?
    var allProductData, activeProduct: [ProductsList]?
    var inactiveProduct: [ProductsList]?
    
    enum CodingKeys: String, CodingKey {
        case allProductCount = "all_product_count"
        case activeProductCount = "active_product_count"
        case inactiveProductCount = "inactive_product_count"
        case allProductData = "all_product_data"
        case activeProduct = "active_product"
        case inactiveProduct = "inactive_product"
    }
}

// MARK: - ProductsList
struct ProductsList: Codable {
    let id: Int?
    let storeID,sellerID, categoryID, subcategoryID: String?
    let brandID, otherEn, otherAr, productNameEn: String?
    let productNameAr, descriptionEn, descriptionAr, minCardQuantity: String?
    let maxCardQuantity, productReturn, returnDays, productExchangable: String?
    let exchangableDays, reviewRating, affiliatedProduct, customizedProduct: String?
    let readyToShip, cashOnDelivery: String?
    let uploadSizeChart: String?
    var productActiveStatus, avgProductRating: Int?
    let createdAt, updatedAt, stock: String?
    let category: Category?
    let brand: Brand?
    let subcategory: SubcategoryDetails?
    let productSpecifications: [ProductSpecification]?
    let productVariants: [ProductVariantsList]?
    
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
        case avgProductRating = "avg_product_rating"
        case productExchangable = "product_exchangable"
        case exchangableDays = "exchangable_days"
        case reviewRating = "review_rating"
        case affiliatedProduct = "affiliated_product"
        case customizedProduct = "customized_product"
        case readyToShip = "ready_to_ship"
        case cashOnDelivery = "cash_on_delivery"
        case uploadSizeChart = "upload_size_chart"
        case productActiveStatus = "product_active_status"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case stock, category, subcategory, brand
        case productSpecifications = "product_specifications"
        case productVariants = "product_variants"
    }
}

// MARK: - ProductSpecification
struct ProductSpecification: Codable {
    let id: Int?
    let productID, nameEn, featureEn, nameAr: String?
    let featureAr, createdAt, updatedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case productID = "product_id"
        case nameEn = "name_en"
        case featureEn = "feature_en"
        case nameAr = "name_ar"
        case featureAr = "feature_ar"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

//// MARK: - ProductVariantsList
struct ProductVariantsList: Codable {
    let id, productID: Int?
    let variantImage: [String]?
    let colorID, sizeID: String?
    let bust, waist, hip, shoulder: String?
    let sleeveLength, length: String?
    let totalStock, sku, skuThresholdValue, actualPrice: String?
    let discountType, discountValue, finalPrice, status: String?
    let createdAt, updatedAt: String?
    let color: ColorsLisDataModel?
    let size :SizeListDataModel?
    
    enum CodingKeys: String, CodingKey {
        case id
        case productID = "product_id"
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
        case color
        case size
    }
}

// MARK: - ColorsLisDataModel
struct ColorsLisDataModel: Codable {
    let id: Int?
    let name, hexCode: String?
    let createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id, name
        case hexCode = "hex_code"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

// MARK: - SizeListDataModel
struct SizeListDataModel: Codable {
    var id: Int?
    var name, createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id, name
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}


struct AppliedFilter {
    var categoryIDs: [String] = []
    var brandIDs: [String] = []
}
