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
  
//  var fullData: GetPromoCodeListDataModel?
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
  }
  
  func configureData(data: PromocodeList) {
    titleLabel.text = data.nameEnglish
    deiscountLabel.text = "Flat \(data.discountPercent ?? "")% Off On minimum order \(data.minOrderValue ?? "")"
    descriptionLabel.text = data.descriptionEnglish ?? ""
  }
  
}
