//
//  GradientColour.swift
//  DesynatAdmin
//
//  Created by Rakhi on 17/12/25.
//

import UIKit

private enum GoldGradientColors {
    static let top = UIColor(hexString: "#DFBF8F")
    static let bottom = UIColor(hexString: "#6E4527")
}

enum GradientDirectionType: Int {
    case topToBottom = 0
    case leftToRight = 1
    case topLeftToBottomRight = 2
    case bottomLeftToTopRight = 3

    var points: (start: CGPoint, end: CGPoint) {
        switch self {
        case .topToBottom:
            return (CGPoint(x: 0.5, y: 0.0), CGPoint(x: 0.5, y: 1.0))
        case .leftToRight:
            return (CGPoint(x: 0.0, y: 0.5), CGPoint(x: 1.0, y: 0.5))
        case .topLeftToBottomRight:
            return (CGPoint(x: 0.0, y: 0.0), CGPoint(x: 1.0, y: 1.0))
        case .bottomLeftToTopRight:
            return (CGPoint(x: 0.0, y: 1.0), CGPoint(x: 1.0, y: 0.0))
        }
    }
}

@IBDesignable
class GoldGradientView: UIView {

    /// 0: TopToBottom, 1: LeftToRight, 2: Diagonal, 3: ReverseDiagonal
    @IBInspectable var direction: Int = 0 {
        didSet { updateGradient() }
    }

    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = true
        }
    }

    private let gradientLayer = CAGradientLayer()

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
        updateGradient()
    }

    private func updateGradient() {
        if gradientLayer.superlayer == nil {
            layer.insertSublayer(gradientLayer, at: 0)
        }

        gradientLayer.colors = [
            GoldGradientColors.top.cgColor,
            GoldGradientColors.bottom.cgColor
        ]

        let type = GradientDirectionType(rawValue: direction) ?? .topToBottom
        gradientLayer.startPoint = type.points.start
        gradientLayer.endPoint = type.points.end

        gradientLayer.cornerRadius = cornerRadius
    }
}

@IBDesignable
class GoldGradientBorderView: UIView {

    /// 0: TopToBottom, 1: LeftToRight, 2: Diagonal, 3: ReverseDiagonal
    @IBInspectable var direction: Int = 0 {
        didSet { updateBorder() }
    }

    @IBInspectable var borderWidth: CGFloat = 2 {
        didSet { updateBorder() }
    }

    @IBInspectable var cornerRadius: CGFloat = 12 {
        didSet { updateBorder() }
    }

    private let gradientLayer = CAGradientLayer()
    private let shapeLayer = CAShapeLayer()

    override func layoutSubviews() {
        super.layoutSubviews()
        updateBorder()
    }

    private func updateBorder() {
        gradientLayer.frame = bounds
        gradientLayer.colors = [
            GoldGradientColors.top.cgColor,
            GoldGradientColors.bottom.cgColor
        ]

        let type = GradientDirectionType(rawValue: direction) ?? .topToBottom
        gradientLayer.startPoint = type.points.start
        gradientLayer.endPoint = type.points.end

        shapeLayer.path = UIBezierPath(
            roundedRect: bounds,
            cornerRadius: cornerRadius
        ).cgPath
        shapeLayer.lineWidth = borderWidth
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.black.cgColor

        gradientLayer.mask = shapeLayer

        if gradientLayer.superlayer == nil {
            layer.addSublayer(gradientLayer)
        }
    }
}
extension UIColor {
    convenience init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0

        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else { return nil }

        let r, g, b, a: CGFloat
        let length = hexSanitized.count

        if length == 6 {
            r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
            g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
            b = CGFloat(rgb & 0x0000FF) / 255.0
            a = 1.0
        } else if length == 8 {
            r = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
            g = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
            b = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
            a = CGFloat(rgb & 0x000000FF) / 255.0
        } else {
            return nil
        }

        self.init(red: r, green: g, blue: b, alpha: a)
    }
}
