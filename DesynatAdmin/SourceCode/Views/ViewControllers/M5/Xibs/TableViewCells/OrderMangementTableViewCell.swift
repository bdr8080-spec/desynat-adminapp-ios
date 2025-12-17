//
//  OrderMangementTableViewCell.swift
//  DesynatAdmin
//
//  Created by fluper on 17/12/25.
//

import UIKit

class OrderMangementTableViewCell: UITableViewCell {

  @IBOutlet weak var assignDriverStackView: UIStackView!
  @IBOutlet weak var assignDriverView: UIView!
  
  var assignDriverTapped: (() -> Void)?
  
  override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
  @IBAction func assignDriverDidTapped(_ sender: Any) {
    assignDriverTapped?()
  }
}
