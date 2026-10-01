//
//  ManagePayoutTableViewCell.swift
//  DesynatAdmin
//
//  Created by fluper_mac3 on 19/03/26.
//

import UIKit

class ManagePayoutTableViewCell: UITableViewCell {

    @IBOutlet weak var payoutAmountLabel: CustomLabelFont!
    @IBOutlet weak var payoutDateLabel: CustomLabelFont!
    @IBOutlet weak var transactionIdLabel: CustomLabelFont!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configData(data: PayoutHistory?) {
        payoutAmountLabel.text = CommonUtils.formatPriceStringInput(data?.amount)
        payoutDateLabel.text = formatPayoutDate(data?.payoutDate ?? "")
        transactionIdLabel.text = "#\(data?.transactionID ?? "")"
    }
    
    func formatPayoutDate(_ dateString: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")

        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "dd/MM/yy"
        outputFormatter.locale = Locale(identifier: "en_US_POSIX")

        guard let date = inputFormatter.date(from: dateString) else {
            return dateString
        }

        return outputFormatter.string(from: date)
    }
    
}
