//
//  AffiliatedUsersListTableViewCell.swift
//  DesynatAdmin
//
//  Created by fluper on 20/01/26.
//

import UIKit
import SDWebImage

class AffiliatedUsersListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var newStackView: UIStackView!
    @IBOutlet weak var approvedStackView: UIStackView!
    @IBOutlet weak var rejectedStackView: UIStackView!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var mobileLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var joinedDateLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var totalOrdersLabek: UILabel!
    @IBOutlet weak var totalEarningsLabel: UILabel!
    @IBOutlet weak var reasonLabel: UILabel!
    
    var onRejectAction: (() -> Void)?
    var onAcceptAction: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func rejectDidTapped(_ sender: Any) {
        onRejectAction?()
    }
    
    @IBAction func acceptDidTapped(_ sender: Any) {
        onAcceptAction?()
    }
    
    func configData(userType: AffiliatedUsersListType, data: AffilitaitedUsersDataModel, hasActionPermission: Bool) {
        newStackView.isHidden = true
        approvedStackView.isHidden = true
        rejectedStackView.isHidden = true
        switch userType {
        case .newUsers:
            newStackView.isHidden = !hasActionPermission
        case .approvedUsers:
            approvedStackView.isHidden = false
        case .rejectedUsers:
            rejectedStackView.isHidden = false
        }
        configUserData(data: data)
    }
    
    func configUserData(data: AffilitaitedUsersDataModel) {
        usernameLabel.text = data.fullName
        if let imageUrlString = data.profileImage,
           let url = URL(string: imageUrlString) {
            mainImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            mainImageView.sd_imageIndicator?.startAnimatingIndicator()
            mainImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "userProfile"))
        } else {
            mainImageView.image = UIImage(named: "userProfile")
        }
        let result = convertISOToDMY(data.createdAt ?? "") ?? ""
        joinedDateLabel.text = "\("Joined on".localiz()) \(result)"
        mobileLabel.text = "\(data.countryCode ?? "")-\(data.mobile ?? "")"
        emailLabel.text = data.email
        //        totalOrdersLabek.text = data.or
        //        totalEarningsLabel.text = data.ea
        reasonLabel.text = data.rejectReason
        if AppLanguageManager.shared.currentLanguage == .ar {
            countryLabel.text = data.countryDetails?.nameAr
        }else {
            countryLabel.text = data.countryDetails?.name
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
