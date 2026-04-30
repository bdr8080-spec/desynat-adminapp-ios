//
//  CategoryTableViewCell.swift
//  DesynatAdmin
//
//  Created by Rakhi Kumari on 31/10/25.
//

import UIKit
import SDWebImage

class CategoryTableViewCell: UITableViewCell {

    @IBOutlet weak var statusImageView: UIImageView!
    @IBOutlet weak var mainContentView: CustomView!
    @IBOutlet weak var rightImageView: CustomImageView!
    @IBOutlet weak var leftImageView: CustomImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var statusButton: UIButton!
    
    var onStatusToggle: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func statusButtonTapped(_ sender: UIButton) {
            onStatusToggle?()
        }
    
    func configData(data: GetCategoryModel) {
        titleLabel.text = data.name
        descriptionLabel.text = data.description
        if let imageUrlString = data.image,
               let url = URL(string: imageUrlString) {

            leftImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            leftImageView.sd_imageIndicator?.startAnimatingIndicator()
            leftImageView.sd_setImage(with: url, placeholderImage: UIImage(named: ""))
            
            rightImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            rightImageView.sd_imageIndicator?.startAnimatingIndicator()
            rightImageView.sd_setImage(with: url, placeholderImage: UIImage(named: ""))
            } else {
                leftImageView.image = UIImage(named: "")
                rightImageView.image = UIImage(named: "")
            }
        
        if data.status == 1 {
            statusLabel.text = "Active".localiz()
            statusImageView.image = UIImage(named: "toggleOn")
        } else {
            statusLabel.text = "Inactive".localiz()
            statusImageView.image = UIImage(named: "toggleOff")
        }
        
        mainContentView.backgroundColor = UIColor(hexString: data.colorCode ?? "")
        
    }
    
}
