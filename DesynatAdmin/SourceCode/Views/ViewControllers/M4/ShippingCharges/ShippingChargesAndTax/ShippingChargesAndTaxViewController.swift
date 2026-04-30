//
//  ShippingChargesAndTaxViewController.swift
//  DesynatAdmin
//
//  Created by fluper on 09/12/25.
//

import UIKit

class ShippingChargesAndTaxViewController: UIViewController {
    
    // MARK: - IBOutlet's
    @IBOutlet weak var defaultDeliveryFeeLabel: UILabel!
    @IBOutlet weak var bottomButtonsView: UIView!
    @IBOutlet weak var taxAmountLabel: UILabel!
    @IBOutlet weak var countryNameTitleLabel: UILabel!
    @IBOutlet weak var flagEmojiLabel: UILabel!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var pageCountLabel: UILabel!
    @IBOutlet weak var noDataFoundLabel: UILabel!
    @IBOutlet weak var shippingTableView: UITableView! {
        didSet {
            shippingTableView.registerCellFromNib(cellID: "ShippingFeesTableViewCell")
        }
    }
    @IBOutlet weak var editCountryTaxButton: UIButton!
    @IBOutlet weak var editDeafultDeliveryFeesButton: UIButton!
    @IBOutlet weak var plusButtonOutlet: UIButton!
    
    // MARK: - Property Decalaration
    var countryId: Int? = 0
    var flag: String? = ""
    var countryName: String? = ""
    private lazy var viewModel = ShippingChargesAndTaxViewModel(hostVC: self)
    private var currentPageIndex = 0
    private var itemsPerPage = 4
    var taxAmount: String? = ""
    var defaultTaxAmount: String? = ""
    var hasActionPermission: Bool = false
    
    // MARK: - View's LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        populateCountryData()
        viewModel.getAllshippingTaxList()
        viewModel.getDefaultDeliveryFees()
        editDeafultDeliveryFeesButton.isHidden = !hasActionPermission
        editCountryTaxButton.isHidden = !hasActionPermission
        plusButtonOutlet.isHidden = !hasActionPermission
    }
    
    // MARK: - Button's Action
    @IBAction func backDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func editDidTapped(_ sender: Any) {
        let nextVC = SetTaxViewController.instantiate(fromAppStoryboard: .ShippingPromocode)
        nextVC.countryID = countryId
        nextVC.taxAmount = taxAmount
        nextVC.taxAmountSet = { [weak self] tax in
            guard let self = self else { return }
            if let taxValue = Double(tax) {
                self.taxAmount = tax
                self.taxAmountLabel.text = "\(self.formattedTax(taxValue))%"
            } else {
                self.taxAmountLabel.text = "0%"
                self.taxAmount = "0"
            }
        }
        self.navigationController?.present(nextVC, animated: true)
    }
    
    @IBAction func plusDidTapped(_ sender: Any) {
        let nextVC = AddEditShippingChargesViewController.instantiate(fromAppStoryboard: .ShippingPromocode)
        nextVC.commingReason = .add
        nextVC.changesAreDone = {
            self.viewModel.getAllshippingTaxList()
        }
        nextVC.countryId = countryId
        nextVC.shippingInfo = viewModel.shippingTaxDetails?.first
        self.navigationController?.present(nextVC, animated: true)
    }
    
    @IBAction func nextButtonAction(_ sender: Any) {
        guard let total = viewModel.shippingTaxDetails?.count else { return }
        if currentPageIndex + 1 < total {
            currentPageIndex += 1
            shippingTableView.reloadData()
            updatePageLabel()
            updatePaginationButtonImages()
        }
    }
    
    @IBAction func previousButtonAction(_ sender: Any) {
        if currentPageIndex > 0 {
            currentPageIndex -= 1
            shippingTableView.reloadData()
            updatePageLabel()
            updatePaginationButtonImages()
        }
    }
    
    @IBAction func editDefaultDeliveryFeeDidTapped(_ sender: Any) {
        let nextVC = SetDefaultDeliveryfeeViewController.instantiate(fromAppStoryboard: .ShippingPromocode)
        nextVC.countryID = countryId
        nextVC.taxAmount = defaultTaxAmount
        nextVC.taxDefaultAmountSet = { [weak self] tax in
            guard let self = self else { return }
            if let taxValue = Double(tax) {
                self.defaultTaxAmount = tax
                self.defaultDeliveryFeeLabel.text = CommonUtils.formatPrice(taxValue, currency: "KD")
            } else {
                self.defaultDeliveryFeeLabel.text = "0 KD"
                self.defaultTaxAmount = "0"
            }
        }
        self.navigationController?.present(nextVC, animated: true)
    }
    
    //MARK: Function's declaration
    func updatePageLabel() {
        guard let total = viewModel.shippingTaxDetails?.count else { return }
        let totalPages = Int(ceil(Double(total) / Double(itemsPerPage)))
        pageCountLabel.text = String(format: "%02d of %02d", currentPageIndex + 1, totalPages)
    }
    
    private func toggleReasonStatus(at indexPath: IndexPath) {
        guard var shippingInfo = viewModel.shippingTaxDetails?[indexPath.row] else {
            return
        }
        let newStatus = shippingInfo.status == 1 ? 0 : 1
        let params: [String: Any] = ["shipping_charge_id": shippingInfo.id ?? ""]
        viewModel.updateActiveStatus(param: params) { [weak self] success in
            guard let self = self else { return }
            if success {
                shippingInfo.status = newStatus
                self.viewModel.shippingTaxDetails?[indexPath.row] = shippingInfo
                self.shippingTableView.reloadRows(at: [indexPath], with: .automatic)
                if let status = shippingInfo.status {
                    if status == 1 {
                        CommonUtils.showToast(message: "Delivery charge has been unblocked successfully".localiz())
                    } else {
                        CommonUtils.showToast(message: "Delivery charge has been blocked successfully".localiz())
                    }
                }
            }
        }
    }
    
    func populateData() {
        let hasData = (viewModel.shippingTaxDetails?.isEmpty == false)
        noDataFoundLabel.isHidden = hasData
        shippingTableView.isHidden = !hasData
        bottomButtonsView.isHidden = !hasData
        if hasData {
            updatePaginationButtonImages()
            shippingTableView.reloadData()
        }
    }
    
    private func populateCountryData() {
        flagEmojiLabel.text = flag
        countryNameTitleLabel.text = countryName
        
        if let taxString = taxAmount,
           let taxDouble = Double(taxString) {
            taxAmountLabel.text = "\(formattedTax(taxDouble))%"
        } else {
            taxAmountLabel.text = "0%"
        }
    }
    
    
    func updatePaginationButtonImages() {
        guard let total = viewModel.shippingTaxDetails?.count else { return }
        let totalPages = Int(ceil(Double(total) / Double(itemsPerPage)))
        
        previousButton.isUserInteractionEnabled = currentPageIndex > 0
        previousButton.setImage(UIImage(named: currentPageIndex > 0 ? "darkpreviousimage" : "previousLeft"), for: .normal)
        
        nextButton.isUserInteractionEnabled = currentPageIndex < totalPages - 1
        nextButton.setImage(UIImage(named: currentPageIndex < totalPages - 1 ? "nextRight" : "lightnextimage"), for: .normal)
    }
    
    private func formattedTax(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: value)) ?? "0"
    }
    
    
    
}

