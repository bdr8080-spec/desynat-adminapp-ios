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
    var createdAt: String?
    var updatedAt: String?

    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case countryId = "country_id"
        case name = "name"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
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
        case coordinates = "coordinates"
        case updatedAt = "updated_at"
        case status = "status"
        case createdAt = "created_at"
        case id = "id"
    }
}
struct Coordinates: Codable {

    var lat: String?
    var lng: String?

    private enum CodingKeys: String, CodingKey {
        case lat = "lat"
        case lng = "lng"
    }

    var coordinates:CLLocationCoordinate2D {
        return CLLocationCoordinate2DMake(Double.getDouble(self.lat), Double.getDouble(self.lng))
    }
}
