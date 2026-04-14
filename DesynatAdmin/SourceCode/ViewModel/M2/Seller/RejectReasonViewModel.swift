//
//  RejectReasonViewModel.swift
//  DesynatAdmin
//
//  Created by Meet Goti on 07/11/25.
//

import Foundation
class RejectReasonViewModel {
    private(set) var reason : String = ""
    private(set) var rejectType : SellerRejectionType = .completeProject
    
    func setReason(_ string:String)  {
        self.reason = string
    }
    
    func setRejectTyp(_ type:SellerRejectionType)  {
        self.rejectType = type
    }
}
