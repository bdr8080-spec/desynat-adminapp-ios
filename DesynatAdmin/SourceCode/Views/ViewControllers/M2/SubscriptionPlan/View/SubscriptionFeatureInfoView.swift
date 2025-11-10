//
//  SubscriptionFeatureInfo.swift
//  DesynatAdmin
//
//  Created by Meet Goti on 10/11/25.
//

import UIKit

class SubscriptionFeatureInfoView: UIView {

    @IBOutlet weak var lblTitle: CustomLabelFont!
    
    func setTitle(_ string:NSAttributedString) {
        self.lblTitle.attributedText = string
    }
}
