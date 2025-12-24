//
//  OrderMangementTableViewCell.swift
//  DesynatAdmin
//
//  Created by fluper on 17/12/25.
//

import UIKit

class OrderMangementTableViewCell: UITableViewCell {
    
    @IBOutlet weak var assignDriverStackView: UIStackView!
    @IBOutlet weak var assignDriverView: UIView!
    @IBOutlet weak var lblOrderID: UILabel!
    @IBOutlet weak var lblSellerName: UILabel!
    @IBOutlet weak var lblTransactionId: UILabel!
    @IBOutlet weak var lblOrderOn: UILabel!
    @IBOutlet weak var lblOrderType: UILabel!
    @IBOutlet weak var lblTotalAmount: UILabel!
    
    var assignDriverTapped: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func configure(data: OrderData) {
        self.lblSellerName.text = "\(data.orderDetails?.first?.productDetails?.sellerDetails?.firstName ?? "") \(data.orderDetails?.first?.productDetails?.sellerDetails?.lastName ?? "")"
        
        let fullIdString = data.orderID.map { String(describing: $0) } ?? ""
        let last7OrderID = fullIdString.count >= 7 ? String(fullIdString.suffix(7)) : fullIdString
        self.lblOrderID.text = "#\(last7OrderID)"
        
        let fullTransactionIdString = data.transactionID.map { String(describing: $0) } ?? ""
        let last7TransactionID = fullTransactionIdString.count >= 7 ? String(fullTransactionIdString.suffix(7)) : fullTransactionIdString
        self.lblTransactionId.text = "#\(last7TransactionID)"
        self.lblOrderOn.text = CommonUtils.getDateStrings(
            from: Date(iso8601String: String.getString(data.createdAt)),
            format: "dd/MM/yyyy 'at' hh:mm a"
        )
        self.lblTotalAmount.text = "\(data.totalAmount ?? "") KD"
        
    }
    
    @IBAction func assignDriverDidTapped(_ sender: Any) {
        assignDriverTapped?()
    }
    
}
