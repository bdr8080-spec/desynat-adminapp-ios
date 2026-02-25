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
    
}
