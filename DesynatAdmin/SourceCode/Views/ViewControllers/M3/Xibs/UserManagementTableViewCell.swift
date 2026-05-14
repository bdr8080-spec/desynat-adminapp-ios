//
//  UserManagementTableViewCell.swift
//  DesynatAdmin
//
//  Created by fluper on 21/11/25.
//

import UIKit
import SDWebImage

class UserManagementTableViewCell: UITableViewCell {
    
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var joinedLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var completedOrderCount: UILabel!
    @IBOutlet weak var cancelOrderCount: UILabel!
    @IBOutlet weak var walletBalanceCount: UILabel!
    @IBOutlet weak var statusButton: UIButton!
    
    var onStatusToggle: (() -> Void)?
    var onViewDetails: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func statusDidTapped(_ sender: Any) {
        onStatusToggle?()
    }
    
    
    @IBAction func viewDetailsDidTapped(_ sender: Any) {
        onViewDetails?()
    }
    
    func configData(data: UsersListModel) {
        usernameLabel.text = data.fullName
        if let imageUrlString = data.profileImage,
           let url = URL(string: imageUrlString) {
            mainImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            mainImageView.sd_imageIndicator?.startAnimatingIndicator()
            mainImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "userProfile"))
        } else {
            mainImageView.image = UIImage(named: "userProfile")
        }
        
        locationLabel.text = AppLanguageManager.shared.currentLanguage == .ar ? data.countryInfo?.nameAr : data.countryInfo?.name
        let result = convertISOToDMY(data.createdAt ?? "") ?? ""
        joinedLabel.text = "\("Joined on".localiz()) \(result)"
        phoneLabel.text = "\(data.countryCode ?? "")-\(data.mobile ?? "")"
        emailLabel.text = data.email
        //    walletBalanceCount.text = "\(data.walletInfo?.amount ?? "") KD"
        let amountString = data.walletInfo?.amount ?? ""
        let amountValue = Double(amountString) ?? 0
        
        // Format without decimals
        let formattedAmount = String(format: "%.0f", amountValue)
        
        walletBalanceCount.text = "\(formattedAmount) KD"
        //    completedOrderCount.text = data.
        if data.status == "1" {
            statusButton.setImage(UIImage(named: "toggleOn"), for: .normal)
        } else {
            statusButton.setImage(UIImage(named: "toggleOff"), for: .normal)
        }
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
