import Foundation

enum BaseURL {
    static let development  = "http://157.241.119.72/"
    static let release      = "http://157.241.119.72/"
    
    static func value() -> String {
        switch BuildConfiguration.shared.environment {
        case .debug:
            return BaseURL.development
        case .release:
            return BaseURL.release
        }
    }
}

enum NetworkEndPoint: String {
    
    //Auth
    case verifyOTP                          = "api/admin/admin_verify_otp"
    case loginUser                          = "api/admin/admin_login"
    case forgotPassword                     = "api/admin/admin_forgot_password"
    case createPassword                     = "api/admin/admin_create_password"
    case resendOTP                          = "api/admin/resend_otp"
    
    //Home
    case getCountry                         = "api/country"
    case getCategory                        = "api/admin/get_category"
    case getSubcategories                   = "api/admin/get_subcategories"
    case changeCategoryStatus               = "api/admin/change_category_status"
    case changeSubcategoryStatus            = "api/admin/change_subcategory_status"
    case uploadFile                         = "api/upload"
    case addSubCategory                     = "api/admin/add_subcategory"
    case editSubCategory                    = "api/admin/update_subcategory"
    case deleteSubCategory                  = "api/admin/delete_subcategory"
    case getAllBrands                       = "api/admin/get_brand"
    case addNewBrands                       = "api/admin/add_brand"
    case changeBrandStatus                  = "api/admin/change_brand_status"
    case deleteBrand                        = "api/admin/delete_brand"
    case updateBrand                        = "api/admin/update_brand"
    case logoutUser                         = "api/admin/admin_logout"
    
    //Seller
    case getNewSellers                         = "api/admin/get_new_sellers"
    case getApprovedSellers                         = "api/admin/get_approved_sellers"
    case getRejectedSellers                         = "api/admin/get_rejected_sellers"
    case getSellerDetail                         = "api/admin/get_seller_details"
    case acceptSeller                         = "api/admin/accept_seller"
    case blockUnBlockSeller                         = "api/admin/block_unblock_seller"
    case rejectSeller                         = "api/admin/reject_seller"
    
    case getCountries                         = "api/admin/get_countries"
    case getCitites                         = "api/admin/get_cities"
    case getServiceCitites                         = "api/admin/get_service_cities"
    case addServiceCity                         = "api/admin/add_service_city"
    case changeServiceCityStatus                         = "api/admin/change_service_city_status"
    case deleteServiceCity                         = "api/admin/delete_service_city"
    case addZone                         = "api/admin/add_zone"
    case getZone                         = "api/admin/get_zones"
    case getZoneDetails                         = "api/admin/get_zone_details"
    case updateZone                         = "api/admin/update_zone"
    case changeUpdateZoneStatus                         = "api/admin/change_zone_status"
    case delteZone                         = "api/admin/delete_zone"
    
    case addPlan                         = "api/admin/add_plan"
    case updatePlan                         = "api/admin/update_plan"
    case getPlans                         = "api/admin/get_plans"
    case getPlanDetails                         = "api/admin/get_plan_details"
    case changePlanStatus                         = "api/admin/change_plan_status"
    case deltePlan                         = "api/admin/delete_plan"
    
    
    //UserManagement
    case getUsers                         = "api/admin/get_users"
    case getUserDetails                   = "api/admin/get_user_details"
    case updateUserStatus                 = "api/admin/block_unblock_user"
    case addWalletAmount                  = "api/admin/add_user_wallet_amount"
    
    //ReasonManagement
    case getReasonsList                   = "api/admin/get_reasons"
    case updateReasonStatus               = "api/admin/change_reason_status"
    case updateReason                     = "api/admin/update_reason"
    case deleteReason                     = "api/admin/delete_reason"
    case addReason                     = "api/admin/add_reason"
    
    //DeliveryManagement
    case getDeliveryBoysList              = "api/admin/get_delivery_boys"
    case deleteDeliveryBoys               = "api/admin/delete_deliveryboy"
    case updateDeliveryBoyStatus          = "api/admin/block_unblock_deliveryboy"
    case getCountryListOfDriver          = "api/admin/get_user_countries_list"
    case getZoneListOfDriver          = "api/admin/get_kuwait_zones"
    case addNewDriver          = "api/admin/add_deliveryBoy"
    case getDriverDetails          = "api/admin/get_deliveryboy_details"
    case editDriverDetails          = "api/admin/update_deliveryBoy"
    
