//
//  SellerPayoutTableViewCell.swift
//  DesynatAdmin
//
//  Created by fluper_mac3 on 19/03/26.
//

import UIKit
import SDWebImage

class SellerPayoutTableViewCell: UITableViewCell {

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var lastPayoutDateLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var userProfileImageView: CustomImageView!
    @IBOutlet weak var totalEarningLabel: CustomLabelFont!
    @IBOutlet weak var lastPayoutLabel: CustomLabelFont!
    @IBOutlet weak var pendingAmountLabel: CustomLabelFont!
    
    var onManagePayoutTapped: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func managePayoutDidTapped(_ sender: Any) {
        onManagePayoutTapped?()
    }
    
    func configData(data: SellerPayoutListDataList?) {
        usernameLabel.text = data?.sellerName
        countryLabel.text = AppLanguageManager.shared.currentLanguage == .en ? data?.storeInfo?.countryInfo?.name : data?.storeInfo?.countryInfo?.nameAr ?? "Kuwait"
        if let imageUrlString = data?.profilePic,
           let url = URL(string: imageUrlString) {
            userProfileImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            userProfileImageView.sd_imageIndicator?.startAnimatingIndicator()
            userProfileImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "userProfile"))
        } else {
            userProfileImageView.image = UIImage(named: "userProfile")
        }
        let result = convertISOToDMY(data?.createdAt ?? "") ?? ""
        lastPayoutDateLabel.text = "\("Last payout on -".localiz()) \(result)"
        
        totalEarningLabel.text = CommonUtils.formatPriceStringInput(data?.totalEarning)
        lastPayoutLabel.text = CommonUtils.formatPriceStringInput(data?.lastPayout)
        pendingAmountLabel.text = CommonUtils.formatPriceStringInput(data?.pendingAmount)
    }
    
    private func convertISOToDMY(_ isoString: String) -> String? {
        // ISO8601 parser
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        // Parse to Date
        guard let date = isoFormatter.date(from: isoString) else {
            return nil
        }
        
        // Output formatter
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "dd/MM/yyyy"
        
        return outputFormatter.string(from: date)
    }
}
