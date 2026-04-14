//
//  DropDownCheckboxCell.swift
//  DesynatAdmin
//
//  Created by fluper_mac3 on 03/02/26.
//

import UIKit
import DropDown

class DropDownCheckboxCell: DropDownCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var checkboxImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
