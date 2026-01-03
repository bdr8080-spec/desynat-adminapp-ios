//
//  OrderManagementDetailsViewController.swift
//  DesynatAdmin
//
//  Created by fluper on 17/12/25.
//

import UIKit
import SDWebImage
import Cosmos

class OrderManagementDetailsViewController: UIViewController {
    
    //MARK: IBOUTLETS
    @IBOutlet weak var assignDriverView: UIView!
    @IBOutlet weak var driverDetailsView: UIView!
    @IBOutlet weak var productTableView: UITableView! {
        didSet {
            productTableView.registerCellFromNib(cellID: "ProductListTableViewCell")
        }
    }
    @IBOutlet weak var tblProductHeight: NSLayoutConstraint!
    @IBOutlet weak var lblOrderId: UILabel!
    @IBOutlet weak var lblDateTime: UILabel!
    @IBOutlet weak var lblOrderType: UILabel!
    @IBOutlet weak var lblZone: UILabel!
    @IBOutlet weak var lblCustomerName: UILabel!
    @IBOutlet weak var lblSellerName: UILabel!
    @IBOutlet weak var lblDeliveredBy: UILabel!
    @IBOutlet weak var lblCountry: UILabel!
    @IBOutlet weak var lblShippingLocation: UILabel!
    @IBOutlet weak var lblDeliveryInstruction: UILabel!
    @IBOutlet weak var lblCancelReason: UILabel!
    @IBOutlet weak var lblProductReview: UILabel!
    @IBOutlet weak var lblSellerReview: UILabel!
    @IBOutlet weak var lblReturnId: UILabel!
    @IBOutlet weak var lblRequestedOn: UILabel!
    @IBOutlet weak var lblOrderStatusDate: UILabel!
    @IBOutlet weak var lblTotalAmount: UILabel!
    @IBOutlet weak var lblCommissionEarn: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblDriverName: UILabel!
    @IBOutlet weak var imgDriver: UIImageView!
    @IBOutlet weak var deliveryByStackView: UIStackView!
    @IBOutlet weak var deliveryInstaructionStackView: UIStackView!
    @IBOutlet weak var zoneStackView: UIStackView!
    @IBOutlet weak var lbl1: UILabel!
    @IBOutlet weak var img1: UIImageView!
    @IBOutlet weak var lbl2: UILabel!
    @IBOutlet weak var img2: UIImageView!
    @IBOutlet weak var lbl3: UILabel!
    @IBOutlet weak var img3: UIImageView!
    @IBOutlet weak var lbl4: UILabel!
    @IBOutlet weak var img4: UIImageView!
    @IBOutlet weak var cancellationStackView: UIStackView!
    @IBOutlet weak var productRatingStackView: UIStackView!
    @IBOutlet weak var sellerRatingStackView: UIStackView!
    @IBOutlet weak var returnDetailsStackView: UIStackView!
    @IBOutlet weak var editAssignDriverButtonOutlet: UIButton!
    @IBOutlet weak var productRatingView: CosmosView!
    @IBOutlet weak var sellerRatingView: CosmosView!
    @IBOutlet weak var returnExchangeReasonStackView: UIStackView!
    @IBOutlet weak var retunrExchangeReasonLabel: UILabel!
    @IBOutlet weak var retunrDetailsTitleLabel: UILabel!
    @IBOutlet weak var paymentMethodLabel: UILabel!
    @IBOutlet weak var prodcuctReviewtitleLabel: UILabel!
    @IBOutlet weak var sellerReviewTitleLabel: UILabel!
    
