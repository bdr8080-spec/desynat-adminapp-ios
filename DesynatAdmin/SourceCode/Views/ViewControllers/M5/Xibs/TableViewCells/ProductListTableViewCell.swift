//
//  ProductListTableViewCell.swift
//  DesynatAdmin
//
//  Created by fluper on 17/12/25.
//

import UIKit

class ProductListTableViewCell: UITableViewCell {
  
  @IBOutlet weak var serialNumberLabel: UILabel!
  @IBOutlet weak var productImageView: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var priceLabel: UILabel!
  @IBOutlet weak var sizeLabel: UILabel!
  @IBOutlet weak var colourLabel: UILabel!
  @IBOutlet weak var categoryLabel: UILabel!
  @IBOutlet weak var quantityLabel: UILabel!
  @IBOutlet weak var materialLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
}
