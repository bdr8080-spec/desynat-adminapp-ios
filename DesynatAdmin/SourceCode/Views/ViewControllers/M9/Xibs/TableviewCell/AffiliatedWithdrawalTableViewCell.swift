//
//  AffiliatedWithdrawalTableViewCell.swift
//  DesynatAdmin
//
//  Created by fluper_mac3 on 25/02/26.
//

import UIKit

class AffiliatedWithdrawalTableViewCell: UITableViewCell {

    @IBOutlet weak var statusLabel: CustomLabelFont!
    @IBOutlet weak var actionStackView: UIStackView!
    @IBOutlet weak var statusView: UIStackView!
    
    var onRejectTap: (() -> Void)?
    var onAcceptTap: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    @IBAction func rejectDidTapped(_ sender: Any) {
        onRejectTap?()
    }
    
    @IBAction func acceptDidTapped(_ sender: Any) {
        onAcceptTap?()
    }
    
    func configData(requestType: AffiliatedWithdrawalListType) {
        actionStackView.isHidden = true
        statusView.isHidden = true
//        self.lblDateTime.text = CommonUtils.getDateStrings(
//            from: Date(iso8601String: String.getString(self.viewModel.orderDetail?.createdAt)),
//            format: "dd/MM/yyyy 'at' hh:mm a"
//        )
        switch requestType {
        case .newRequest:
            actionStackView.isHidden = false
        case .approvedRequest:
            statusView.isHidden = false
            statusLabel.text = "Completed"
            statusLabel.textColor = UIColor(hexString: "#17854C")
        case .rejectedRequest:
            statusView.isHidden = false
            statusLabel.text = "Rejected"
            statusLabel.textColor = UIColor(hexString: "#D53B36")
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
        let outputFormatter = DateFormatter() //21/04/2024 at 07:30 PM
        outputFormatter.dateFormat = "dd/MM/yyyy at hh:mm a" //"dd/MM/yyyy 'at' hh:mm a"
        return outputFormatter.string(from: date)
    }
    
}
