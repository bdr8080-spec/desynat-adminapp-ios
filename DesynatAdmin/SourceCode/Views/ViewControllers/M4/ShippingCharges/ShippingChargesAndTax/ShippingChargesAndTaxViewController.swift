//
//  ShippingChargesAndTaxViewController.swift
//  DesynatAdmin
//
//  Created by fluper on 09/12/25.
//

import UIKit

class ShippingChargesAndTaxViewController: UIViewController {
  
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
  
  var countryId: Int? = 0
  var flag: String? = ""
  var countryName: String? = ""
  private lazy var viewModel = ShippingChargesAndTaxViewModel(hostVC: self)
  private var currentPageIndex = 0
  private var itemsPerPage = 5
  var taxAmount: String? = ""
  
  override func viewDidLoad() {
    super.viewDidLoad()
    viewModel.getAllshippingTaxList()
  }
  
  @IBAction func backDidTapped(_ sender: Any) {
    self.navigationController?.popViewController(animated: true)
  }
  
  @IBAction func editDidTapped(_ sender: Any) {
    let nextVC = SetTaxViewController.instantiate(fromAppStoryboard: .ShippingPromocode)
    nextVC.countryID = countryId
    nextVC.taxAmount = taxAmount
    nextVC.taxAmountSet = {[weak self] tax in
      guard let self else { return }
      taxAmount = tax
      taxAmountLabel.text = "\(taxAmount ?? "0")%"
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
            CommonUtils.showToast(message: "Delivery fee has been unblocked Successfully")
          } else {
            CommonUtils.showToast(message: "Delivery fee has been blocked Successfully")
          }
        }
      }
    }
  }
  
  func populateData() {
    flagEmojiLabel.text = flag//countryInfo?.flag//viewModel.shippingTaxDetails?.first?.countryInfo?.flag
    countryNameTitleLabel.text = countryName//countryInfo?.name//viewModel.shippingTaxDetails?.first?.countryInfo?.name
    taxAmountLabel.text = "\(taxAmount ?? "0")%"
    
    let hasData = (viewModel.shippingTaxDetails?.isEmpty == false)
    
    noDataFoundLabel.isHidden = hasData
    shippingTableView.isHidden = !hasData
    bottomButtonsView.isHidden = !hasData
    
    if hasData {
      updatePaginationButtonImages()
      shippingTableView.reloadData()
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
  
  
}

extension ShippingChargesAndTaxViewController: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return currentPageData.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ShippingFeesTableViewCell", for: indexPath) as! ShippingFeesTableViewCell
    let data = currentPageData[indexPath.row]
    cell.configData(data: data)
    
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
      self.showConfirmationAlert(msg: "Are you sure you want to delete this Delivery Fee?") {
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