// MARK: - TABLE VIEW METHODS
extension ShippingChargesAndTaxViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentPageData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShippingFeesTableViewCell", for: indexPath) as! ShippingFeesTableViewCell
        let data = currentPageData[indexPath.row]
        cell.configData(data: data)
        cell.editButton.isHidden = !hasActionPermission
        cell.deleteButton.isHidden = !hasActionPermission
        cell.statusButtonOutlet.isUserInteractionEnabled = hasActionPermission
        cell.onStatusToggle = { [weak self] in
            guard let self = self else { return }
            if let fullIndex = self.viewModel.shippingTaxDetails?.firstIndex(where: { $0.id == data.id }) {
                self.toggleReasonStatus(at: IndexPath(row: fullIndex, section: 0))
            }
        }
        
        cell.onEditTap = { [weak self] in
            guard let self = self else { return }
            let nextVC = AddEditShippingChargesViewController.instantiate(fromAppStoryboard: .ShippingPromocode)
            nextVC.commingReason = .edit
            nextVC.changesAreDone = {
                self.viewModel.getAllshippingTaxList()
            }
            nextVC.shippingInfo = data
            self.navigationController?.present(nextVC, animated: true)
        }
        
        cell.onDeleteTap = { [weak self] in
            guard let self = self else { return }
            self.showConfirmationAlert(msg: "Are you sure you want to delete this Delivery Fee?".localiz()) {
                let param: [String: Any] = ["shipping_charge_id": data.id ?? 0]
                self.viewModel.deleteShippingInfo(param: param)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("")
    }
    
}

extension ShippingChargesAndTaxViewController {
    var currentPageData: [ShippingChargesList] {
        guard let data = viewModel.shippingTaxDetails, !data.isEmpty else { return [] }
        let startIndex = currentPageIndex * itemsPerPage
        let endIndex = min(startIndex + itemsPerPage, data.count)
        guard startIndex < endIndex else { return [] }
        return Array(data[startIndex..<endIndex])
    }
}
