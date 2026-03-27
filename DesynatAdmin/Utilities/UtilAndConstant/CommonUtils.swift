import Foundation
import WebKit
import Photos
import UIKit
import SVProgressHUD
import AVFoundation
import DropDown
import FTIndicator

class CommonUtils {
    
    /// This function will help developer to get default country of the user based on locale
    static func getDefaultCountryDialCode() -> String {
        let countryPicker = ADCountryPicker()
        if #available(iOS 16, *) {
            return countryPicker.getDialCode(countryCode: NSLocale.current.region?.identifier ?? "IN") ?? "+91"
        } else {
            return countryPicker.getDialCode(countryCode: NSLocale.current.identifier) ?? "+91"
        }
    }
    static func getDictionary(_ dictData: Any?) -> Dictionary<String, Any> {
        guard let dict = dictData as? Dictionary<String, Any> else {
            guard let arr = dictData as? [Any] else {
                return ["":""]
            }
            return getDictionary(arr.count > 0 ? arr[0] : ["":""])
        }
        return dict
    }
    
    
    static func formatPrice(_ amount: Double?, currency: String = "KD") -> String {
        guard let amount = amount else { return "0 \(currency)" }
        
        let roundedAmount = round(amount * 100) / 100   // Round to 2 decimal places
        if roundedAmount.truncatingRemainder(dividingBy: 1) == 0 {
            // If whole number, show without decimal
            return "\(Int(roundedAmount)) \(currency)"
        } else {
            // Show up to 2 decimal places
            return String(format: "%.2f", roundedAmount) + " \(currency)"
        }
    }
    
    static func updateDiscountPercentageLabel(_ label: UILabel, actualAmountLabel: UILabel, discountType: String?,discountValue: String?) {
        let value = Double(discountValue ?? "0") ?? 0
        guard value > 0 else {
            label.isHidden = true
            actualAmountLabel.isHidden = true
            return
        }
        label.isHidden = false
        actualAmountLabel.isHidden = false
        if discountType == "1" {
            label.text = "\(discountValue ?? "")% Off"
        } else {
            label.text = "\(discountValue ?? "") KD Off"
        }
    }
    
    static func setStrikethrough(label: UILabel, text: String) {
        let attributeString = NSMutableAttributedString(string: text)
        
        // Strikethrough in the same color as the label text
        let textColor = label.textColor ?? .black
        
        attributeString.addAttribute(
            .strikethroughStyle,
            value: NSUnderlineStyle.single.rawValue,
            range: NSRange(location: 0, length: attributeString.length)
        )
        
        attributeString.addAttribute(
            .strikethroughColor,
            value: textColor,
            range: NSRange(location: 0, length: attributeString.length)
        )
        
        // Keep label's current font
        if let font = label.font {
            attributeString.addAttribute(
                .font,
                value: font,
                range: NSRange(location: 0, length: attributeString.length)
            )
        }
        
        label.attributedText = attributeString
    }
    
    
    static func formatPriceStringInput(_ amount: String?, currency: String = "KD") -> String {
        guard
            let amount = amount,
            let doubleAmount = Double(amount)
        else {
            return "0 \(currency)"
        }
        
        let roundedAmount = round(doubleAmount * 100) / 100
        
        if roundedAmount.truncatingRemainder(dividingBy: 1) == 0 {
            return "\(Int(roundedAmount)) \(currency)"
        } else {
            return String(format: "%.2f", roundedAmount) + " \(currency)"
        }
    }
    
    static func getThumbnail(asset: PHAsset, size: CGSize, completion: @escaping (UIImage?) -> Void) {
        let imageManager = PHCachingImageManager()
        let options = PHImageRequestOptions()
        options.deliveryMode = .highQualityFormat
        options.isSynchronous = false
        
        imageManager.requestImage(for: asset,
                                  targetSize: size,
                                  contentMode: .aspectFill,
                                  options: options) { image, _ in
            completion(image)
        }
    }
    
    static func getModelFromAny<T:Decodable>(model:T.Type, data:Any, completion:(T)->()) {
        do {
            if let data = try? JSONSerialization.data(withJSONObject: data, options: .prettyPrinted) {
                let final = try JSONDecoder().decode(model, from: data)
                completion(final)
            }
        } catch let err {
            debugPrint("Err:\(err)")
        }
    }
    
    static func formatPriceStringInputDecimal(_ amount: String?, currency: String = "KD") -> String {
        guard
            let amount = amount,
            let doubleAmount = Double(amount)
        else {
            return "0 \(currency)"
        }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 0   // no forced decimals
        formatter.maximumFractionDigits = 2   // up to 2 decimals
        
        let formattedAmount = formatter.string(from: NSNumber(value: doubleAmount)) ?? "0"
        return "\(formattedAmount) \(currency)"
    }
    
    
    //    static func formatDate(_ date: Date) -> String {
    //        let formatter = DateFormatter()
    //        formatter.dateFormat = "d MMM yyyy"   // e.g. 3 Feb 2025
    //        formatter.locale = Locale(identifier: "en_US")
    //        return formatter.string(from: date)
    //    }
    
    static func formatDate(from dateString: String) -> String? {
        let inputFormatter = ISO8601DateFormatter()
        inputFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        guard let date = inputFormatter.date(from: dateString) else {
            return nil // Return nil if string can't be parsed
        }
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "d MMM yyyy"   // e.g. 5 Oct 2025
        outputFormatter.locale = Locale(identifier: "en_US")
        
        return outputFormatter.string(from: date)
    }
    
    
    static let displayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        return formatter
    }()
    
    static let apiFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        return formatter
    }()
    
    
    
    
    static func formatDateToYYYYMMDD(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter.string(from: date)
    }
    
    static func formatDateForMyBooking(_ dateString: String) -> String {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        // Try parsing the string
        guard let date = isoFormatter.date(from: dateString) ?? ISO8601DateFormatter().date(from: dateString) else {
            return dateString
        }
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "E dd MM yyyy | hh:mm a"
        
        return formatter.string(from: date)
    }
    
    static func formatStartEndDate(_ apiDate: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        inputFormatter.timeZone = TimeZone(secondsFromGMT: 0) // important for Zulu time (UTC)
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "yyyy-MM-dd"
        outputFormatter.timeZone = TimeZone.current // show in local time
        
        if let date = inputFormatter.date(from: apiDate) {
            return outputFormatter.string(from: date)
        }
        return apiDate
    }
    
    
    static func getDefaultCountryCode() -> String {
        let countryPicker = ADCountryPicker()
        if #available(iOS 16, *) {
            return countryPicker.getDialCode(countryCode: NSLocale.current.region?.identifier ?? "UK") ?? "+44"
        } else {
            return countryPicker.getDialCode(countryCode: NSLocale.current.identifier) ?? "+44"
        }
    }
    /// This function will help developer to get top, bottom and total SafeArea Height
    static func getSafeAreaHeight() -> (top: CGFloat, bottom: CGFloat, total: CGFloat) {
        var window: UIWindow!
        
        if #available(iOS 15, *) {
            guard let firstWindow = UIApplication.shared.connectedScenes.first?.inputView?.window else { return (CGFloat.zero, CGFloat.zero, CGFloat.zero) }
            window = firstWindow
        } else {
            guard let firstWindow = UIApplication.shared.windows.first else { return (CGFloat.zero, CGFloat.zero, CGFloat.zero) }
            window = firstWindow
        }
        
        let topPadding = window.safeAreaInsets.top
        let bottomPadding = window.safeAreaInsets.bottom
        return (topPadding, bottomPadding, topPadding + bottomPadding)
    }
    
    /// This function will help developer to get an image with User's Initials
    static func getImageWithUserInitials(withName name: String?, backgroundColor bgColor: UIColor, textColor txtColor: UIColor, textFont txtFont: UIFont, andSize size: CGFloat) -> UIImage? {
        let frame = CGRect(x: 0.0, y: 0.0, width: size, height: size)
        let nameLabel = UILabel(frame: frame)
        nameLabel.textAlignment = .center
        nameLabel.backgroundColor = bgColor
        nameLabel.textColor = txtColor
        nameLabel.font = txtFont
        var initials = ""
        if let initialsArray = name?.components(separatedBy: " ") {
            if let firstWord = initialsArray.first {
                if let firstLetter = firstWord.first {
                    initials += String(firstLetter).capitalized
                }
            }
            if initialsArray.count > 1, let lastWord = initialsArray.last {
                if let lastLetter = lastWord.first {
                    initials += String(lastLetter).capitalized
                }
            }
        } else if let name = name, name.count > 0 {
            initials = String(name.prefix(1)).capitalized
        } else {
            return nil
        }
        nameLabel.text = initials
        UIGraphicsBeginImageContext(frame.size)
        if let currentContext = UIGraphicsGetCurrentContext() {
            nameLabel.layer.render(in: currentContext)
            let img = UIGraphicsGetImageFromCurrentImageContext()
            return img
        }
        return nil
    }
    static func showHudWithNoInteraction(show: Bool) {
        if show {
            SVProgressHUD.setDefaultMaskType(.clear)
            SVProgressHUD.setDefaultStyle(.custom)
            SVProgressHUD.setForegroundColor(#colorLiteral(red: 0.1176470588, green: 0.2470588235, blue: 0.4235294118, alpha: 1))
            SVProgressHUD.setBackgroundColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0).withAlphaComponent(0))
            //SVProgressHUD.setBackgroundColor(#colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1).withAlphaComponent(1))
            SVProgressHUD.show()
        } else {
            SVProgressHUD.dismiss()
        }
    }
    
