//
//  CountryCityDataModels.swift
//  DesynatAdmin
//
//  Created by Meet Goti on 11/11/25.
//

import Foundation
import CoreLocation
struct CountryCitiesDataModel: Codable {
    
    var id: Int?
    var countryId: Int?
    var name: String?
    var nameAr: String?
    var createdAt: String?
    var updatedAt: String?
    
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case countryId = "country_id"
        case name = "name"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case nameAr = "name_ar"
    }
    
}

struct AdminCityModel:Codable {
    var currentPage: Int?
    var data: [CitiesDataModel]?
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

struct CitiesDataModel: Codable {
    
    var id: Int?
    var countryId: Int?
    var cityId: Int?
    var name: String?
    var status: Int?
    var createdAt: String?
    var updatedAt: String?
    
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case countryId = "country_id"
        case cityId = "city_id"
        case name = "name"
        case status = "status"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
    
}
struct AdminZoneModel:Codable {
    var currentPage: Int?
    var data: [ZoneDataModel]?
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

struct ZoneDataModel: Codable {
    
    var countryId: Int?
    var cityId: Int?
    var status: Int?
    var nameEnglish: String?
    var nameArabic: String?
    var coordinates: [Coordinates]?
    var updatedAt: String?
    var createdAt: String?
    var id: Int?
    
    private enum CodingKeys: String, CodingKey {
        case countryId = "country_id"
        case cityId = "city_id"
        case nameEnglish = "name_english"
        case nameArabic = "name_arabic"
        case coordinates
        case updatedAt = "updated_at"
        case status
        case createdAt = "created_at"
        case id
    }
}

struct Coordinates: Codable {
    
    var lat: String?
    var lng: String?
    
    private enum CodingKeys: String, CodingKey {
        case lat
        case lng
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        lat = Coordinates.decodeValue(forKey: .lat, from: container)
        lng = Coordinates.decodeValue(forKey: .lng, from: container)
    }
    
    private static func decodeValue(
        forKey key: CodingKeys,
        from container: KeyedDecodingContainer<CodingKeys>
    ) -> String? {
        
        if let stringValue = try? container.decode(String.self, forKey: key) {
            return stringValue
        }
        
        if let doubleValue = try? container.decode(Double.self, forKey: key) {
            return "\(doubleValue)"
        }
        
        if let intValue = try? container.decode(Int.self, forKey: key) {
            return "\(intValue)"
        }
        
        return nil
    }
    
    var coordinates: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(
            latitude: Double(lat ?? "") ?? 0.0,
            longitude: Double(lng ?? "") ?? 0.0
        )
    }
}
