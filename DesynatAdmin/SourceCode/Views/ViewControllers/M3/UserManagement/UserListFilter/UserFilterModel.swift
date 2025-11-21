//
//  UserFilterModel.swift
//  DesynatAdmin
//
//  Created by fluper on 21/11/25.
//


struct UserFilterModel {
    var countryId: Int?
    var fromDate: String?
    var toDate: String?
    
    var isEmpty: Bool {
        return countryId == nil && fromDate == nil && toDate == nil
    }
}
