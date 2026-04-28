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
    case EnterEmailAddress          = "Please enter emaill address"
    case EnterMobileNumber          = "Please Enter Mobile Number"
    case EnterValidEmailAddress     = "Please Enter Valid Email"
    case validMobileNumber          = "Please enter valid mobile number between 7 to 15 digits"
    case EnterFullName              = "Please enter your full name"
    case EnterValidEmail            = "Please Enter Valid Email address"
    case EnterPassword              = "Please Enter Password"
    case InvalidPasswordFormat      = "Password must be at least 8 characters long, include 1 uppercase, 1 lowercase, and 1 special character"
    case EnterNewPassword           = "Please Enter New Pasword"
    case PasswordMinLength = "Password must be at least 6 characters long"
    case EnterConfirmPassword       = "Please enter confrim pasword"
    case PasswordNotMatched         = "Passwords do not match"
    case AcceptTermsAndConditions   = "Please accept the Terms & Conditions to continue"
    case SelectSubCategoryImage     = "Please Upload Sub Category Image"
    case EnterSubCategoryEnglish    = "Please enter sub-category name in english"
    case EnterSubCategoryArabic     = "Please enter sub-category name in arabic"
    case EnterBrandEnglish          = "Please enter brand name in english"
    case EnterBrandArabic           = "Please enter brand name in arabic"
    case SelectBrandImage           = "Please Upload brand image"
    case selectCountry =  "Please select country"
    case selectForType =  "Please select type"
    case enterEnglishPlanName =  "Please enter plan name in english"
    case enterArabicPlanName =  "Please enter plan name in Arabic"
    case enterPlanDuration =  "Please enter plan duration"
    case enterNoOfVideo =  "Please Enter Number of Videos"
    case enterNoOfProduct =  "Please Enter Number of products"
    case enterNoOfHighlights =  "Please Enter Number of highlights"
    case enterNoOfEmployee =  "Please Enter Number of employee"
    case enterPlanPrice =  "Please enter plan price"
    case enterComission =  "Please enter comission"
    case comissionShouldLess100 =  "Comission should be equal or less than 100"
    case noOfFreeMonthsShouldLess12 =  "No of free months should be equal or less than 12"
    case enterFreeMonths = " Please enter free months"
    case  selectLocation = "Select Location"
    case  provideZoneBoundary = "Please provide zone boundary."
    case  enterEnglishName = "Please Enter Zone Name in english"
    case  enterArabicName = "Please Enter Zone Name in arabic"
    
    case durationShouldLessThan12 = "Duration should be less than 12 months"
    
    case durationShouldBeOneYear = "For yearly plan, duration must be 1 year"
    case EnterReasonEnglish          = "Please enter reason in english"
    case EnterReasonArabic           = "Please enter reason in arabic"
    case enterAmount                 = "Please enter amount"
    case enterNewDuration = "Please enter new duration"
    
    case selectNewDurationType = "Please select new duration type"
    
    case enterNewPrice = "Please enter new price"
    
    case uploadProfilePicture = "Please upload profile image"
    case enterFullNameEnglish = "Please enter full name in english"
    case enterFullNameArabic = "Please enter full name in arabic"
    
    case enterAddress1 = "Please select Address Line 1"
    case enterAddress2 = "Please enter Address Line 2"
    case enterCity = "Please enter city/district"
    case enterState = "Please enter state"
    case selectZone = "Please select zone"
    
    case enterVehicleName = "Please enter vehicle name"
    case enterVehicleReg = "Please enter vehicle registration"
    
    case uploadVehicleFront = "Please upload vehicle image (front)"
    case uploadVehicleBack = "Please upload vehicle image (back)"
    
    case uploadIdentityFront = "Please upload identity proof (front)"
    case uploadIdentityBack = "Please upload identity proof (back)"
    
    case uploadDLFront = "Please upload driving license (front)"
    case uploadDLBack = "Please upload driving license (back)"
    
    case uploadInsurance = "Please upload vehicle insurance"
    case uploadPollution = "Please upload pollution paper"
    
    case uploadRCFront = "Please upload RC front image"
    case uploadRCBack = "Please upload RC back image"
    
    case EnterCardEnglish          = "Please enter gift card category name in english" //Gift Card Category Name
    case EnterCardArabic           = "Please enter gift card category name in arabic"
    case SelectCardImage           = "please upload image"
    
    
    case SelectBannerImage     = "Please Upload Advertisement Image"
    case EnterAdvTitle     = "Please enter title"
    case SelectFromDate     = "Please select from date"
    case SelectToDate     = "Please select to date"
    
    case SelectCategory          = "Please select category" //Gift Card Category Name
    case SelectSubCategory          = "Please select sub-category" //Gift Card Category Name
    case EnterDiscount           = "Please enter discount"
    case selectForPosition =  "Please select position"
    
    case enterNotificationTitleInEng =  "Please enter title in english"
    case enterNotificationTitleInArabic =  "Please enter title in arabic"
    case enterNotificationDescInEng =  "Please enter description in english"
    case enterNotificationDescInArabic =  "Please enter description in arabic"
    case selectRoleForNotification =  "Please select role"
    case enterQuestionInEng =  "Please enter question in english"
    case enterQuestionInArab =  "Please enter question in arabic"
    case enterAnswerInEng =  "Please enter answer in english"
    case enterAnswerInArab =  "Please enter answer in arabic"
    case selectModule =  "Please select at least one module"
    
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


