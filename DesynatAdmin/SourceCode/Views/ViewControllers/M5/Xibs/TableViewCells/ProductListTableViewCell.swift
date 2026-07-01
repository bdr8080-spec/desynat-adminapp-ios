//
//  ProductListTableViewCell.swift
//  DesynatAdmin
//
//  Created by fluper on 17/12/25.
//

import UIKit

class ProductListTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var serialNumberLabel: UILabel!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var colourLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var materialLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setData(data: OrderData?) {
        if AppLanguageManager.shared.currentLanguage == .ar {
            nameLabel.text = data?.productDetails?.productNameAr
            materialLabel.text = data?.productDetails?.brand?.nameArabic ?? ""
            sizeLabel.text = data?.variationDetails?.size?.name ?? ""
            colourLabel.text = data?.variationDetails?.color?.nameAr ?? ""
            categoryLabel.text = data?.productDetails?.category?.nameAr ?? ""
        } else {
            nameLabel.text = data?.productDetails?.productNameEn
            materialLabel.text = data?.productDetails?.brand?.nameEnglish ?? ""
            sizeLabel.text = data?.variationDetails?.size?.name ?? ""
            colourLabel.text = data?.variationDetails?.color?.name ?? ""
            categoryLabel.text = data?.productDetails?.category?.name ?? ""
        }
        priceLabel.text = "\(data?.variationDetails?.finalPrice ?? "") KD"
        
        
        
        quantityLabel.text = data?.quantity?.description
        
        productImageView.image = .placeholder
        if let url = URL(string: data?.variationDetails?.variantImage?.first ?? "") {
            productImageView.sd_setImage(with: url,placeholderImage: .placeholder)
        }
    }
}
