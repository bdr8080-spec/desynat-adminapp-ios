//
//  CustomTextfiled.swift
//  PerSquareFeetDealerApp
//
//  Created by Riya on 30/06/25.
//

import UIKit

@IBDesignable
class CustomTextfieldFont: UITextField {
    
    /// Set this in storyboard: "mon", "alt", "a", "Poppins", "alternates"
    @IBInspectable var fontFamilyName: String = "" {
        didSet {
            updateFontFamily(from: fontFamilyName)
        }
    }

    private var fontFamily: FontFamily = .Poppins {
        didSet {
            applyCustomFont()
        }
    }

    enum FontFamily {
        case Poppins
        case PoppinsAlternates

        static func from(input: String) -> FontFamily {
            let normalized = input.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
            switch normalized {
            case "alt", "a", "alternates", "Poppinsalternates":
                return .PoppinsAlternates
            default:
                return .Poppins
            }
        }

        func fontName(for weight: UIFont.Weight) -> String {
            switch self {
            case .Poppins:
                switch weight {
                case .medium: return "Poppins-Medium"
                case .semibold: return "Poppins-SemiBold"
                case .bold: return "Poppins-Bold"
                default: return "Poppins-Regular"
                }
            case .PoppinsAlternates:
                switch weight {
                case .medium: return "PoppinsAlternates-Medium"
                case .semibold: return "PoppinsAlternates-SemiBold"
                case .bold: return "PoppinsAlternates-Bold"
                default: return "PoppinsAlternates-Regular"
                }
            }
        }
    }

    // MARK: Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        updateFontFamily(from: fontFamilyName)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        updateFontFamily(from: fontFamilyName)
    }

    override var font: UIFont! {
        didSet {
            applyCustomFont()
        }
    }

    private func updateFontFamily(from name: String) {
        fontFamily = FontFamily.from(input: name)
        //print("✅ Font family selected: \(fontFamily)")
    }

    private func applyCustomFont() {
        let pointSize = font?.pointSize ?? UIFont.labelFontSize
        let weight = font.weight
        let fontName = fontFamily.fontName(for: weight)

        if let customFont = UIFont(name: fontName, size: pointSize) {
            super.font = customFont
        } else {
            //print("⚠️ Font '\(fontName)' not found. Did you add it to the project and Info.plist?")
        }
    }
}
