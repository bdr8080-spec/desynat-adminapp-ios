//
//  RefundManagementTableViewCell.swift
//  DesynatAdmin
//
//  Created by  shailendra singh on 27/03/26.
//

import UIKit

class RefundManagementTableViewCell: UITableViewCell {
    
    @IBOutlet weak var forHideView: UIView!
    @IBOutlet weak var viewMoreButton: UIButton!
    @IBOutlet weak var usernameLabel: CustomLabelFont!
    @IBOutlet weak var orderIdLabel: UILabel!
    @IBOutlet weak var transactionId: UILabel!
    @IBOutlet weak var orderedOnLbael: UILabel!
    @IBOutlet weak var totalAmountLabel: UILabel!
    @IBOutlet weak var cancelledReturnedOnDateLabel: UILabel!
    @IBOutlet weak var sellerNameLabel: UILabel!
    @IBOutlet weak var countryNameLabel: UILabel!
    @IBOutlet weak var rejectedReasonLabel: CustomLabelFont!
    @IBOutlet weak var statusLabel: CustomLabelFont!
    
    var isViewMore: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func viewLessAndMoreBtn(_ sender: UIButton) {
        isViewMore?()
    }
    
    func configure(isExpanded: Bool) {
        forHideView.isHidden = !isExpanded
        let title = isExpanded ? "View Less" : "More info"
        viewMoreButton.setTitle(title, for: .normal)
    }
    
}
