//
//  AffiliatedWithdrawalTableViewCell.swift
//  DesynatAdmin
//
//  Created by fluper_mac3 on 25/02/26.
//

import UIKit

class AffiliatedWithdrawalTableViewCell: UITableViewCell {

    @IBOutlet weak var transactionLabel: CustomLabelFont!
    @IBOutlet weak var transactionSackView: UIStackView!
    @IBOutlet weak var rejectedReasonLabel: CustomLabelFont!
    @IBOutlet weak var rejectedREasonStackView: UIStackView!
    @IBOutlet weak var bankAccountLabel: CustomLabelFont!
    @IBOutlet weak var statusLabel: CustomLabelFont!
    @IBOutlet weak var actionStackView: UIStackView!
    @IBOutlet weak var statusView: UIStackView!
    @IBOutlet weak var requestIDLabel: CustomLabelFont!
    @IBOutlet weak var requestedByIDLabel: CustomLabelFont!
    @IBOutlet weak var requestedOnLabel: CustomLabelFont!
    @IBOutlet weak var availableAmountLabel: CustomLabelFont!
    @IBOutlet weak var requestedAmountLabel: CustomLabelFont!
    
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
    
    func configData(requestType: AffiliatedWithdrawalListType, data: AffiliatedWithdrawalList?, hasActionPermission: Bool) {
        actionStackView.isHidden = true
        statusView.isHidden = true
        rejectedREasonStackView.isHidden = true
        transactionSackView.isHidden = true
        requestIDLabel.text = "#\(data?.requestID ?? "0")"
//        requestedByIDLabel.text =  "\(data?.affiliateDetails?.fullName ?? "") | \(data?.affiliateDetails?.countryDetails?.name ?? "")"
//        affiliate detail -> address detail -> country detail -> name
        requestedByIDLabel.text =  "\(data?.affiliateDetails?.fullName ?? "") | \(data?.affiliateDetails?.addressDetails?.countryDetails?.name ?? "")"
        requestedOnLabel.text = formatDate(data?.createdAt ?? "")
        bankAccountLabel.text = maskAccountNumber(data?.bankDetails?.accountNo ?? "")
        availableAmountLabel.text = CommonUtils.formatPriceStringInput(data?.totalEarning)
        requestedAmountLabel.text = CommonUtils.formatPriceStringInput(data?.amount)
        rejectedReasonLabel.text = data?.rejectReason
        transactionLabel.text = "#\(data?.requestID ?? "0")"//"#\(data?.transactionID ?? "0")"
        switch requestType {
        case .newRequest:
            actionStackView.isHidden = !hasActionPermission
        case .approvedRequest:
            statusView.isHidden = false
            transactionSackView.isHidden = false
            statusLabel.text = "Completed"
            statusLabel.textColor = UIColor(hexString: "#17854C")
        case .rejectedRequest:
            statusView.isHidden = false
            rejectedREasonStackView.isHidden = false
            statusLabel.text = "Rejected"
            statusLabel.textColor = UIColor(hexString: "#D53B36")
        }
    }
    
    func maskAccountNumber(_ accountNumber: String) -> String {
        guard accountNumber.count > 8 else {
            return accountNumber
        }
        
        let firstFour = accountNumber.prefix(5)
        let lastFour = accountNumber.suffix(3)
        let maskedCount = accountNumber.count - 8
        let maskedPart = String(repeating: "X", count: maskedCount)
        
        return "\(firstFour)\(maskedPart)\(lastFour)"
    }
    
    func formatDate(_ isoDate: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS'Z'"
        inputFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")

        guard let date = inputFormatter.date(from: isoDate) else {
            return ""
        }

        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "dd/MM/yyyy 'at' hh:mm a"
        outputFormatter.timeZone = TimeZone.current

        return outputFormatter.string(from: date)
    }
    
}
