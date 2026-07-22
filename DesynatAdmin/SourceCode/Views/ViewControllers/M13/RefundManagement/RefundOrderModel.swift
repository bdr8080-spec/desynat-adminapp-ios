//
//  RefundOrderModel.swift
//  DesynatAdmin
//
//  Created by Fluper New Mac1 on 22/07/26.
//

import Foundation

// MARK: - DataClass
struct RefundOrderModel: Codable {
    var walletBalance, amount: Int?

    enum CodingKeys: String, CodingKey {
        case walletBalance = "wallet_balance"
        case amount
    }
}