//    static func loadHTMLContent(_ content: String, webView: WKWebView) {
//
//        let html = """
//        <html>
//        <head>
//        <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0">
//        <style>
//            body {
//                margin: 0;
//                padding: 0;
//                width: 100%;
//                white-space: pre-wrap;      /* PRESERVE SPACES */
//                word-wrap: break-word;
//                line-height: 1.6;           /* IMPROVE READABILITY */
//                -webkit-text-size-adjust: 120%; /* BOOST FONT SIZE */
//                font-size: 14px;            /* FIX SMALL ARABIC FONT */
//                font-family: -apple-system, BlinkMacSystemFontFont, Arial, sans-serif;
//            }
//
//            img {
//                max-width: 100%;
//                height: auto;
//            }
//
//            table {
//                width: 100% !important;
//            }
//        </style>
//        </head>
//        <body>
//        \(content)
//        </body>
//        </html>
//        """
//
//        webView.loadHTMLString(html, baseURL: nil)
//    }
    
//    static func loadHTMLContent(_ content: String, webView: WKWebView) {
//        
//        // Important: Convert \u2028 (line separator) and other hidden characters if needed
//        let cleanedContent = content
//            .replacingOccurrences(of: "\u{2028}", with: "<br>")   // Line separator → visible break
//            .replacingOccurrences(of: "\u{2029}", with: "<br><br>")
//        
//        let html = """
//        <html>
//        <head>
//            <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
//            <style>
//                body {
//                    margin: 15px;
//                    padding: 0;
//                    width: 100%;
//                    font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Arial, sans-serif;
//                    font-size: 16px;                    /* Better readable size */
//                    line-height: 1.6;
//                    -webkit-text-size-adjust: 100%;
//                    white-space: pre-wrap !important;   /* This is the key */
//                    word-wrap: break-word;
//                    overflow-wrap: break-word;
//                }
//                
//                /* Extra safety for preserving whitespace */
//                p, div, span {
//                    white-space: pre-wrap !important;
//                }
//                
//                img {
//                    max-width: 100%;
//                    height: auto;
//                }
//                
//                table {
//                    width: 100% !important;
//                }
//            </style>
//        </head>
//        <body>
//            \(cleanedContent)
//        </body>
//        </html>
//        """
//        
//        webView.loadHTMLString(html, baseURL: nil)
//    }
    
    static func loadHTMLContent(_ content: String, webView: WKWebView) {
        
        let cleanedContent = content
            .replacingOccurrences(of: "\u{2028}", with: "<br>")
            .replacingOccurrences(of: "\u{2029}", with: "<br><br>")
            .trimmingCharacters(in: .whitespacesAndNewlines) // IMPORTANT: remove leading blank lines
        
        let html = """
        <html>
        <head>
            <meta name="viewport"
                  content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">

            <style>
                body {
                    margin: 0;                           /* remove body margin */
                    padding: 0;
                    font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Arial, sans-serif;
                    font-size: 16px;
                    line-height: 1.6;
                    -webkit-text-size-adjust: 100%;
                    white-space: normal !important;      /* reset body */
                }

                /* Clean paragraphs completely */
                p {
                    margin: 0 !important;
                    padding: 0 !important;
                    white-space: pre-wrap !important;
                }

                div, span {
                    white-space: pre-wrap !important;
                    margin: 0 !important;
                    padding: 0 !important;
                }

                img {
                    max-width: 100%;
                    height: auto;
                }

                table {
                    width: 100% !important;
                }

                /* Add controlled spacing between elements */
                p + p {
                   margin-top: 10px !important;
                }
            </style>
        </head>
        <body>
            <div style="padding: 12px;">\(cleanedContent)</div>
        </body>
        </html>
        """
        
        webView.loadHTMLString(html, baseURL: nil)
    }
    
    
    static func getDateString(from date: Date, format: String = "dd MMM yy") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale.current
        return dateFormatter.string(from: date)
    }
    
    static func getDateStrings(from date: Date?, format: String) -> String {
        guard let date = date else { return "" }
        
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale(identifier: "en_US_POSIX") // ✅ AM / PM uppercase
        return formatter.string(from: date)
    }
    
    
    /// Show Progress Hud
    /// - Parameter show: Boolean value to show/Hide
    static func showHud(show: Bool) {
        if show == true {
            SVProgressHUD.setDefaultMaskType(.none)
            SVProgressHUD.setDefaultStyle(.custom)
            SVProgressHUD.setForegroundColor(UIColor(hexString: "#273470"))
            SVProgressHUD.setBackgroundColor(.white)
            SVProgressHUD.show()
        } else {
            SVProgressHUD.dismiss()
        }
    }
    
    /// Get thumnail from video url
    /// - Parameter url: desired video url
    /// - Parameter completion: if found asset at url then will return uiimage else ll return nil
    static func getThumbnailImage(forUrl url: URL, completion:@escaping(UIImage?)->()) {
        let asset: AVAsset = AVAsset(url: url)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        imageGenerator.appliesPreferredTrackTransform = true
        do {
            let thumbnailImage = try imageGenerator.copyCGImage(at: CMTimeMake(value: 1, timescale: 60) ,
                                                                actualTime: nil)
            completion(UIImage(cgImage: thumbnailImage))
        } catch _ {
            completion(nil)
        }
    }
    
    static func openSetting() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url)
        }
    }
    
    /// String DropDown
    /// - Parameters:
    ///   - dataSource: String array to show list
    ///   - anchorView: view from where it will show listing
    ///   - selectedColor: selected value color
    ///   - completion: Index of selection and value of selection
    static func dropDown(dataSource:[String], anchorView:UIView, selectedColor:UIColor, bgColor:UIColor = .white,
                         completion: @escaping (_ index: Int, _ item: String) -> ()) {
        let dropDown = DropDown()
        dropDown.setupCornerRadius(16)
        dropDown.anchorView = anchorView
        dropDown.dataSource = dataSource
        dropDown.backgroundColor = bgColor
        dropDown.textColor = .black
        dropDown.direction = .any
        dropDown.selectionBackgroundColor = bgColor
        dropDown.selectedTextColor = selectedColor
        dropDown.dismissMode = .automatic
        dropDown.bottomOffset = CGPoint(x: 0, y:((dropDown.anchorView?.plainView.bounds.height)! + 5.0))
        dropDown.topOffset = CGPoint(x: 0, y:-((dropDown.anchorView?.plainView.bounds.height)! + 5.0))
        dropDown.shadowColor = UIColor(hexString: "#273470")
        dropDown.shadowOffset = .zero
        dropDown.shadowRadius = 1.0
        dropDown.shadowOpacity = 1.0
        dropDown.selectionAction = {(index: Int, item: String) in
            completion(index,item)
        }
        dropDown.show()
    }
    
    static func openPicker(controller:UIViewController, callBack:@escaping ((String,String,String) -> Void)) {
        let picker = ADCountryPicker(style: .grouped)
        picker.searchBarBackgroundColor = .white
        picker.showCallingCodes = true
        picker.didSelectCountryWithCallingCodeClosure = { name,code, callingCodes in
            picker.dismiss(animated: true)
            callBack(name,code, callingCodes)
        }
        let pickerNavigationController = UINavigationController(rootViewController: picker)
        controller.present(pickerNavigationController, animated: true, completion: nil)
    }
    
    static func getCode(dialCode:String) -> String {
        guard let path = Bundle.main.path(forResource: "CallingCodes", ofType: "plist") else {return ""}
        let url = URL(fileURLWithPath: path)
        let data = try! Data(contentsOf: url)
        guard let plist = try! PropertyListSerialization.propertyList(from: data, options: .mutableContainers, format: nil) as? [[String:String]] else { return "" }
        let countries = plist.first(where:{$0["dial_code"] ==  dialCode})
        return String.getString(countries?["code"])
    }
    
    static func showToast(message: String) {
        FTIndicator.showNotification(withTitle: Bundle.main.ApplicationName ?? "",
                                     message: message.count>0 ? message: "Message")
        
    }
    
    
    static func showToastForOTP(message: String) {
        let title = Bundle.main.ApplicationName ?? ""
        let displayMessage = message.isEmpty ? "Message" : message
        
        FTIndicator.showNotification(withTitle: title, message: displayMessage)
        
        // ⏳ Keep visible for 4 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
            FTIndicator.dismissNotification()
        }
    }
    static func getCoordinatesFromPlaceID(placeID: String, completion: @escaping (Double, Double) -> Void) {
        let baseURL = "https://maps.googleapis.com/maps/api/place/details/json"
        let parameters = [
            "place_id": placeID,
            "key": "AIzaSyAekJV3oxQlPy_OWHCxPYfFw5CnrD-Wzkg"
        ]
        
        var urlComponents = URLComponents(string: baseURL)
        urlComponents?.queryItems = parameters.map { URLQueryItem(name: $0, value: $1) }
        
        guard let url = urlComponents?.url else {
            UIApplication.shared.topViewController()?.showAlert(msg: AlertConstant.wentWrong.value())
            return
        }
        CommonUtils.showHud(show: true)
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            CommonUtils.showHud(show: false)
            guard let data = data, error == nil else {
                UIApplication.shared.topViewController()?.showAlert(msg: AlertConstant.wentWrong.value())
                return
            }
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                
                if let result = json?["result"] as? [String: Any],
                   let geometry = result["geometry"] as? [String: Any],
                   let location = geometry["location"] as? [String: Any],
                   let latitude = location["lat"] as? Double,
                   let longitude = location["lng"] as? Double {
                    DispatchQueue.main.async {
                        completion(latitude, longitude)
                    }
                } else {
                    UIApplication.shared.topViewController()?.showAlert(msg: AlertConstant.wentWrong.value())
                }
            } catch {
                UIApplication.shared.topViewController()?.showAlert(msg: error.localizedDescription)
            }
        }
        task.resume()
    }
}
