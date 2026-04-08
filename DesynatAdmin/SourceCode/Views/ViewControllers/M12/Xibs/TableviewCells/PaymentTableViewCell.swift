//
//  PaymentTableViewCell.swift
//  DesynatAdmin
//
//  Created by  shailendra singh on 06/04/26.
//

import UIKit

class PaymentTableViewCell: UITableViewCell {

    @IBOutlet weak var forHideView: UIView!
    @IBOutlet weak var viewMoreButton: UIButton!
    @IBOutlet weak var orderStackView: UIStackView!
    @IBOutlet weak var planStackView: UIStackView!
    @IBOutlet weak var giftAndBannerStackView: UIStackView!
    
    @IBOutlet weak var titleUserName: CustomLabelFont!
    @IBOutlet weak var titleValue: UILabel!
    
    @IBOutlet weak var orderIdTitle: UILabel!
    @IBOutlet weak var orderValue: UILabel!
    
    //Order
    @IBOutlet weak var orderTransactionId: UILabel!
    @IBOutlet weak var orderedOn: UILabel!
    @IBOutlet weak var orderTotalAmount: UILabel!
    @IBOutlet weak var orderAppliedPromoCode: UILabel!
    @IBOutlet weak var orderPaymentMode: UILabel!
    @IBOutlet weak var orderDiscount: UILabel!
    @IBOutlet weak var orderSellerName: UILabel!
    @IBOutlet weak var orderCommission: UILabel!
    
    //Plan
    @IBOutlet weak var planTransactionId: UILabel!
    @IBOutlet weak var planPurchasedOn: UILabel!
    @IBOutlet weak var planTotalAmount: UILabel!
    @IBOutlet weak var planPaymentMode: UILabel!
    
    //Gift Card And Banner
    @IBOutlet weak var giftCardTransactionId: UILabel!
    @IBOutlet weak var giftCardPurchasedOn: UILabel!
    @IBOutlet weak var giftCardtotalAmount: UILabel!
    @IBOutlet weak var giftCardPaymentmode: UILabel!
    @IBOutlet weak var giftCardCountry: UILabel!
    
    var isViewMore: (() -> Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func viewLessAndMoreBtn(_ sender: UIButton) {
        isViewMore?()
    }
//    func configure(isExpanded: Bool) {
//            forHideView.isHidden = !isExpanded
//            let title = isExpanded ? "View Less" : "More info"
//            viewMoreButton.setTitle(title, for: .normal)
//        }
    
    func configure(isExpanded: Bool, tab: PaymentTab) {
        
        forHideView.isHidden = !isExpanded
        let title = isExpanded ? "View Less" : "More info"
        viewMoreButton.setTitle(title, for: .normal)
        
        // Hide all first
        orderStackView.isHidden = true
        planStackView.isHidden = true
        giftAndBannerStackView.isHidden = true
        
        // Show based on tab
        switch tab {
        case .orders:
            orderStackView.isHidden = false
            titleUserName.text = "User Name"
            orderIdTitle.text = "Order Id"
            
        case .plans:
            planStackView.isHidden = false
            titleUserName.text = "Seller name"
            orderIdTitle.text = "Plan name"
            
        case .giftCards :
            giftAndBannerStackView.isHidden = false
            titleUserName.text = "Purchased By"
            orderIdTitle.text = "Card Type"
            
        case .banners:
            giftAndBannerStackView.isHidden = false
            titleUserName.text = "Purchased By"
            orderIdTitle.text = "Request Id"
        }
    }
    
}
