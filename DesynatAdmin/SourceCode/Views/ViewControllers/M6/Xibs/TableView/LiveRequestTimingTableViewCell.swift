//
//  LiveRequestTimingTableViewCell.swift
//  DesynatAdmin
//
//  Created by fluper on 07/01/26.
//

import UIKit

class LiveRequestTimingTableViewCell: UITableViewCell {

  var onAcceptTap: (()-> Void)?
  var onRejectTap: (()-> Void)?
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
  
  @IBAction func acceptDidTapepd(_ sender: Any) {
    onAcceptTap?()
  }
  
  @IBAction func rejectDidTapped(_ sender: Any) {
    onRejectTap?()
  }
    
}
