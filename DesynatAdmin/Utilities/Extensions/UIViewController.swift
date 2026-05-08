//
//  UIViewController.swift
//  ChorApp
//
//  Created by Developer on 07/12/23.
//

import Foundation
import UIKit
import Toaster
import PDFKit

extension UIViewController {
    
    private static var isAlertVisible = false
    
    public func showAlert(buttonTitle: String? = nil, msg: String, completion: (() -> Void)? = nil) {
        // Prevent multiple alerts
        guard !UIViewController.isAlertVisible else { return }
        UIViewController.isAlertVisible = true
        
        DispatchQueue.main.async {
            let alert = UIAlertController(
                title: Bundle.main.ApplicationName ?? "",
                message: msg,
                preferredStyle: .alert
            )
            
            let actionTitle = buttonTitle ?? StringConstant.ok.value().localiz()
            alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: { _ in
                UIViewController.isAlertVisible = false
                completion?()
            }))
            
            self.present(alert, animated: true)
        }
    }
    
    public func showConfirmationAlert(
        msg: String,
        completion: (() -> Void)? = nil
    ) {
        // Prevent multiple alerts
        guard !UIViewController.isAlertVisible else { return }
        UIViewController.isAlertVisible = true
        
        DispatchQueue.main.async {
            let alert = UIAlertController(
                title: Bundle.main.ApplicationName ?? "",
                message: msg,
                preferredStyle: .alert
            )
            
            // Yes Action
            let yesButton = UIAlertAction(title: "Yes".localiz(), style: .default) { _ in
                UIViewController.isAlertVisible = false
                completion?()
            }
            
            // Cancel Action (red color)
            let cancelButton = UIAlertAction(title: "No".localiz(), style: .cancel) { _ in
                UIViewController.isAlertVisible = false
            }
            
            // Apply red color to Cancel button text
            cancelButton.setValue(UIColor.red, forKey: "titleTextColor")
            
            alert.addAction(yesButton)
            alert.addAction(cancelButton)
            
            self.present(alert, animated: true)
        }
    }
    
    static func convertPDFToImages(pdfURL: URL) -> [UIImage]? {
        guard let pdfDocument = PDFDocument(url: pdfURL) else {
            return nil
        }
        var images: [UIImage] = []
        
        for pageNum in 0..<pdfDocument.pageCount {
            if let pdfPage = pdfDocument.page(at: pageNum) {
                let pdfPageSize = pdfPage.bounds(for: .mediaBox)
                let renderer = UIGraphicsImageRenderer(size: pdfPageSize.size)
                
                let image = renderer.image { ctx in
                    UIColor.white.set()
                    ctx.fill(pdfPageSize)
                    ctx.cgContext.translateBy(x: 0.0, y: pdfPageSize.size.height)
                    ctx.cgContext.scaleBy(x: 1.0, y: -1.0)
                    
                    pdfPage.draw(with: .mediaBox, to: ctx.cgContext)
                }
                images.append(image)
            }
        }
        return images
    }
    
    func getCurrentTime() -> String {
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM, hh:mm a"
//        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        if AppLanguageManager.shared.currentLanguage == .ar {
            dateFormatter.locale = Locale(identifier: "ar")
           } else {
               dateFormatter.locale = Locale(identifier: "en_US")
           }
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Kolkata")
        return dateFormatter.string(from: currentDate)
    }
    public func showBlockAlert(msg:String, completion:(()->())? = nil) {
        let alert = UIAlertController(title: Bundle.main.ApplicationName ?? "", message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: StringConstant.ok.value(), style: .default, handler: { _ in
            completion?()
            UserDefaults.standard.set("no", forKey: "isGuest")
            kSharedSceneDelegate.logoutUser()
        }))
        self.present(alert, animated: true)
    }
    
    /// Show Toater Alert
    public func showToast(msg:String) {
        let tost = Toast(text: msg)
        tost.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        tost.view.layer.cornerRadius = 5
        tost.view.textColor = UIColor.white
        tost.start()
    }
    
    func getAttributedText(fullText: String, highlightedText: String, highlightedFont: UIFont, highlightedColor: UIColor) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: fullText)
        
        if let range = fullText.range(of: highlightedText) {
            let nsRange = NSRange(range, in: fullText)
            // Apply both font and color to the highlighted text
            attributedString.addAttributes([
                .font: highlightedFont,
                .foregroundColor: highlightedColor
            ], range: nsRange)
        }
        
        return attributedString
    }
    func formattedMinimumRate(from amount: String?) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.usesGroupingSeparator = false
        numberFormatter.locale = Locale(identifier: "en_US")
        guard let amountString = amount, let value = Double(amountString) else {
            return "0.00"
        }
        numberFormatter.maximumFractionDigits = 2
        numberFormatter.minimumFractionDigits = 2
        
        if let formattedString = numberFormatter.string(from: NSNumber(value: value)) {
            return formattedString
        }
        return "0.00"
    }
    
    
    func formattedMinimu(from amount: Float?) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.usesGroupingSeparator = false
        numberFormatter.locale = Locale(identifier: "en_US")
        
        let value = Double(amount ?? 0)
        
        // Check if the value is a whole number
        if value == floor(value) {
            // If it's a whole number, we can avoid showing decimals
            numberFormatter.minimumFractionDigits = 0
            numberFormatter.maximumFractionDigits = 0
        } else {
            // If it's a floating-point number, we ensure two decimals
            numberFormatter.minimumFractionDigits = 2
            numberFormatter.maximumFractionDigits = 2
        }
        
        if let formattedString = numberFormatter.string(from: NSNumber(value: value)) {
            return formattedString
        }
        
        return "0.00"
    }
    
    func formattedAmount(from amount: Double?) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.usesGroupingSeparator = false
        numberFormatter.locale = Locale(identifier: "en_US")
        
        // Use the Double value directly, with a default of 0.0 if nil
        let value = amount ?? 0.0
        
        // Check if the value is a whole number
        if value == floor(value) {
            // If it's a whole number, we can avoid showing decimals
            numberFormatter.minimumFractionDigits = 0
            numberFormatter.maximumFractionDigits = 0
        } else {
            // If it's a floating-point number, we ensure two decimals
            numberFormatter.minimumFractionDigits = 2
            numberFormatter.maximumFractionDigits = 2
        }
        
        // Format the number and return as a string
        if let formattedString = numberFormatter.string(from: NSNumber(value: value)) {
            return formattedString
        }
        
        return "0.00"
    }
    
    
    func convertDateString(inputDateString: String, inputDateFormat: String, outputDateFormat: String) -> String? {
        // Step 1: Create a DateFormatter to parse the original string
        let originalDateFormatter = DateFormatter()
        originalDateFormatter.dateFormat = inputDateFormat
        originalDateFormatter.timeZone = TimeZone.current // Adjust timezone if necessary
        
        // Step 2: Convert the string to a Date object
        if let date = originalDateFormatter.date(from: inputDateString) {
            
            // Step 3: Create a new DateFormatter for the desired output format
            let outputDateFormatter = DateFormatter()
            outputDateFormatter.dateFormat = outputDateFormat
            outputDateFormatter.locale = Locale(identifier: "en_US") // You can change this to a different locale if necessary
            
            // Step 4: Convert the Date object to the desired format
            let formattedDate = outputDateFormatter.string(from: date)
            return formattedDate
        } else {
            print("Invalid date format")
            return nil
        }
    }
    func removeSpecialCharacters(from string: String) -> String {
        let cleanedString = string.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        return cleanedString
    }
    
    func backController() {
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
        self.navigationController!.popToViewController(viewControllers[viewControllers.count - 2], animated: true)
    }
    func backTwoController() {
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
        self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
    }
    
}


