//
//  DealDetailsCollectionViewCell.swift
//  DesynatAdmin
//
//  Created by fluper on 07/01/26.
//

import UIKit

class DealDetailsCollectionViewCell: UICollectionViewCell {

  @IBOutlet weak var discountAmountLabel: UILabel!
  @IBOutlet weak var finalPriceLabel: UILabel!
  @IBOutlet weak var actualPriceLabel: CustomLabelFont!
  @IBOutlet weak var categoryLabel: UILabel!
  @IBOutlet weak var detailLabel: UILabel!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var mainImageView: CustomImageView!
  @IBOutlet weak var statusButtonOutlet: UIButton!
  
  var onStatusToggle: (() -> Void)?
  
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
  
  
  @IBAction func statusToggleDidTapped(_ sender: Any) {
    onStatusToggle?()
  }
  
}