    //MARK: VARIABLES
    private lazy var viewModel = OrderManagementListViewModel()
    var orderId: Int?
    lazy var stepImages: [StepImage] = [
        StepImage(selected: "confirmedOrder", unselected: "confirmedOrder"),
        StepImage(selected: "shippedDone", unselected: "shipped"),
        StepImage(selected: "ontheWayDone", unselected: "ontheWay"),
        StepImage(selected: "deliveredDone", unselected: "delivered"),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        productTableView.rowHeight = UITableView.automaticDimension
        productTableView.estimatedRowHeight = 260
        productTableView.isScrollEnabled = false
        //    // Observe contentSize safely (will deliver initial value too)
        productTableView.addObserver(self, forKeyPath: "contentSize", options: [.new, .initial], context: nil)
        self.viewModel.getOrderDetail(orderId: self.orderId ?? 0) {
            self.lblSellerName.text = "\(self.viewModel.orderDetail?.productDetails?.sellerDetails?.firstName ?? "") \(self.viewModel.orderDetail?.productDetails?.sellerDetails?.lastName ?? "")"
            
            //      let fullIdString = self.viewModel.orderDetail?.orderID.map { String(describing: $0) } ?? ""
            //      let last7OrderID = fullIdString.count >= 7 ? String(fullIdString.suffix(7)) : fullIdString
            //      self.lblOrderId.text = "#\(last7OrderID)"
            self.lblOrderId.text = "#\(self.viewModel.orderDetail?.id ?? 0)"
            //      let id = self.viewModel.orderDetail?.id
            self.lblDateTime.text = CommonUtils.getDateStrings(
                from: Date(iso8601String: String.getString(self.viewModel.orderDetail?.createdAt)),
                format: "dd/MM/yyyy 'at' hh:mm a"
            )
            self.lblCustomerName.text = self.viewModel.orderDetail?.order?.deliveryDetails?.name
            self.lblDeliveredBy.text = self.viewModel.orderDetail?.driverDetails?.fullNameEnglish ?? ""
            self.lblTotalAmount.text = "\(CommonUtils.formatPriceStringInput(self.viewModel.orderDetail?.order?.totalAmount))"
            self.lblCommissionEarn.text = "\(CommonUtils.formatPrice(self.viewModel.orderDetail?.adminCommission))"
            self.lblCountry.text = self.viewModel.orderDetail?.order?.deliveryDetails?.countryName ?? ""
            self.lblShippingLocation.text =
            self.buildFullAddress(from: self.viewModel.orderDetail?.order?.deliveryDetails)
            self.lblDeliveredBy.text = self.viewModel.orderDetail?.driverDetails?.fullNameEnglish
            self.productTableView.reloadData()
            let paymentMethod = self.viewModel.orderDetail?.order?.paymentMethod
            switch paymentMethod {
            case "1":
                self.paymentMethodLabel.text = "Online"
            case "2":
                self.paymentMethodLabel.text = "In-App Wallet"
            case "3":
                self.paymentMethodLabel.text = "COD"
            default:
                self.paymentMethodLabel.text = "COD"
            }
            self.lblDriverName.text = self.viewModel.orderDetail?.driverDetails?.fullNameEnglish
            if let imageUrlString = self.viewModel.orderDetail?.driverDetails?.profilePic,
               let url = URL(string: imageUrlString) {
                self.imgDriver.sd_imageIndicator = SDWebImageActivityIndicator.gray
                self.imgDriver.sd_imageIndicator?.startAnimatingIndicator()
                self.imgDriver.sd_setImage(with: url, placeholderImage: UIImage(named: "userProfile"))
            } else {
                self.imgDriver.image = UIImage(named: "userProfile")
            }
            let zoneName = self.viewModel.orderDetail?.driverDetails?.zoneInfo?.nameEnglish ?? ""
            if !zoneName.isEmpty {
                self.zoneStackView.isHidden = false
            } else {
                self.zoneStackView.isHidden = true
            }
            self.lblZone.text = zoneName
            self.assignDriverView.isHidden = true
            self.driverDetailsView.isHidden = true
            self.deliveryInstaructionStackView.isHidden = true
            self.cancellationStackView.isHidden = true
            self.productRatingStackView.isHidden = true
            self.sellerRatingStackView.isHidden = true
            self.returnDetailsStackView.isHidden = true
            self.returnExchangeReasonStackView.isHidden = true
            self.lblStatus.textColor = UIColor(hexString: "#16B364")
            let deliveryStatus = self.viewModel.orderDetail?.deliveryStatus
            let paymentStatus = self.viewModel.orderDetail?.paymentStatus
            let assignStatus = self.viewModel.orderDetail?.assignStatus
            switch paymentStatus {
            case "2", "3": //Cancelled
                self.activateStep(0, title: "Confirmed")
                self.activateStep(1, title: "Shipped")
                self.activateStep(2, title: "On the Way")
                self.activateStep(3, title: "Cancelled")
                self.cancellationStackView.isHidden = false
                self.lblCancelReason.text = self.viewModel.orderDetail?.order?.cancelReason
                self.lblStatus.text = "Cancelled"
                self.lblStatus.textColor = UIColor(hexString: "#D91A1B")
                self.editAssignDriverButtonOutlet.isHidden = true
                self.assignDriverView.isHidden = true
                //        case "3": //Returned
                //          self.activateStep(0, title: "Confirmed")
                //          self.activateStep(1, title: "Shipped")
                //          self.activateStep(2, title: "On the Way")
                //          self.activateStep(3, title: "Returned")
                //          self.returnDetailsStackView.isHidden = false
                //          self.retunrDetailsTitleLabel.text = "Return Details"
                //          self.retunrExchangeReasonLabel.text = self.viewModel.orderDetail?.returnReason
                //          self.lblReturnId.text = "#\(self.viewModel.orderDetail?.orderID ?? 0)"
                //          self.lblRequestedOn.text = self.viewModel.orderDetail?.updatedAt?.formattedPlacedDate() ?? ""
                //          self.lblStatus.text = "Return"
                //          self.editAssignDriverButtonOutlet.isHidden = true
            default:
                switch deliveryStatus {
                case "1","2": // confirmed
                    self.activateStep(0, title: "Confirmed")
                    self.activateStep(1, title: "Shipped")
                    self.lblStatus.text = "Active"
                    switch assignStatus {
                    case "1":
                        self.assignDriverView.isHidden = true
                        self.deliveryByStackView.isHidden = false
                        self.driverDetailsView.isHidden = false
                    case "0":
                        self.assignDriverView.isHidden = false
                        self.deliveryByStackView.isHidden = true
                        self.driverDetailsView.isHidden = true
                    default:
                        print("")
                    }
                    
                    
                    
                case "3": // Delivered
                    self.activateStep(0, title: "Confirmed")
                    self.activateStep(1, title: "Shipped")
                    self.activateStep(2, title: "On the Way")
                    self.activateStep(3, title: "Delivered")
                    self.sellerRatingStackView.isHidden = false
                    self.productRatingStackView.isHidden = false
                    self.driverDetailsView.isHidden = false
                    self.editAssignDriverButtonOutlet.isHidden = true
                    let userRatingDone = self.viewModel.orderDetail?.userRatingReviewProvide
                    self.lblStatus.text = "Delivered"
                    // Hide by default
                    self.productRatingStackView.isHidden = true
                    self.sellerRatingStackView.isHidden = true
                    self.assignDriverView.isHidden = true
                    
                    guard let ratingData = userRatingDone else { return }
                    
                    /// ✅ PRODUCT RATING CHECK
                    let productReview = ratingData.productReview ?? ""
                    let productRatingValue = Double(ratingData.productRating ?? "") ?? 0
                    
                    if !productReview.isEmpty || productRatingValue > 0 {
                        self.productRatingStackView.isHidden = false
                        self.lblProductReview.text = productReview
                        self.productRatingView.rating = productRatingValue
                        
                    }
                    
                    if !productReview.isEmpty {
                        self.prodcuctReviewtitleLabel.isHidden = false
                    } else {
                        self.prodcuctReviewtitleLabel.isHidden = true
                    }
                    
                    /// ✅ SELLER RATING CHECK
                    let sellerReview = ratingData.storeReview ?? ""
                    let sellerRatingValue = Double(ratingData.storeRating ?? "") ?? 0
                    
                    if !sellerReview.isEmpty || sellerRatingValue > 0 {
                        self.sellerRatingStackView.isHidden = false
                        self.lblSellerReview.text = sellerReview
                        self.sellerRatingView.rating = sellerRatingValue
                        
                    }
                    if !sellerReview.isEmpty {
                        self.sellerReviewTitleLabel.isHidden = false
                    }else {
                        self.sellerReviewTitleLabel.isHidden = true
                    }
                    
                case "4": //Cancelled
                    self.activateStep(0, title: "Confirmed")
                    self.activateStep(1, title: "Shipped")
                    self.activateStep(2, title: "On the Way")
                    self.activateStep(3, title: "Cancelled")
                    self.cancellationStackView.isHidden = false
                    self.lblCancelReason.text = self.viewModel.orderDetail?.order?.cancelReason
                    self.lblStatus.text = "Cancelled"
                    self.assignDriverView.isHidden = true
                    self.editAssignDriverButtonOutlet.isHidden = true
                    
                case "7": //Picked
                    self.activateStep(0, title: "Confirmed")
                    self.activateStep(1, title: "Shipped")
                    self.activateStep(2, title: "On the Way")
                    self.lblStatus.text = "On The Way"
                    self.assignDriverView.isHidden = true
                    self.deliveryByStackView.isHidden = true
                    self.driverDetailsView.isHidden = false
                    self.editAssignDriverButtonOutlet.isHidden = true
                    
                case "9": // Exchange
                    self.activateStep(0, title: "Confirmed")
                    self.activateStep(1, title: "Shipped")
                    self.activateStep(2, title: "On the Way")
                    self.activateStep(3, title: "Exchanged")
                    self.returnDetailsStackView.isHidden = false
                    self.returnExchangeReasonStackView.isHidden = false
                    self.retunrExchangeReasonLabel.text = self.viewModel.orderDetail?.exchangeReason
                    self.lblReturnId.text = "#\(self.viewModel.orderDetail?.orderID ?? 0)"
                    self.lblRequestedOn.text = self.viewModel.orderDetail?.updatedAt?.formattedPlacedDate() ?? ""
                    self.retunrDetailsTitleLabel.text = "Exchange Details"
                    self.lblStatus.text = "Exchange"
                    self.assignDriverView.isHidden = true
                    self.editAssignDriverButtonOutlet.isHidden = true
                    
                case "5": // Return
                    self.activateStep(0, title: "Confirmed")
                    self.activateStep(1, title: "Shipped")
                    self.activateStep(2, title: "On the Way")
                    self.activateStep(3, title: "Returned")
                    self.returnDetailsStackView.isHidden = false
                    self.retunrDetailsTitleLabel.text = "Return Details"
                    self.retunrExchangeReasonLabel.text = self.viewModel.orderDetail?.returnReason
                    self.lblReturnId.text = "#\(self.viewModel.orderDetail?.orderID ?? 0)"
                    self.lblRequestedOn.text = self.viewModel.orderDetail?.updatedAt?.formattedPlacedDate() ?? ""
                    self.lblStatus.text = "Return"
                    self.assignDriverView.isHidden = true
                    self.editAssignDriverButtonOutlet.isHidden = true
                    
                default:
                    self.assignDriverView.isHidden = true
                    self.deliveryByStackView.isHidden = true
                    self.driverDetailsView.isHidden = true
                    self.lblStatus.text = "Ongoing"
                }
            }
        }
    }
    
    
    
