//
//  SubCategoryCollectionViewCell.swift
//  DesynatAdmin
//
//  Created by Rakhi Kumari on 31/10/25.
//

import UIKit
import SDWebImage

class SubCategoryCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configData(data: GetSubCategoryDataList) {
        titleLabel.text = data.nameEnglish
        if let imageUrlString = data.image,
               let url = URL(string: imageUrlString) {

            mainImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            mainImageView.sd_imageIndicator?.startAnimatingIndicator()
            mainImageView.sd_setImage(with: url, placeholderImage: UIImage(named: ""))
            } else {
                mainImageView.image = UIImage(named: "")
            }
        
    }

}
