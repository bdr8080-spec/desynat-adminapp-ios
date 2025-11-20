//
//  DeliveryBoyViewController.swift
//  DesynatAdmin
//
//  Created by fluper on 20/11/25.
//

import UIKit

class DeliveryBoyViewController: UIViewController {

  @IBOutlet weak var deliveryTableView: UITableView! {
    didSet {
      deliveryTableView.registerCellFromNib(cellID: "DeliveryBoyTableViewCell")
    }
  }
  @IBOutlet weak var noDataFoundLabel: UILabel!
  @IBOutlet weak var previousButton: UIButton!
  @IBOutlet weak var nextButton: UIButton!
  @IBOutlet weak var pageCountLabel: UILabel!
  @IBOutlet weak var searchTextField: UITextField!
  
  private lazy var viewModel = DeliveryBoyViewModel(hostVC: self)
  private var searchWorkItem: DispatchWorkItem?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    searchTextField.delegate = self
    updatePaginationButtonImages()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    viewModel.currentPage = 1
//    viewModel.getAllReasons()
  }
  
  @IBAction func backDidTapped(_ sender: Any) {
    self.navigationController?.popViewController(animated: true)
  }
  
  @IBAction func plusDidTapped(_ sender: Any) {
//    let vc = AddReasonViewController.instantiate(fromAppStoryboard: .ReasonManagement)
//    vc.isComingForEdit = false
//    self.navigationController?.present(vc, animated: false)
  }
  
  @IBAction func nextButtonAction(_ sender: Any) {
    viewModel.goToNextPage()
  }
  
  @IBAction func previousButtonAction(_ sender: Any) {
    viewModel.goToPreviousPage()
  }
  
  @IBAction func filterDidTapped(_ sender: Any) {
    let vc = DeliveryManagementFilterViewController.instantiate(fromAppStoryboard: .ReasonManagement)
    self.navigationController?.present(vc, animated: false)
  }
  
  
  func updatePaginationButtonImages() {
    // Previous Button
    if viewModel.currentPage == 1 {
      previousButton.setImage(UIImage(named: "previousLeft"), for: .normal)
      previousButton.isUserInteractionEnabled = false
    } else {
      previousButton.setImage(UIImage(named: "darkpreviousimage"), for: .normal)
      previousButton.isUserInteractionEnabled = true
    }
    
    // Next Button
    if viewModel.currentPage >= viewModel.totalPages {
      nextButton.setImage(UIImage(named: "lightnextimage"), for: .normal)
      nextButton.isUserInteractionEnabled = false
    } else {
      nextButton.setImage(UIImage(named: "nextRight"), for: .normal)
      nextButton.isUserInteractionEnabled = true
    }
  }
  
  private func toggleReasonStatus(at indexPath: IndexPath) {
    //      var category = viewModel.reasonListData[indexPath.row]
    //      let newStatus = category.status == 1 ? 0 : 1
    //      let params: [String: Any] = ["category_id": category.id ?? 0]
    //      viewModel.upadteCategory(param: params) { [weak self] success in
    //          guard let self = self else { return }
    //          if success {
    //              category.status = newStatus
    //              self.viewModel.reasonListData[indexPath.row] = category
    //              self.reasonTableView.reloadRows(at: [indexPath], with: .automatic)
    //              if let status = category.status {
    //                  if status == 1 {
    //                      CommonUtils.showToast(message: "Reason has been activated Successfully")
    //                  } else {
    //                      CommonUtils.showToast(message: "Reason has been Deactivated Successfully")
    //                  }
    //              }
    //          }
    //      }
  }

}

extension DeliveryBoyViewController: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 3//viewModel.reasonListData.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ReasonManagementTableViewCell", for: indexPath) as! ReasonManagementTableViewCell
//    let data = viewModel.reasonListData[indexPath.row]
//    cell.delegate = self
//    cell.configData(data: data)
//    cell.onStatusToggle = { [weak self] in
//      guard let self = self else { return }
//      self.toggleReasonStatus(at: indexPath)
//    }
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//    return 100
    return UITableView.automaticDimension
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let vc = AddReasonViewController.instantiate(fromAppStoryboard: .ReasonManagement)
    vc.isComingForEdit = true
    self.navigationController?.present(vc, animated: false)
  }
  
}

extension DeliveryBoyViewController: UITextFieldDelegate {
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    let currentText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
    searchWorkItem?.cancel()
    let workItem = DispatchWorkItem { [weak self] in
      guard let self = self else { return }
      self.viewModel.searchText = currentText
      self.viewModel.currentPage = 1
      self.viewModel.getAllDeliveryBoys()
    }
    searchWorkItem = workItem
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: workItem)
    return true
  }
}

extension DeliveryBoyViewController: DeliveryBoyManagementCellDelegate {
  
  func didTapEdit(_ cell: DeliveryBoyTableViewCell) {
    guard let indexPath = deliveryTableView.indexPath(for: cell) else { return }
    let data = viewModel.boysListData[indexPath.row]
    
    print("Edit tapped for id: \(data.id ?? 0)")
  }
  
  func didTapDelete(_ cell: DeliveryBoyTableViewCell) {
    guard let indexPath = deliveryTableView.indexPath(for: cell) else { return }
    let data = viewModel.boysListData[indexPath.row]
    
    print("Delete tapped for id: \(data.id ?? 0)")
    self.showConfirmationAlert(msg: "Are you sure you want to delete this?") { [weak self] in
      guard let self = self else { return }
      // CALL API
    }
  }
}