    func buildFullAddress(from details: DeliveryDetails?) -> String {
        guard let details = details else { return "" }
        
        var addressParts: [String] = []
        
        // Base address (if API already provides)
        if let baseAddress = details.address?.trimmingCharacters(in: .whitespacesAndNewlines),
           !baseAddress.isEmpty {
            addressParts.append(baseAddress)
        }
        
        let additionalParts = [
            details.houseNo,
            details.streetNo,
            details.landmark,
            details.city,
            details.state,
            details.countryName,
            details.postalCode,
        ]
        
        for part in additionalParts {
            guard let value = part?.trimmingCharacters(in: .whitespacesAndNewlines),
                  !value.isEmpty else { continue }
            
            if !addressParts.joined(separator: " ").localizedCaseInsensitiveContains(value) {
                addressParts.append(value)
            }
        }
        
        return addressParts.joined(separator: ", ")
    }
    
    
    private func resetStepper() {
        let inactiveColor = UIColor.lightGray
        let labels = [lbl1, lbl2, lbl3, lbl4]
        let images = [img1, img2, img3, img4]
        
        for i in 0..<labels.count {
            labels[i]?.textColor = inactiveColor
            images[i]?.image = UIImage(named: stepImages[i].unselected)
        }
    }
    
    private func activateStep(_ index: Int, title: String) {
        let labels = [lbl1, lbl2, lbl3, lbl4]
        let images = [img1, img2, img3, img4]
        
        labels[index]?.text = title
        labels[index]?.textColor = UIColor(hexString: "#6E4527")
        images[index]?.image = UIImage(named: stepImages[index].selected)
    }
    