    //M4
    case getShippingTaxes          = "api/admin/countries_with_tax_shipping"
    case getShippingTaxesCountry   = "api/admin/shipping_charges_by_countryId"
    case deleteShippingInfo        = "api/admin/delete_shipping_fee"
    case editShippingInfo        = "api/admin/update_shipping_charge"
    case updateStatusOfShippingFee  = "api/admin/blobk_unblock_shippingFee"
    case addShippingFee  = "api/admin/add_tax"
    case addShippingCharges  = "api/admin/add_shipping_charge"
    case getGiftCardsList  = "api/admin/get_giftCards"
    case updateStatusOfGiftCards  = "api/admin/block_unblock_giftCard"
    case deleteGiftCard  = "api/admin/delete_gift_card"
    case editGiftCard  = "api/admin/update_giftCard"
    case addGiftCard  = "api/admin/add_giftCard"
    case getBannersList  = "api/admin/get_banners"
    case addPriceBanners  = "api/admin/add_update_banner"
    
    case getPromocode = "api/admin/get_promocodes"
    case updateStatusPromocode = "api/admin/block_unblock_promocode"
    case deletePromocode = "api/admin/delete_promocode"
    case addPromocode = "api/admin/add_promocode"
    case editPromocode = "api/admin/update_promocode"
    
    //AFFILIATE COMMISSION MANAGEMENT
    case countriesWithAffiliateCommission = "api/admin/countries_with_affiliate_commission"
    case updateAffiliateCommission = "api/admin/update_affiliate_commission"
    
    //BANNER REQUEST MANAGEMENT
    case getBannerRequest = "api/admin/get_banner_request"
    case approveBannerRequest = "api/admin/approve_banner_request"
    case rejectBannerRequest = "api/admin/reject_banner_request"
    
    //ORDER MANAGEMENT
    case activeOrders = "api/admin/active_orders"
    case returnOrders = "api/admin/return_orders"
    case completedOrders = "api/admin/completed_orders"
    case cancelledOrders = "api/admin/cancelled_orders"
    case singleOrderDetail = "api/admin/single_order_detail"
    case getDriversAssign = "api/admin/get_drivers_to_assign"
    case assignDriver = "api/admin/assign_driver"
    case updateBannerRequestStatus = "api/admin/block_unblock_banner_req"
    
  //FULL SCREEN BANNER MANAGEMENT
  case getFullScreenBanners = "api/admin/get_full_banners"
  case getFullScreenDetailsBanners = "api/admin/get_banner_detail"
  case allUserCountry = "api/all_country"
  case addFullScreenBanner = "api/admin/add_full_banner"
  case updateFullScreenBanner = "api/admin/update_full_banner"
  case deleteFullScreenBanner = "api/admin/delete_full_banner"
  
  //M6
  case getAllActiveDeals = "api/admin/get_active_deals"
  case getAllExpiredDeals = "api/admin/get_expired_deals"
  case addNewDeal = "api/admin/add_deal"
  case editDealDetails = "api/admin/update_deal"
  case getDealDetails = "api/admin/get_deal_detail"
  case updateDealStatus = "api/admin/block_unblock_deal"
  case deleteDealDetails = "api/admin/delete_deal"
  
  case addTimeSlots = "api/admin/add_timeslot"
  case editTimeSlots = "api/admin/update_timeslot"
  case getLiveRequestTimeSlots = "api/admin/get_timeslots"
  case updateStatusLiveRequestTimeSlots = "api/admin/block_unblock_timeslot"
  case deleteLiveRequestTimeSlots = "api/admin/delete_timeslot"
  case getLiveRequestTime = "api/admin/get_live_requests"
  case acceptLiveRequest = "api/admin/accept_live_request"
  case rejectLiveRequest = "api/admin/reject_live_request"
  
  case getAdminStories = "api/admin/get_admin_stories"
  case deleteAdminStories = "api/admin/delete_story"
  case uploadImageAndVideo = "api/uploadFile"
  case uploadAdminStory = "api/admin/add_story"
  case uploadFullScreenBanner = "api/uploadWithResolution"
  
    
    //M7
    case getNewAffilaitedUsers = "api/admin/get_new_affilaited_users"
    case getApprovedAffilaitedUsers = "api/admin/get_approved_affilaited_users"
    case getRejectedAffilaitedUsers = "api/admin/get_rejected_affilaited_users"
    case getAffilaitedUsersDetails = "api/admin/get_affiliate_user_details"
    case acceptAffilaitedUsers = "api/admin/accept_affiliate_user"
    case rejectAffilaitedUsers = "api/admin/reject_affiliate_user"
    case blockUnblockAffilaitedUsers = "api/admin/block_unblock_affiliate_user"
    case getDealProductsList         = "api/admin/get_deal_seller_product_list"
    
    func withBaseURL() -> String {
        return "\(BaseURL.value())\(self.rawValue)"
    }
}

enum NetworkURL {
    case endpoint(NetworkEndPoint)
    case custom(String)
}

