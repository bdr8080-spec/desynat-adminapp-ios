//
//  ReasonManagementViewController.swift
//  DesynatAdmin
//
//  Created by fluper on 20/11/25.
//

import UIKit

class ReasonManagementViewController: UIViewController {
  
  @IBOutlet weak var reasonTableView: UITableView! {
    didSet {
      reasonTableView.registerCellFromNib(cellID: "ReasonManagementTableViewCell")
    }
  }
  
  @IBOutlet weak var noDataFoundLabel: UILabel!
  @IBOutlet weak var previousButton: UIButton!
  @IBOutlet weak var nextButton: UIButton!
  @IBOutlet weak var pageCountLabel: UILabel!
  @IBOutlet weak var searchTextField: UITextField!
  @IBOutlet weak var exchangeView: CustomView!
  @IBOutlet weak var returnView: CustomView!
  @IBOutlet weak var cancelView: CustomView!
  @IBOutlet weak var exhangeButton: CustomButton!
  @IBOutlet weak var returnButtton: CustomButton!
  @IBOutlet weak var cancelButton: CustomButton!
  @IBOutlet weak var exchnageLabel: UILabel!
  @IBOutlet weak var returnLabel: UILabel!
  @IBOutlet weak var cancelLabel: UILabel!
  
  
  private lazy var viewModel = ReasonManagementViewModel(hostVC: self)
  private var searchWorkItem: DispatchWorkItem?
  var type: Int = 1
  
  override func viewDidLoad() {
    super.viewDidLoad()
    searchTextField.delegate = self
    updatePaginationButtonImages()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    viewModel.currentPage = 1
    viewModel.getAllReasons()
  }
  
  
  @IBAction func backDidTapped(_ sender: Any) {
    self.navigationController?.popViewController(animated: true)
  }
  
  @IBAction func plusDidTapped(_ sender: Any) {
    let vc = AddReasonViewController.instantiate(fromAppStoryboard: .ReasonManagement)
    vc.isComingForEdit = false
    vc.type = type
    vc.onUpdate = { [weak self] in
            self?.viewModel.getAllReasons()
        }
    self.navigationController?.present(vc, animated: false)
  }
  
  @IBAction func nextButtonAction(_ sender: Any) {
    viewModel.goToNextPage(type: type)
  }
  
  @IBAction func previousButtonAction(_ sender: Any) {
    viewModel.goToPreviousPage(type: type)
  }
  
  @IBAction func returnDidTapped(_ sender: Any) {
    exhangeButton.setImage(UIImage(named: ""), for: .normal)
    exchnageLabel.textColor = UIColor.black
    returnButtton.setImage(UIImage(named: "btnGradient"), for: .normal)
    returnLabel.textColor = UIColor.white
    cancelButton.setImage(UIImage(named: ""), for: .normal)
    cancelLabel.textColor = UIColor.black
    type = 2
    viewModel.getAllReasons()
  }
  
  @IBAction func cancelDidTapped(_ sender: Any) {
    exhangeButton.setImage(UIImage(named: ""), for: .normal)
    exchnageLabel.textColor = UIColor.black
    returnButtton.setImage(UIImage(named: ""), for: .normal)
    returnLabel.textColor = UIColor.black
    cancelButton.setImage(UIImage(named: "btnGradient"), for: .normal)
    cancelLabel.textColor = UIColor.white
    type = 3
    viewModel.getAllReasons()
  }
  
