//
//  StringConstant.swift
//  ChorApp
//
//  Created by Developer on 05/12/23.
//

import Foundation

enum StringConstant: String {
    case ok                         = "Ok"
    case done                       = "Done"
    case cancel                     = "Cancel"
    
    func value() -> String {
        return self.rawValue
    }
}

enum AlertConstant: String {
    
    case none = ""
    /// Network validation
    case noInternet                 = "Network connection failed. Please check your internet and try again."
    case noStatusCode               = "No status code found"
    case noResponse                 = "No response data"
    case wentWrong                  = "Something went wrong"
    case noDataFound                = "No data found"
    case unableToDecode             = "Unable to decode data"
    case sessionExpired             = " Your session has expired. Please log in again."
    case imageMimeNotSame           = "Mime type and file are not of same data type"
    case videoMimeNotSame           = "Video Mime type and file are not URL"
    case decodingError              = "Failed to decode response"
    
    ///Validation Error Message
    case EnterEmailAddress          = "Please Enter Emaill address"
//    case EnterEmail                 = "Please Enter Email ID"
    case EnterMobileNumber          = "Please Enter Mobile Number"
    case EnterValidEmailAddress     = "Please Enter Valid Email"
    case validMobileNumber          = "Please enter valid mobile number between 7 to 15 digits"
    case EnterFullName              = "Please enter your full name"
    case EnterValidEmail            = "Please Enter Valid Email address"
    case EnterPassword              = "Please Enter Password"
    case InvalidPasswordFormat      = "Password must be at least 8 characters long, include 1 uppercase, 1 lowercase, and 1 special character"
    case EnterNewPassword           = "Please Enter New Pasword"
    case EnterConfirmPassword       = "Please ReEnter Confrim Pasword"
    case PasswordNotMatched         = "Passwords do not match"
    case AcceptTermsAndConditions   = "Please accept the Terms & Conditions to continue"
    case SelectSubCategoryImage     = "Please Upload Sub Category Image"
    case EnterSubCategoryEnglish    = "Please enter sub-category name in english"
    case EnterSubCategoryArabic     = "Please enter sub-category name in arabic"
    case EnterBrandEnglish          = "Please enter brand name in english"
    case EnterBrandArabic           = "Please enter brand name in arabic"
    case SelectBrandImage           = "Please Upload brand image"
    
    
    func value() -> String {
        return self.rawValue
    }
}

struct MatchCharacterConstant {
    static let capitalAlphabet      = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    static let smallAlphabet        = "abcdefghijklmnopqrstuvwxyz"
    static let spacialCharacter     = "@._!#$%^&*()/<>'+,:;=?[]{}|~`-\""
    static let number               = "0123456789"
    static let timing               = number + ":"
    static let cardExpiration       = number + "/"
}


