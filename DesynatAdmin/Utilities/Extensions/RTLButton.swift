//
//  RTLButton.swift
//  DesynatAdmin
//
//  Created by fluper_mac2 on 01/05/26.
//

import UIKit


class RTLButton: UIButton {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        applyRTL()
    }
    
    private func applyRTL() {
        if AppLanguageManager.shared.isRightToLeft {
            self.semanticContentAttribute = .forceRightToLeft
            self.imageView?.transform = CGAffineTransform(scaleX: -1, y: 1)
        } else {
            self.semanticContentAttribute = .forceLeftToRight
            self.imageView?.transform = .identity
        }
    }
}
