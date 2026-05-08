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
    @IBOutlet weak var transactionstackView: UIStackView!
    @IBOutlet weak var appliedPromocodestackView: UIStackView!
    
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
    @IBOutlet weak var giftCardTrasnctionStackView: UIStackView!
    
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
    
    func configure(isExpanded: Bool, tab: PaymentTab, data: PaymentList?) {
        
        forHideView.isHidden = !isExpanded
        let title = isExpanded ? "View Less".localiz() : "More info".localiz()
        viewMoreButton.setTitle(title, for: .normal)
        
        // Hide all first
        orderStackView.isHidden = true
        planStackView.isHidden = true
        giftAndBannerStackView.isHidden = true
        
        // Show based on tab
        switch tab {
        case .orders:
            orderStackView.isHidden = false
            titleUserName.text = "User Name".localiz()
            orderIdTitle.text = "Order Id".localiz()
            titleValue.text = data?.userDetails?.fullName
            orderValue.text = "#\(data?.order?.id ?? 0)"
            
        case .plans:
            planStackView.isHidden = false
            titleUserName.text = "Seller name".localiz()
            orderIdTitle.text = "Plan name".localiz()
            titleValue.text = "\(data?.sellerDetails?.firstName ?? "") \(data?.sellerDetails?.lastName ?? "")"
            orderValue.text = data?.planInfo?.planNameEnglish
            
        case .giftCards :
            giftAndBannerStackView.isHidden = false
            titleUserName.text = "Purchased By".localiz()
            orderIdTitle.text = "Card Type".localiz()
            titleValue.text = data?.userDetails?.fullName
            orderValue.text = data?.giftDetails?.nameEnglish
            giftCardtotalAmount.text = CommonUtils.formatPriceStringInput(data?.amount)
            giftCardCountry.text = data?.userDetails?.countryInfo?.name
            
        case .banners:
            giftAndBannerStackView.isHidden = false
            titleUserName.text = "Purchased By".localiz()
            orderIdTitle.text = "Request Id".localiz()
            titleValue.text = "\(data?.sellerDetails?.firstName ?? "") \(data?.sellerDetails?.lastName ?? "")"
            orderValue.text = "#\(data?.orderID ?? "0")"
            giftCardtotalAmount.text = CommonUtils.formatPriceStringInput(data?.price)
            giftCardCountry.text = data?.sellerDetails?.storeInfo?.countryInfo?.name
            giftCardPaymentmode.text = "Online".localiz()
        }
        configureData(data: data, tab: tab)
    }
    
    func configureData(data: PaymentList?, tab: PaymentTab) {
        orderTransactionId.text = "#\(data?.order?.transactionID ?? "0")"
        orderedOn.text = formatDate(data?.order?.createdAt ?? "")
        orderTotalAmount.text = CommonUtils.formatPrice(data?.total_paid_amount)
        let paymentMethod = data?.order?.paymentMethod
        transactionstackView.isHidden = true
        switch paymentMethod {
        case "1":
            self.orderPaymentMode.text = "Online".localiz()
            transactionstackView.isHidden = false
        case "2":
            self.orderPaymentMode.text = "In-App Wallet".localiz()
        case "3":
            self.orderPaymentMode.text = "COD".localiz()
        default:
            self.orderPaymentMode.text = "COD".localiz()
        }
        if let promode = data?.promocodeValue, !promode.isEmpty {
            appliedPromocodestackView.isHidden = false
            orderAppliedPromoCode.text = promode
        } else {
            appliedPromocodestackView.isHidden = true
        }
        
        orderDiscount.text = CommonUtils.formatPrice(data?.totalDiscount)
        orderSellerName.text = "\(data?.productDetails?.sellerDetails?.firstName ?? "") \(data?.productDetails?.sellerDetails?.lastName ?? "")"
        orderCommission.text = "\(CommonUtils.formatPriceStringInput(data?.adminCommission))"
        
        //Plan
        planTransactionId.text = "#\(data?.transactionId ?? "0")"
        planPurchasedOn.text = formatDate(data?.createdAt ?? "")
        planTotalAmount.text = CommonUtils.formatPriceStringInput(data?.amount)
        planPaymentMode.text = data?.paymentMethod
        
        //Gift Card And Banner
        giftCardTransactionId.text = "#\(data?.transactionId ?? "0")"
        giftCardPurchasedOn.text = formatDate(data?.createdAt ?? "")
        
        let paymentMethodCard = data?.paymentMethod
        giftCardTrasnctionStackView.isHidden = true
        if tab == .giftCards {
            switch paymentMethodCard {
            case "1":
                self.giftCardPaymentmode.text = "Online".localiz()
                giftCardTrasnctionStackView.isHidden = false
            case "2":
                self.giftCardPaymentmode.text = "In-App Wallet".localiz()
            case "3":
                self.giftCardPaymentmode.text = "COD".localiz()
            default:
                self.giftCardPaymentmode.text = "COD".localiz()
            }
        }
        
    }
    
    func formatDate(_ isoDateString: String) -> String {
        let inputFormatter = ISO8601DateFormatter()
        inputFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        guard let date = inputFormatter.date(from: isoDateString) else {
            return "Invalid date".localiz()
        }
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "dd/MM/yyyy 'at' hh:mm a"
//        outputFormatter.locale = Locale(identifier: "en_US_POSIX")
        if AppLanguageManager.shared.currentLanguage == .ar {
            outputFormatter.locale = Locale(identifier: "ar")
           } else {
               outputFormatter.locale = Locale(identifier: "en_US")
           }
        return outputFormatter.string(from: date)
    }
    
}
