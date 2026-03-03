//
//  PromoCodeTableViewCell.swift
//  DesynatUser
//
//  Created by fluper on 03/12/25.
//

import UIKit

class PromoCodeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var deiscountLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    func configureData(data: PromocodeList) {
        titleLabel.text = "Flat \(data.discountPercent ?? "")% OFF" //data.nameEnglish
        deiscountLabel.text = "Flat \(data.discountPercent ?? "")% Off On minimum order \(data.minOrderValue ?? "")"
        descriptionLabel.text = data.descriptionEnglish ?? ""
    }
    
}
