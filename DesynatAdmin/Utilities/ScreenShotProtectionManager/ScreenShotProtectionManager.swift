//
//  ScreenProtectionManager.swift
//  DesynatAdmin
//
//  Created by fluper_mac3 on 20/03/26.
//

import UIKit

class ScreenshotProtectionManager {
    private weak var protectedWindow: UIWindow?
    private var secureTextField: UITextField?
    
    func enableProtection(for window: UIWindow) {
        guard secureTextField == nil else { return }
        
        let field = UITextField()
        field.isSecureTextEntry = true
        
        // Create protection view with image - matching original implementation
        let protectionView = UIView(frame: CGRect(x: 0, y: 0, width: field.frame.size.width, height: field.frame.size.height))
        
        if let image = UIImage(named: "Screen_Shot_Prevented") {
            let imageView = UIImageView(image: image)
            imageView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            protectionView.addSubview(imageView)
        } else {
            // Fallback if image doesn't exist
            protectionView.backgroundColor = .white
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
            label.text = "Content Protected"
            label.textAlignment = .center
            label.font = .systemFont(ofSize: 24, weight: .bold)
            label.textColor = .darkGray
            protectionView.addSubview(label)
        }
        
        field.leftView = protectionView
        field.leftViewMode = .always
        
        // Add field to window first (matching original)
        window.addSubview(field)
        
        // Store references
        self.protectedWindow = window
        self.secureTextField = field
        
        // The magic layer manipulation - EXACTLY matching original working code
        // Original code: window.layer.superlayer?.addSublayer(field.layer)
        // Original code: field.layer.sublayers?.last?.addSublayer(window.layer)
        window.layer.superlayer?.addSublayer(field.layer)
        field.layer.sublayers?.last?.addSublayer(window.layer)
        
//        print("🔒 Screenshot protection enabled")
    }
    
    func disableProtection() {
        guard let field = secureTextField,
              let window = protectedWindow else { return }
        
        // Remove layers from their current parents
        window.layer.removeFromSuperlayer()
        field.layer.removeFromSuperlayer()
        
        // Remove field from window
        field.removeFromSuperview()
        
        // Clean up references
        self.secureTextField = nil
        self.protectedWindow = nil
        
//        print("🔓 Screenshot protection disabled")
    }
}


//MARK: Usage in Scene Delegate inside willConnectTo

//var window: UIWindow?
//private let protectionManager = ScreenshotProtectionManager()
//if let window = window {
//    protectionManager.enableProtection(for: window)
//}
