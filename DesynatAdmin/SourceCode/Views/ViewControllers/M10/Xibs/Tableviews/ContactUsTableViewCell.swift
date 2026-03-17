//
//  ContactUsTableViewCell.swift
//  DesynatAdmin
//
//  Created by fluper_mac3 on 16/03/26.
//

import UIKit

class ContactUsTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var supporttypeImageView: UIImageView!
    
    var onEditAction: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func editDidTapped(_ sender: Any) {
        onEditAction?()
    }

}