extension UINavigationController {
    func previousViewController() -> UIViewController?{
        let lenght = self.viewControllers.count
        let previousViewController: UIViewController? = lenght >= 2 ? self.viewControllers[lenght-2] : nil
        return previousViewController
    }
    
    func secondPreviousViewController() -> UIViewController?{
        let lenght = self.viewControllers.count
        
        let previousViewController: UIViewController? = lenght >= 3 ? self.viewControllers[lenght-3] : nil
        return previousViewController
    }
    
    func popToViewController(ofClass: AnyClass, animated: Bool = true) {
        if let vc = viewControllers.last(where: { $0.isKind(of: ofClass) }) {
            popToViewController(vc, animated: animated)
        }
    }
    
}


extension UIViewController {
    func presentVC(
        _ controller : UIViewController,
        withNavigation isNavigation: Bool = false,
        withAnimation isAnimate : Bool = true,
        modalPresentationStyle style : UIModalPresentationStyle  = .overCurrentContext
    ) {
        var vc = controller
        if (isNavigation) {
            let navigationController = UINavigationController(rootViewController: vc)
            navigationController.navigationBar.isHidden = true
            navigationController.modalPresentationStyle = .overCurrentContext
            vc = navigationController
        }
        vc.modalPresentationStyle = style
        self.present(vc, animated: isAnimate)
    }
//    func navigate(to controller : UIViewController, withAnimation animation:Bool = true, hasPermission: Bool = true) {
//        self.navigationController?.pushViewController(controller, animated: animation)
//    }
    
