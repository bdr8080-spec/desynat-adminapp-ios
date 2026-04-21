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
    @IBOutlet weak var transactionstackView: UIStackView!
    
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
    
    func configure(isExpanded: Bool, data: RefundMangementList?) {
        forHideView.isHidden = !isExpanded
        let title = isExpanded ? "View Less" : "More info"
        viewMoreButton.setTitle(title, for: .normal)
        
        usernameLabel.text = data?.order?.deliveryDetails?.name
        orderIdLabel.text = "#\(data?.order?.id ?? 0)"
        let fullTransactionIdString = data?.order?.transactionID.map { String(describing: $0) } ?? ""
        let last7TransactionID = fullTransactionIdString.count >= 7 ? String(fullTransactionIdString.suffix(7)) : fullTransactionIdString
        if last7TransactionID.isEmpty {
            transactionstackView.isHidden = true
        } else {
            transactionstackView.isHidden = false
        }
        transactionId.text = "#\(last7TransactionID)"
        orderedOnLbael.text = CommonUtils.getDateStrings(
            from: Date(iso8601String: String.getString(data?.order?.createdAt ?? "")),
            format: "dd/MM/yyyy 'at' hh:mm a"
        )
        cancelledReturnedOnDateLabel.text = CommonUtils.getDateStrings(
            from: Date(iso8601String: String.getString(data?.updatedAt ?? "")),
            format: "dd/MM/yyyy 'at' hh:mm a"
        )
        totalAmountLabel.text = CommonUtils.formatPriceStringInput(data?.order?.totalAmount)
        sellerNameLabel.text = "\(data?.productDetails?.sellerDetails?.firstName ?? "") \(data?.productDetails?.sellerDetails?.lastName ?? "")"
        countryNameLabel.text = data?.productDetails?.store?.countryInfo?.name
        rejectedReasonLabel.text = data?.cancelReason ?? data?.returnReason ?? data?.exchangeReason ?? ""
        statusLabel.text = "Pending"
    }
    
}
