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
    
    func withBaseURL() -> String {
        return "\(BaseURL.value())\(self.rawValue)"
    }
}

enum NetworkURL {
    case endpoint(NetworkEndPoint)
    case custom(String)
}

