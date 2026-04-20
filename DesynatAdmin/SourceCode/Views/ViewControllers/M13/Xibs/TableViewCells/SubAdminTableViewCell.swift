//
//  SubAdminTableViewCell.swift
//  DesynatAdmin
//
//  Created by fluper_mac3 on 26/03/26.
//

import UIKit
import SDWebImage

class SubAdminTableViewCell: UITableViewCell {

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var joinedDateLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var userProfileImageView: CustomImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configUserData(data: StaffDetails) {
        usernameLabel.text = data.fullName
        if let imageUrlString = data.profilePic,
           let url = URL(string: imageUrlString) {
            userProfileImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            userProfileImageView.sd_imageIndicator?.startAnimatingIndicator()
            userProfileImageView.sd_setImage(with: url, placeholderImage: .userProfile)
        } else {
            userProfileImageView.image = .userProfile
        }
        let result = convertISOToDMY(data.createdAt ?? "") ?? ""
        joinedDateLabel.text = "Joined on \(result)"
        phoneNumberLabel.text = "\(data.countryCode ?? "")-\(data.mobile ?? "")"
        emailLabel.text = data.email
        countryLabel.text = data.countryInfo?.name
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
