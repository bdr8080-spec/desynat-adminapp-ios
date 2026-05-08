//
//  BrandManagementTableViewCell.swift
//  DesynatAdmin
//
//  Created by Rakhi Kumari on 31/10/25.
//

import UIKit
import SDWebImage

class BrandManagementTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var mainImageView: CustomImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        mainImageView.layer.cornerRadius = 8
        mainImageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        mainImageView.clipsToBounds = true

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func configData(data: GetBrandDataList?) {
        if AppLanguageManager.shared.currentLanguage == .en {
            titleLabel.text = data?.nameEnglish
        }else {
            titleLabel.text = data?.nameArabic
        }
        if let imageUrlString = data?.image,
               let url = URL(string: imageUrlString) {

                mainImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
                mainImageView.sd_imageIndicator?.startAnimatingIndicator()
                mainImageView.sd_setImage(with: url, placeholderImage: UIImage(named: ""))
                
            } else {
                mainImageView.image = UIImage(named: "")
            }
    }
    
}
