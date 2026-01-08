//
//  FullScreenBannerTableViewCell.swift
//  DesynatAdmin
//
//  Created by fluper on 08/01/26.
//

import UIKit
import SDWebImage

class FullScreenBannerTableViewCell: UITableViewCell {
  
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
