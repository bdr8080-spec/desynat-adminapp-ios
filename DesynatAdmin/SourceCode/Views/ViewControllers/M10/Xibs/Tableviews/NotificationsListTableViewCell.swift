//
//  NotificationsListTableViewCell.swift
//  DesynatAdmin
//
//  Created by Geetam   on 09/03/26.
//

import UIKit

class NotificationsListTableViewCell: UITableViewCell {

    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var sentToNameLabel: UILabel!
    @IBOutlet weak var sentTimeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configData(data: NotificationsList?) {
        titleLabel.text = data?.titleEnglish
        descriptionLabel.text = data?.descriptionEnglish
        if let receivers = data?.receiverDetails, !receivers.isEmpty {
            let firstName = receivers.first?.fullName ?? receivers.first?.fullNameEnglish ?? ""
            let remainingCount = receivers.count - 1
            if remainingCount > 0 {
                sentToNameLabel.text = "Sent To - \(firstName) + \(remainingCount)"
            } else {
                sentToNameLabel.text = "Sent To - \(firstName)"
            }
        } else {
            sentToNameLabel.text = "Sent To -"
        }
        if data?.isRead == 1 {
            mainImageView.image = .selectedBellIcon
        } else {
            mainImageView.image = .unselectedBellIcon
        }
        sentTimeLabel.text = formatISODateToDayMonthYear(data?.createdAt ?? "")
    }
    
    private func formatISODateToDayMonthYear(_ isoDateString: String) -> String {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        guard let date = isoFormatter.date(from: isoDateString) else {
            return ""
        }
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "dd/MM/yyyy"
        outputFormatter.locale = Locale(identifier: "en_US_POSIX")
        return outputFormatter.string(from: date)
    }
    
}
