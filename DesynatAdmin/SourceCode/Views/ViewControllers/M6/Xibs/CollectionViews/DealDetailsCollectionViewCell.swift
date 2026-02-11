//
//  DealDetailsCollectionViewCell.swift
//  DesynatAdmin
//
//  Created by fluper on 07/01/26.
//

import UIKit
import SDWebImage

class DealDetailsCollectionViewCell: UICollectionViewCell {

  @IBOutlet weak var discountAmountLabel: UILabel!
  @IBOutlet weak var finalPriceLabel: UILabel!
  @IBOutlet weak var actualPriceLabel: CustomLabelFont!
  @IBOutlet weak var categoryLabel: UILabel!
  @IBOutlet weak var detailLabel: UILabel!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var mainImageView: CustomImageView!
  @IBOutlet weak var statusButtonOutlet: UIButton!
  
  var onStatusToggle: (() -> Void)?
  
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
  
  
  @IBAction func statusToggleDidTapped(_ sender: Any) {
    onStatusToggle?()
  }
    
    func configDealData(data: Product?, categoryName: String, subCategoryName: String) {
        if let imageUrlString = data?.productDetails?.productVariants?.first?.variantImage?.first,
           let url = URL(string: imageUrlString) {
            mainImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            mainImageView.sd_imageIndicator?.startAnimatingIndicator()
            mainImageView.sd_setImage(with: url, placeholderImage: UIImage(named: ""))
        } else {
            mainImageView.image = UIImage(named: "")
        }
        let brand = data?.productDetails?.brand?.nameEnglish ?? ""
        if !brand.isEmpty {
            titleLabel.text =  brand
        } else {
            titleLabel.text =  data?.productDetails?.otherEn ?? ""
        }
        
        detailLabel.text = data?.productDetails?.productNameEn ?? ""
        categoryLabel.text = "\(categoryName) (\(subCategoryName))"
        
        finalPriceLabel.text = "\(data?.productDetails?.productVariants?.first?.finalPrice ?? "") KD"
        
        CommonUtils.setStrikethrough(label: actualPriceLabel, text: "\(data?.productDetails?.productVariants?.first?.actualPrice ?? "") KD")
        //    iscountPriceLabel.text = "\(data?.productVariants?.first?.discountValue ?? "") KD"
//        let discountType = data?.productDetails?.productVariants?.first?.discountType ?? "1"
//        if discountType == "1" {
//            discountAmountLabel.text = "\(data?.productDetails?.productVariants?.first?.discountValue ?? "")% Off"
//        } else {
//            discountAmountLabel.text = "\(data?.productDetails?.productVariants?.first?.discountValue ?? "") KD Off"
//        }
        
        CommonUtils.updateDiscountPercentageLabel(discountAmountLabel,
                                                  actualAmountLabel: actualPriceLabel,
                                                  discountType: data?.productDetails?.productVariants?.first?.discountType,
                                                  discountValue: data?.productDetails?.productVariants?.first?.discountValue)
        
        if data?.productDetails?.productActiveStatus == 1 {
            statusButtonOutlet.setImage(UIImage(named: "toggleOn"), for: .normal)
        } else {
            statusButtonOutlet.setImage(UIImage(named: "toggleOff"), for: .normal)
        }
    }
  
}
