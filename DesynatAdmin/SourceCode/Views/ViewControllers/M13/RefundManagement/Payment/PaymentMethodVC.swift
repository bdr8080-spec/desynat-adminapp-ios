//
//  PaymentMethodVC.swift
//  DesynatDealer
//
//  Created by fluper on 07/11/25.
//

enum PayFrom {
    case plan
    case banner
    case mySubscriptionPlan
    case storyManagementPayment
    case refundOrder
    case sellerPayout
}

import UIKit
import MFSDK

class PaymentMethodVC: UIViewController {
    
    @IBOutlet weak var lblTotalAmt: CustomLabelFont!
    @IBOutlet weak var lblMonth: CustomLabelFont!
    @IBOutlet weak var viewCreditCard: UIView!
    @IBOutlet weak var viewPayment: MFPaymentCardView!
    @IBOutlet weak var cardSelectionImageView: UIImageView!
    
    var payAmount: Double = 0.0
    var getFatoorahResponse: MFPaymentStatusResponse?
    var transactionIds: String?
    var durationOfPlan: String? = ""
    var paymentFrom: PayFrom = .plan
    var paymentTransactionDetails: (transactionID: String,paymentId:String, invoiceId: String, paymentGateway: String)?
    var paymentCompleted: Bool = false
    var isCardIsSlecteed: Bool = false
    var selectedPaymentMethodID: Int? = nil
    var orderId: Int? = 0
    lazy private var viewModel: PaymentViewModel = PaymentViewModel(hostVC: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isCardIsSlecteed = true
        lblMonth.text = durationOfPlan
        lblTotalAmt.text = CommonUtils.formatPrice(payAmount)
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSelectPaymentMethod(_ sender: Any) {
        cardSelectionImageView.image = UIImage(named: "radioSelected")
        isCardIsSlecteed = true
        selectedPaymentMethodID = nil
        if paymentFrom == .plan || paymentFrom == .mySubscriptionPlan {
            creditDebitCardPayment(
                invoiceValue: Decimal(payAmount),
                orderId: transactionIds ?? ""
            ) { [weak self] response, invoiceId, error in
                guard let self = self else { return }
                if let err = error {
                    self.showAlert(msg: err.localizedDescription)
                    return
                }
            }
        }
    }
    
    @IBAction func btnPay(_ sender: Any) {
        guard selectedPaymentMethodID != nil || isCardIsSlecteed else {
            showAlert(msg: "Please select a payment option".localiz())
            return
        }
        if isCardIsSlecteed {
            switch paymentFrom {
            case .plan, .mySubscriptionPlan:
                cardSelectionImageView.image = UIImage(named: "radioSelected")
                isCardIsSlecteed = true
                selectedPaymentMethodID = nil
                creditDebitCardPayment(
                    invoiceValue: Decimal(payAmount),
                    orderId: transactionIds ?? ""
                ) { [weak self] response, invoiceId, error in
                    guard let self = self else { return }
                    if let err = error {
                        self.showAlert(msg: err.localizedDescription)
                        return
                    }
                }
                
            case .banner, .storyManagementPayment:
                creditDebitCardPayment(
                    invoiceValue: Decimal(payAmount),
                    orderId: transactionIds ?? "",
                ) { [weak self] response, invoiceId, error in
                    guard let self = self else { return }
                    if let err = error {
                        self.showAlert(msg: err.localizedDescription)
                        return
                    }
                }
            case .refundOrder:
                cardSelectionImageView.image = UIImage(named: "radioSelected")
                isCardIsSlecteed = true
                selectedPaymentMethodID = nil
                creditDebitCardPayment(
                    invoiceValue: Decimal(payAmount),
                    orderId: transactionIds ?? ""
                ) { [weak self] response, invoiceId, error in
                    guard let self = self else { return }
                    if let err = error {
                        self.showAlert(msg: err.localizedDescription)
                        return
                    }
                }
        
            
        case .sellerPayout:
            cardSelectionImageView.image = UIImage(named: "radioSelected")
            isCardIsSlecteed = true
            selectedPaymentMethodID = nil
            creditDebitCardPayment(
                invoiceValue: Decimal(payAmount),
                orderId: transactionIds ?? ""
            ) { [weak self] response, invoiceId, error in
                guard let self = self else { return }
                if let err = error {
                    self.showAlert(msg: err.localizedDescription)
                    return
                }
            }
        }
        }
    }
}

extension PaymentMethodVC {
    func updateCardSelectionUI() {
        cardSelectionImageView.image = isCardIsSlecteed
        ? UIImage(named: "radioSelected")
        : UIImage(named: "radioUnselected")
    }
    
    func completePlanPurchase(transactionId: String,
                              paymentStatus: Int,
                              onlineTransactionId: String) {
        self.viewModel.refundOrder(orderDetailId: orderId ?? 0, "") {
            self.navigationController?.popViewController(animated: false)
        }
    }
    
    func completeRefundOrder(_ paymentId:String) {
        self.viewModel.refundOrder(orderDetailId: orderId ?? 0, paymentId) {
            self.navigationController?.popViewController(animated: false)
        }
    }
    
    func completeSellerPayout(_ paymentId:String) {
        self.viewModel.sellerPayout(sellerID: orderId ?? 0, payAmount: payAmount, paymentId) {
            self.navigationController?.popViewController(animated: false)
        }
    }
    
