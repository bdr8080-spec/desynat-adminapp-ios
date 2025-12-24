//
//  OrderManagementDetailsViewController.swift
//  DesynatAdmin
//
//  Created by fluper on 17/12/25.
//

import UIKit

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
    
    
    //MARK: VARIABLES
    private lazy var viewModel = OrderManagementListViewModel()
    var orderId: Int?
    
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
            self.lblShippingLocation.text = self.viewModel.orderDetail?.deliveryDetails?.address ?? ""
            self.productTableView.reloadData()
        }
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
            print("Selected Driver ID:", driverId)
            print("Selected Driver Name:", driver.fullNameEnglish)
            self.assignDriverView.isHidden = true
            self.driverDetailsView.isHidden = false
            self.lblDriverName.text = driver.fullNameEnglish
            // API call example
           // self.assignDriver(orderId: self.orderId, driverId: driverId)
        }
        self.navigationController?.present(nextVC, animated: true)
    }
    
    @IBAction func editDriverDidTapped(_ sender: Any) {
        let nextVC = DriversListViewController.instantiate(fromAppStoryboard: .AffiliatedBannerOrder)
        nextVC.orderId = Int(self.viewModel.orderDetail?.orderID ?? "") ?? 0
        nextVC.driverIsAssigned = { driverId, driver in
            print("Selected Driver ID:", driverId)
            print("Selected Driver Name:", driver.fullNameEnglish)
            self.lblDriverName.text = driver.fullNameEnglish
            // API call example
           // self.assignDriver(orderId: self.orderId, driverId: driverId)
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