  @IBAction func exchangeDidTapped(_ sender: Any) {
    exhangeButton.setImage(UIImage(named: "btnGradient"), for: .normal)
    exchnageLabel.textColor = UIColor.white
    returnButtton.setImage(UIImage(named: ""), for: .normal)
    returnLabel.textColor = UIColor.black
    cancelButton.setImage(UIImage(named: ""), for: .normal)
    cancelLabel.textColor = UIColor.black
    type = 1
    viewModel.getAllReasons()
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
          var category = viewModel.reasonListData[indexPath.row]
          let newStatus = category.status == 1 ? 0 : 1
          let params: [String: Any] = ["reason_id": category.id ?? 0]
          viewModel.updateActiveStatus(param: params) { [weak self] success in
              guard let self = self else { return }
              if success {
                  category.status = newStatus
                  self.viewModel.reasonListData[indexPath.row] = category
                  self.reasonTableView.reloadRows(at: [indexPath], with: .automatic)
                  if let status = category.status {
                      

                    switch type {
                    case 1:
                      if status == 1 {
                          CommonUtils.showToast(message: "Exchange Reason Unblocked Succesfully")
                      } else {
                          CommonUtils.showToast(message: "Exchange Reason Blocked Succesfully")
                      }
                    case 2:
                      if status == 1 {
                          CommonUtils.showToast(message: "Return Reason Unblocked Succesfully")
                      } else {
                          CommonUtils.showToast(message: "Return Reason Blocked Succesfully")
                      }
                    case 3:
                      if status == 1 {
                          CommonUtils.showToast(message: "Cancel Reason Unblocked Succesfully")
                      } else {
                          CommonUtils.showToast(message: "Cancel Reason Blocked Succesfully")
                      }
                    default:
                      if status == 1 {
                          CommonUtils.showToast(message: "Reason Unblocked Succesfully")
                      } else {
                          CommonUtils.showToast(message: "Reason Blocked Succesfully")
                      }
                    }
                  }
              }
          }
  }
  
  
}

extension ReasonManagementViewController: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.reasonListData.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ReasonManagementTableViewCell", for: indexPath) as! ReasonManagementTableViewCell
    let data = viewModel.reasonListData[indexPath.row]
    cell.delegate = self
    cell.configData(data: data)
    cell.onStatusToggle = { [weak self] in
      guard let self = self else { return }
      self.toggleReasonStatus(at: indexPath)
    }
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//    return 100
    return UITableView.automaticDimension
  }
  
//  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//    let vc = AddReasonViewController.instantiate(fromAppStoryboard: .ReasonManagement)
//    vc.isComingForEdit = true
//    vc.reasonId = viewModel.reasonListData[indexPath.row].id
//    vc.reasonForEdit = viewModel.reasonListData[indexPath.row]
//    vc.onUpdate = {
//      self.viewModel.getAllReasons()
//    }
//    self.navigationController?.present(vc, animated: false)
//  }
  
}

extension ReasonManagementViewController: UITextFieldDelegate {
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    let currentText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
    searchWorkItem?.cancel()
    let workItem = DispatchWorkItem { [weak self] in
      guard let self = self else { return }
      self.viewModel.searchText = currentText
      self.viewModel.currentPage = 1
      viewModel.getAllReasons()
    }
    searchWorkItem = workItem
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: workItem)
    return true
  }
}

extension ReasonManagementViewController: ReasonManagementCellDelegate {
  
  func didTapEdit(_ cell: ReasonManagementTableViewCell) {
    guard let indexPath = reasonTableView.indexPath(for: cell) else { return }
    let vc = AddReasonViewController.instantiate(fromAppStoryboard: .ReasonManagement)
    vc.isComingForEdit = true
    vc.reasonId = viewModel.reasonListData[indexPath.row].id
    vc.reasonForEdit = viewModel.reasonListData[indexPath.row]
    vc.onUpdate = {
      self.viewModel.getAllReasons()
    }
    self.navigationController?.present(vc, animated: false)
  }
  
  func didTapDelete(_ cell: ReasonManagementTableViewCell) {
    guard let indexPath = reasonTableView.indexPath(for: cell) else { return }
    let reasonID = viewModel.reasonListData[indexPath.row].id ?? 0
    self.showConfirmationAlert(msg: "Are you sure you want to delete this reason?") { [weak self] in
      guard let self = self else { return }
      let param: [String: Any] = ["reason_id": reasonID]
      viewModel.deleteReason(param: param)
    }
  }
}
