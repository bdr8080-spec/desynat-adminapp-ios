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
    
    case verifyOTP                          = "api/admin/admin_verify_otp"
    case loginUser                          = "api/admin/admin_login"
    case forgotPassword                     = "api/admin/admin_forgot_password"
    case createPassword                     = "api/admin/admin_create_password"
    
    func withBaseURL() -> String {
        return "\(BaseURL.value())\(self.rawValue)"
    }
}

enum NetworkURL {
    case endpoint(NetworkEndPoint)
    case custom(String)
}

