//
//  DealsManagementListTableViewCell.swift
//  DesynatAdmin
//
//  Created by fluper on 07/01/26.
//

import UIKit
import SDWebImage

class DealsManagementListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var mainImageView: CustomImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var discountLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var totalSellerLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        mainImageView.layer.cornerRadius = 8
        mainImageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configData(data: DealListManagementList?) {
        titleLabel.text = data?.nameEnglish
        if let imageUrlString = data?.image,
           let url = URL(string: imageUrlString) {
            mainImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            mainImageView.sd_imageIndicator?.startAnimatingIndicator()
            mainImageView.sd_setImage(with: url, placeholderImage: UIImage(named: ""))
        } else {
            mainImageView.image = UIImage(named: "")
        }
        discountLabel.text = "\(CommonUtils.formatPriceStringInput(data?.discount, currency: "%"))"
        let startDate = convertDateFormat(data?.from ?? "") ?? ""
        let endDate = convertDateFormat(data?.to ?? "") ?? ""
        dateLabel.text = "\(startDate) - \(endDate)"
        let count = data?.sellerEnrolled?.sellerCount ?? 0
        totalSellerLabel.text = "\(count) " + (count == 1 ? "Seller".localiz() : "Sellers".localiz())
    }
    
    func convertDateFormat(
        _ dateString: String,
        from inputFormat: String = "yyyy-MM-dd",
        to outputFormat: String = "dd/MM/yyyy"
    ) -> String? {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = inputFormat
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        guard let date = inputFormatter.date(from: dateString) else {
            return nil
        }
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = outputFormat
        outputFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        return outputFormatter.string(from: date)
    }
    
}
