//
//  LiveRequestTimingTableViewCell.swift
//  DesynatAdmin
//
//  Created by fluper on 07/01/26.
//

import UIKit

class LiveRequestTimingTableViewCell: UITableViewCell {
  
    @IBOutlet weak var rejectedDate: UIStackView!
    @IBOutlet weak var rejectedOnDateLabel: UILabel!
    @IBOutlet weak var separatorLabel: UILabel!
  @IBOutlet weak var reasonLabel: UILabel!
  @IBOutlet weak var reasonStackView: UIStackView!
  @IBOutlet weak var paymentStackView: UIStackView!
  @IBOutlet weak var paymentModelabel: UILabel!
  @IBOutlet weak var buttonStackView: UIStackView!
  @IBOutlet weak var acceptView: UIView!
  @IBOutlet weak var rejectView: UIView!
  @IBOutlet weak var usernameCountryLabe: UILabel!
  @IBOutlet weak var statusLabel: UILabel!
  @IBOutlet weak var liveRequestLabel: UILabel!
  @IBOutlet weak var requestOnLabel: UILabel!
  @IBOutlet weak var requestIdLabel: UILabel!
  
  var onAcceptTap: (()-> Void)?
  var onRejectTap: (()-> Void)?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  @IBAction func acceptDidTapepd(_ sender: Any) {
    onAcceptTap?()
  }
  
  @IBAction func rejectDidTapped(_ sender: Any) {
    onRejectTap?()
  }
  
  func configData(data: LiveRequestPermissionList?) {
    let first = data?.sellerDetails?.firstName ?? ""
    let last = data?.sellerDetails?.lastName ?? ""
    let country = data?.sellerDetails?.storeInfo?.countryInfo?.name ?? ""//data?.sellerDetails?.countryDetails?.name ?? ""
    usernameCountryLabe.text = "\(first) \(last) | \(country)"
    requestIdLabel.text = "#\(data?.timeslotID ?? 0)"
    requestOnLabel.text = formatISODateToDayMonthYear(data?.createdAt ?? "")
    let date = convertDateFormat(data?.timeslotDetails?.date ?? "") ?? ""
    liveRequestLabel.text = "\(date)|\(data?.timeslotDetails?.from ?? "")"
      rejectedOnDateLabel.text = formatISODateToDayMonthYear(data?.updatedAt ?? "")
    reasonLabel.text = data?.rejectReason
    let status = data?.adminVerify ?? 0
      paymentStackView.isHidden = true
      rejectedDate.isHidden = true
    switch status {
    case 1:
//      statusLabel.text = "Confirmed"
      statusLabel.textColor = UIColor(hexString: "#17854C") // green
      separatorLabel.isHidden = true
      reasonStackView.isHidden = true
        
        var isTimeslotOver = false

        if let timeslot = data?.timeslotDetails,
           let timeslotDate = timeslot.date,
           let toTime = timeslot.to {

            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd hh:mm a"   // ✅ FIXED
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")

            if let endDate = dateFormatter.date(from: "\(timeslotDate) \(toTime)") {
                let now = Date()
                if now >= endDate {
                    isTimeslotOver = true
                }
            }
        }

        // Update status
        statusLabel.text = isTimeslotOver ? "Completed" : "Confirmed"
        
    case 2:
      statusLabel.text = "Rejected"
      statusLabel.textColor = UIColor(hexString: "#D91A1B") // red
      separatorLabel.isHidden = false
      reasonStackView.isHidden = false
        rejectedDate.isHidden = false
    default:
      statusLabel.text = "Pending"
      statusLabel.textColor = UIColor(hexString: "#FFA41B") // orange
      separatorLabel.isHidden = false
      reasonStackView.isHidden = true
    }
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
  
  func formatISODateToDayMonthYear(_ isoDateString: String) -> String {
    let isoFormatter = ISO8601DateFormatter()
    isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
    
    guard let date = isoFormatter.date(from: isoDateString) else {
      return ""
    }
    
    let outputFormatter = DateFormatter()
    outputFormatter.dateFormat = "dd/MM/yyyy|hh:mm a"
    outputFormatter.locale = Locale(identifier: "en_US_POSIX")
    
    return outputFormatter.string(from: date)
  }
  
}