    private func hideStep(_ index: Int) {
        let labels = [lbl1, lbl2, lbl3, lbl4]
        let images = [img1, img2, img3, img4]
        
        labels[index]?.isHidden = true
        images[index]?.isHidden = true
    }
    
    
    deinit {
        productTableView.removeObserver(self, forKeyPath: "contentSize")
    }
    
    // Safe observeValue implementation
    override func observeValue(forKeyPath keyPath: String?, of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        guard keyPath == "contentSize", let table = object as? UITableView, table == productTableView else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
            return
        }
        
        // New value might be CGSize or NSValue; handle both
        var newSize: CGSize = .zero
        if let size = change?[.newKey] as? CGSize {
            newSize = size
        } else if let value = change?[.newKey] as? NSValue {
            newSize = value.cgSizeValue
        }
        
        DispatchQueue.main.async {
            self.tblProductHeight.constant = newSize.height
            // avoid forcing layout too often; only update parent if needed
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func backDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func assignDriverDidTapped(_ sender: Any) {
        let nextVC = DriversListViewController.instantiate(fromAppStoryboard: .AffiliatedBannerOrder)
        nextVC.orderId = self.viewModel.orderDetail?.id ?? 0
        nextVC.driverIsAssigned = { driverId, driver in
            self.assignDriverView.isHidden = true
            self.driverDetailsView.isHidden = false
            self.lblDriverName.text = driver.fullNameEnglish
            if let imageUrlString = driver.profilePic,
               let url = URL(string: imageUrlString) {
                self.imgDriver.sd_imageIndicator = SDWebImageActivityIndicator.gray
                self.imgDriver.sd_imageIndicator?.startAnimatingIndicator()
                self.imgDriver.sd_setImage(with: url, placeholderImage: UIImage(named: "userProfile"))
            } else {
                self.imgDriver.image = UIImage(named: "userProfile")
            }
            self.viewModel.assignDriver(orderId: self.orderId ?? 0, driverId: driverId) {
                
            }
        }
        self.navigationController?.present(nextVC, animated: true)
    }
    
    @IBAction func editDriverDidTapped(_ sender: Any) {
        let nextVC = DriversListViewController.instantiate(fromAppStoryboard: .AffiliatedBannerOrder)
        nextVC.orderId = self.viewModel.orderDetail?.id ?? 0
        nextVC.driverIsAssigned = { driverId, driver in
            self.assignDriverView.isHidden = true
            self.driverDetailsView.isHidden = false
            self.lblDriverName.text = driver.fullNameEnglish
            self.viewModel.assignDriver(orderId: self.orderId ?? 0, driverId: driverId) {
            }
        }
        self.navigationController?.present(nextVC, animated: true)
    }
    
    @IBAction func downloadInvoiceDidTapped(_ sender: Any) {
        let orderId = self.viewModel.orderDetail?.order?.orderID ?? ""
        let urlString = "http://157.241.119.72/Invoice/\(orderId)"
        
        guard let url = URL(string: urlString) else {
            showAlert(msg: "Invalid invoice URL")
            return
        }
        
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    
}

extension OrderManagementDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1//self.viewModel.orderDetail?.orderDetails?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductListTableViewCell", for: indexPath) as! ProductListTableViewCell
        cell.serialNumberLabel.text = "0\(indexPath.row + 1)"
        cell.setData(data: self.viewModel.orderDetail)
        return cell
    }
    
}
