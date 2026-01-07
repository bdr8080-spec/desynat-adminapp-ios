//
//  DealsManagementListTableViewCell.swift
//  DesynatAdmin
//
//  Created by fluper on 07/01/26.
//

import UIKit

class DealsManagementListTableViewCell: UITableViewCell {

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
    
}
