//
//  AffiliatedCommissionTableViewCell.swift
//  DesynatAdmin
//
//  Created by fluper on 16/12/25.
//

import UIKit

class AffiliatedCommissionTableViewCell: UITableViewCell {

  @IBOutlet weak var flagEmojLabel: UILabel!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var commissionLabel: UILabel!
  
  var onEditTap: (() -> Void)?
  
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
  @IBAction func editDidTapped(_ sender: Any) {
    onEditTap?()
  }
}
