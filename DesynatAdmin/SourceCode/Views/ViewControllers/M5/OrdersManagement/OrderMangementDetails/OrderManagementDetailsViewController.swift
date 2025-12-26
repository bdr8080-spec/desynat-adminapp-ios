//
//  OrderManagementDetailsViewController.swift
//  DesynatAdmin
//
//  Created by fluper on 17/12/25.
//

import UIKit
import SDWebImage

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
    driverDetailsView.isHidden = true
    productTableView.rowHeight = UITableView.automaticDimension
    productTableView.estimatedRowHeight = 260
    productTableView.isScrollEnabled = false
    // Observe contentSize safely (will deliver initial value too)
    productTableView.addObserver(self, forKeyPath: "contentSize", options: [.new, .initial], context: nil)
    self.viewModel.getOrderDetail(orderId: self.orderId ?? 0) {
      self.lblSellerName.text = "\(self.viewModel.orderDetail?.orderDetails?.first?.productDetails?.sellerDetails?.firstName ?? "") \(self.viewModel.orderDetail?.orderDetails?.first?.productDetails?.sellerDetails?.lastName ?? "")"
      
      let fullIdString = self.viewModel.orderDetail?.orderID.map { String(describing: $0) } ?? ""
      let last7OrderID = fullIdString.count >= 7 ? String(fullIdString.suffix(7)) : fullIdString
      self.lblOrderId.text = "#\(last7OrderID)"
      self.lblDateTime.text = CommonUtils.getDateStrings(
        from: Date(iso8601String: String.getString(self.viewModel.orderDetail?.createdAt)),
        format: "dd/MM/yyyy 'at' hh:mm a"
      )
      self.lblCustomerName.text = self.viewModel.orderDetail?.deliveryDetails?.name ?? ""
      self.lblDeliveredBy.text = self.viewModel.orderDetail?.deliveryDetails?.name ?? ""
      self.lblTotalAmount.text = "\(self.viewModel.orderDetail?.totalAmount ?? "") KD"
      self.lblCommissionEarn.text = "\(self.viewModel.orderDetail?.totalAmount ?? "") KD"
      self.lblCountry.text = self.viewModel.orderDetail?.deliveryDetails?.countryName ?? ""
      self.lblShippingLocation.text =
      self.buildFullAddress(from: self.viewModel.orderDetail?.deliveryDetails)
      self.lblDeliveredBy.text = self.viewModel.orderDetail?.driverDetails?.fullNameEnglish
      self.productTableView.reloadData()
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
      self.lblCancelReason.text = self.viewModel.orderDetail?.orderDetails?.first?.cancelReason
      
      self.deliveryInstaructionStackView.isHidden = true
      self.cancellationStackView.isHidden = true
      self.productRatingStackView.isHidden = true
      self.sellerRatingStackView.isHidden = true
      self.returnDetailsStackView.isHidden = true
      let deliveryStatus = self.viewModel.orderDetail?.orderDetails?.first?.deliveryStatus
      let assignStatus = self.viewModel.orderDetail?.assignStatus
      switch deliveryStatus {
      case "1", "2": // ongoing, confirmed
        self.activateStep(0, title: "Confirmed")
        self.activateStep(1, title: "Shipped")
        self.lblStatus.text = "Active"
        switch assignStatus {
        case "1":
          self.assignDriverView.isHidden = true
          self.deliveryByStackView.isHidden = false
          self.driverDetailsView.isHidden = false
        case "2":
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
        
      case "4": //Cancelled
        self.activateStep(0, title: "Confirmed")
        self.activateStep(1, title: "Shipped")
        self.activateStep(2, title: "On the Way")
        self.activateStep(3, title: "Cancelled")
        self.cancellationStackView.isHidden = false
        
      case "7": //Picked
        self.activateStep(0, title: "Confirmed")
        self.activateStep(1, title: "Shipped")
        self.activateStep(2, title: "On the Way")
        self.lblStatus.text = "On The Way"
        
      case "9": // Exchange
        self.activateStep(0, title: "Confirmed")
        self.activateStep(1, title: "Shipped")
        self.activateStep(2, title: "On the Way")
        self.activateStep(3, title: "Exchanged")
        self.returnDetailsStackView.isHidden = false
        
      case "5": // Return
        self.activateStep(0, title: "Confirmed")
        self.activateStep(1, title: "Shipped")
        self.activateStep(2, title: "On the Way")
        self.activateStep(3, title: "Returned")
        self.returnDetailsStackView.isHidden = false
        
      default:
        self.assignDriverView.isHidden = true
        self.deliveryByStackView.isHidden = true
        self.driverDetailsView.isHidden = true
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
  
}

extension OrderManagementDetailsViewController: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.viewModel.orderDetail?.orderDetails?.count ?? 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ProductListTableViewCell", for: indexPath) as! ProductListTableViewCell
    cell.serialNumberLabel.text = "0\(indexPath.row + 1)"
    cell.setData(data: self.viewModel.orderDetail?.orderDetails?[indexPath.row])
    return cell
  }
  
}