    func navigate(to controller: UIViewController,
                  withAnimation animation: Bool = true,
                  hasPermission: Bool = true,
                  commingFromTabbar: Bool = true,
    ) {
        
        if var vc = controller as? PermissionAccessible {
            vc.hasActionPermission = hasPermission
            vc.commingFromTabbar = commingFromTabbar
        }
        
        self.navigationController?.pushViewController(controller, animated: animation)
    }
}

protocol PermissionAccessible {
    var hasActionPermission: Bool { get set }
    var commingFromTabbar: Bool { get set }
}

extension UIView {
    func borderRadiusWithCornerMask(radius : CGFloat , cornerMask: CACornerMask = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner])  {
        self.layer.cornerRadius = radius
        self.layer.maskedCorners = cornerMask
    }
}
extension UIView {
    
    func addGradientBorder(cornerRadius:CGFloat = 0.0,direction:GradiantDirection = .leftToRight,colors:[UIColor] = [.black,.black]) {
        // Remove any existing gradient border layers to prevent duplicates
        layer.sublayers?.filter { $0.name == "gradientBorderLayer" }.forEach { $0.removeFromSuperlayer() }
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = colors.map({$0.cgColor})  // Customize your gradient colors
        
        switch direction {
        case .topToBottom:
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
            gradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0)
        case .bottomToTop:
            gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.5)
        case .leftToRight:
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        case .rightToLeft:
            gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.5)
        }
        gradientLayer.name = "gradientBorderLayer" // Assign a name for easy identification
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.lineWidth = 1.5 // Customize border width
        shapeLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath // Use button's corner radius
        shapeLayer.strokeColor = UIColor.black.cgColor // This color will be masked by the gradient
        shapeLayer.fillColor = UIColor.clear.cgColor
        
        gradientLayer.mask = shapeLayer
        layer.addSublayer(gradientLayer)
    }
    enum GradiantDirection {
        case leftToRight
        case rightToLeft
        case topToBottom
        case bottomToTop
    }
    
    func appendDashedBorder(rect:CGRect? = nil,radius:CGFloat = 5,gap:NSNumber = 2,dashWidth:NSNumber = 4,color:UIColor = UIColor.clear) {
        
        
        let yourViewShapeLayer: CAShapeLayer = CAShapeLayer()
        let frame = rect ?? self.bounds
        yourViewShapeLayer.frame = frame
        yourViewShapeLayer.bounds = frame
        yourViewShapeLayer.position = CGPoint(x: frame.width/2, y: frame.height/2)
        yourViewShapeLayer.fillColor = UIColor.white.cgColor
        yourViewShapeLayer.strokeColor =  color.cgColor
        yourViewShapeLayer.lineWidth = 1
        yourViewShapeLayer.lineJoin = CAShapeLayerLineJoin.round
        yourViewShapeLayer.lineDashPattern = [dashWidth,gap]
        yourViewShapeLayer.path = UIBezierPath(roundedRect: frame, cornerRadius: radius).cgPath
        if let layer = self.layer.sublayers?.first(where: {$0 is CAShapeLayer}) {
            layer.frame = frame
            self.layoutIfNeeded()
        } else {
            self.layer.insertSublayer(yourViewShapeLayer, at: 0)
        }
        
    }
}
extension UIView {
    class func fromNib<T: UIView>() -> T {
        return Bundle(for: T.self).loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
}
