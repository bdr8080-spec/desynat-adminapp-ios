//
//  AffiliatedUsersListTableViewCell.swift
//  DesynatAdmin
//
//  Created by fluper on 20/01/26.
//

import UIKit

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
    
    func configData(userType: AffiliatedUsersListType) {
        newStackView.isHidden = true
        approvedStackView.isHidden = true
        rejectedStackView.isHidden = true
        switch userType {
        case .newUsers:
            newStackView.isHidden = false
        case .approvedUsers:
            approvedStackView.isHidden = false
        case .rejectedUsers:
            rejectedStackView.isHidden = false
        }
    }
    
    
    
}
