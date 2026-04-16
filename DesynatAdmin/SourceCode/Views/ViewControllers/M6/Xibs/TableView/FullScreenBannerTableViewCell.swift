//
//  FullScreenBannerTableViewCell.swift
//  DesynatAdmin
//
//  Created by fluper on 08/01/26.
//

import UIKit
import SDWebImage

class FullScreenBannerTableViewCell: UITableViewCell {
    
    @IBOutlet weak var positionTitleLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var countrystackView: UIStackView!
    @IBOutlet weak var titleStackView: UIStackView!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var mainImageView: CustomImageView!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!
    
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
    
    func configData(data: FullScreenBannerDataList?) {
        titleStackView.isHidden = false
        titleLabel.text = data?.title
        if let imageUrlString = data?.image,
           let url = URL(string: imageUrlString) {
            mainImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            mainImageView.sd_imageIndicator?.startAnimatingIndicator()
            mainImageView.sd_setImage(with: url, placeholderImage: UIImage(named: ""))
        } else {
            mainImageView.image = UIImage(named: "")
        }
        countryLabel.text = data?.countryInfo?.name
        if let startDate = convertDateFormat(data?.startDate ?? "") {
            startDateLabel.text = startDate
        }
        
        endDateLabel.text = convertDateFormat(data?.endDate ?? "")
        if data?.type == "1" {
            typeLabel.text = "App Banner"
        } else {
            typeLabel.text = "Web Banner"
        }
        positionTitleLabel.text = "Type"
    }
    
    func configDataForPromotionalBanner(data: GetPromotionalBannersList?) {
        titleStackView.isHidden = true
        if let imageUrlString = data?.uploadBanner,
           let url = URL(string: imageUrlString) {
            mainImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            mainImageView.sd_imageIndicator?.startAnimatingIndicator()
            mainImageView.sd_setImage(with: url, placeholderImage: UIImage(named: ""))
        } else {
            mainImageView.image = UIImage(named: "")
        }
        if let startDate = convertDateFormat(data?.startDate ?? "") {
            startDateLabel.text = startDate
        }
        countryLabel.text = data?.countryInfo?.name
        endDateLabel.text = convertDateFormat(data?.endDate ?? "")
        if data?.bannerPosition == "1" {
            typeLabel.text = "Home Top"
        } else if data?.bannerPosition == "2" {
            typeLabel.text = "Home Bottom"
        } else {
            typeLabel.text = "Category"
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        
        let today = Calendar.current.startOfDay(for: Date())
        
        if data?.status == "1" {
            if let startDateStr = data?.startDate,
               let endDateStr = data?.endDate,
               let startDate = formatter.date(from: startDateStr),
               let endDate = formatter.date(from: endDateStr) {
                
                let start = Calendar.current.startOfDay(for: startDate)
                let end = Calendar.current.startOfDay(for: endDate)
                
                if today < start {
                    statusLabel.text = "Upcoming"
                    statusLabel.textColor = .black
                } else if today > end {
                    statusLabel.text = "Inactive"
                    statusLabel.textColor = UIColor(hexString: "#68CA44")
                } else {
                    statusLabel.text = "Active"
                    statusLabel.textColor = UIColor(hexString: "#68CA44")
                }
            } else {
                statusLabel.text = "Upcoming"
                statusLabel.textColor = .black
            }
        } else {
            statusLabel.text = "Inactive"
            statusLabel.textColor = UIColor(hexString: "#68CA44")
        }
        positionTitleLabel.text = "Position"
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
    
    func categorizeDeal(from fromDateString: String,
                        to toDateString: String) -> BannerStatus? {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone.current
        
        guard let fromDate = formatter.date(from: fromDateString),
              let toDate = formatter.date(from: toDateString) else {
            return nil
        }
        
        let calendar = Calendar.current
        let now = Date()
        
        let startOfFromDate = calendar.startOfDay(for: fromDate)
        
        // End of "to" day → 23:59:59
        let endOfToDate = calendar.date(
            bySettingHour: 23,
            minute: 59,
            second: 59,
            of: toDate
        )!
        
        if now < startOfFromDate {
            return .upcoming
        }
        
        if now <= endOfToDate {
            return .active
        }
        
        // Expired
        return .expired
    }
    
    
}

enum BannerStatus {
    case upcoming
    case active
    case expired
}


