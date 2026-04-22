//
//  SideMenuTableViewCell.swift
//  DesynatAdmin
//
//  Created by Rakhi Kumari on 31/10/25.
//

import UIKit
import SDWebImage

class SideMenuTableViewCell: UITableViewCell {

    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configData(data: SideMenuModel) {
        titleLabel.text = data.title
        mainImageView.image = UIImage(named: data.image)
    }
    
    func configDataForSubAdmin(data: PermissionDetail?) {
        if let imageUrlString = data?.moduleDetails?.icon,
           let url = URL(string: imageUrlString) {
            mainImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            mainImageView.sd_imageIndicator?.startAnimatingIndicator()
            mainImageView.sd_setImage(with: url, placeholderImage: .userManagemnet)
        } else {
            mainImageView.image = .userManagemnet
        }
        titleLabel.text = data?.moduleDetails?.displayName
    }
    
}