    func creditDebitCardPayment(invoiceValue: Decimal,
                                orderId: String,
                                completion: @escaping (MFPaymentStatusResponse?, String?, Error?) -> Void) {
        let request = MFExecutePaymentRequest(invoiceValue: invoiceValue, paymentMethod: 2)
        request.customerReference = orderId
        request.displayCurrencyIso = .kuwait_KWD
        MFPaymentRequest.shared.executePayment(request: request, apiLanguage: .english) { result, invoiceId in
            switch result {
            case .success(let paymentStatus):
                completion(paymentStatus, invoiceId, nil)
                
                let transactionID = paymentStatus.invoiceTransactions?.first?.transactionID ?? ""
                let paymentID = paymentStatus.invoiceTransactions?.first?.paymentID ?? ""
                let paymentGateway = paymentStatus.invoiceTransactions?.first?.paymentGateway ?? "VisaPay".localiz()
                
                DispatchQueue.main.async {
                    self.paymentTransactionDetails = (transactionID,paymentID, invoiceId ?? "", paymentGateway)
                    self.paymentCompleted = true
                    self.handlePaymentCompletion(transactionID: transactionID,paymentId: paymentID, invoiceId: invoiceId ?? "", gateway: paymentGateway)
                    
                }
            case .failure(let error):
                completion(nil, invoiceId,
                           NSError(domain: "", code: 0,
                                   userInfo: [NSLocalizedDescriptionKey: error.errorDescription]))
            }
        }
    }
    
    func paymentDoneWithCard() {
        let invoiceValue = Decimal(payAmount)
        let request = MFExecutePaymentRequest(invoiceValue: invoiceValue)
        request.customerReference = self.transactionIds ?? ""
        viewPayment.pay(request, .english) { [weak self] response, invoiceId in
            guard let self = self else { return }
            switch response {
            case .success(let paymentStatus):
                print("Payment successful with invoiceId: \(invoiceId ?? "N/A")")
                let transactionID = paymentStatus.invoiceTransactions?.first?.transactionID ?? ""
                let paymentId = paymentStatus.invoiceTransactions?.first?.paymentID ?? ""
                let paymentGateway = paymentStatus.invoiceTransactions?.first?.paymentGateway ?? "card".localiz()
                paymentTransactionDetails = (transactionID,paymentId, invoiceId ?? "", paymentGateway)
                paymentCompleted = true
                self.handlePaymentCompletion(transactionID: transactionID, paymentId: paymentId, invoiceId: invoiceId ?? "", gateway: paymentGateway)
            case .failure(let error):
                print("Payment Error: \(error.errorDescription)")
                let text = "Payment Failed:".localiz()
                self.showAlert(msg: "\(text) \(error.errorDescription)")
            }
        }
    }
    
    func didReceivePaymentError(_ message: String) {
        showAlert(msg: message)
    }
    
    func handlePaymentCompletion(transactionID: String,paymentId:String, invoiceId: String, gateway: String) {
        paymentTransactionDetails = (transactionID,paymentId, invoiceId, gateway)
        paymentCompleted = true
        if selectedPaymentMethodID != 3 {
            switch paymentFrom {
            case .plan, .mySubscriptionPlan:
                completePlanPurchase(transactionId: self.transactionIds ?? "", paymentStatus: 1, onlineTransactionId: transactionID)
            case .banner:
                break
            case .storyManagementPayment:
                break
            case .refundOrder:
                completeRefundOrder(paymentId)
            case .sellerPayout:
                completeSellerPayout(paymentId)
            }
        }
    }
    
    func cardPay() {
        var configure = MFCardConfigureBuilder.default
        configure.setPlaceholder(MFCardPlaceholder(cardHolderNamePlaceholder: "Name".localiz(), cardNumberPlaceholder: "Number".localiz(), expiryDatePlaceholder: "MM / YY".localiz(), cvvPlaceholder: "CVV".localiz()))
        configure.setLabel(MFCardLabel(cardHolderNameLabel: "Card holder name".localiz(), cardNumberLabel: "Card number".localiz(), expiryDateLabel: "MM / YY".localiz(), cvvLabel: "CVV".localiz(), showLabels: true, fontWeight: .normal))
        let theme = MFCardTheme(inputColor: .black, labelColor: .black, errorColor: .red, borderColor: .black)
        theme.language = .english
        configure.setTheme(theme)
        configure.setCardInput(MFCardInput(inputHeight: 32, inputMargin: 15))
        configure.setFontSize(15)
        configure.setBorderWidth(1)
        configure.setBorderRadius(8)
        configure.setHideCardIcon(false)
        configure.setFontFamily(.timesNewRoman)
        configure.setBoxShadow(MFBoxShadow(hOffset: 0, vOffset: 0, blur: 0, spread: 0, color: .gray))
        viewPayment.configure = configure.build()
        cardPayInitiation()
    }
    
    func cardPayInitiation() {
        MFPaymentRequest.shared.initiateSession(apiLanguage: .english) { [weak self] response in
            switch response {
            case .success(let session):
                self?.viewPayment.load(initiateSession: session) { bin in
                    print("bin", bin)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

