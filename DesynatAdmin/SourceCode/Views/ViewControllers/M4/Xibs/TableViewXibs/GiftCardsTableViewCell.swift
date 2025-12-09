//
//  GiftCardsTableViewCell.swift
//  DesynatAdmin
//
//  Created by fluper on 09/12/25.
//

import UIKit
import SDWebImage

class GiftCardsTableViewCell: UITableViewCell {

  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var mainImageView: CustomImageView!
  
  override func awakeFromNib() {
        super.awakeFromNib()
    mainImageView.layer.cornerRadius = 8
    mainImageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
  
  func configData(data: GiftCardsList?) {
    titleLabel.text = data?.nameEnglish
    if let imageUrlString = data?.image,
       let url = URL(string: imageUrlString) {
      mainImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
      mainImageView.sd_imageIndicator?.startAnimatingIndicator()
      mainImageView.sd_setImage(with: url, placeholderImage: UIImage(named: ""))
    }
  }
    
}
