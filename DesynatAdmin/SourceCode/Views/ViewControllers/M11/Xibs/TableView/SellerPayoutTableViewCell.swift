//
//  SellerPayoutTableViewCell.swift
//  DesynatAdmin
//
//  Created by fluper_mac3 on 19/03/26.
//

import UIKit

class SellerPayoutTableViewCell: UITableViewCell {

    var onManagePayoutTapped: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func managePayoutDidTapped(_ sender: Any) {
        onManagePayoutTapped?()
    }
}
