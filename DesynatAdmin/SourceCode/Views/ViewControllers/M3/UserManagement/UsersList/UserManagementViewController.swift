//
//  UserManagementViewController.swift
//  DesynatAdmin
//
//  Created by fluper on 21/11/25.
//

import UIKit

class UserManagementViewController: UIViewController {
  
  @IBOutlet weak var userTableView: UITableView! {
    didSet {
      userTableView.registerCellFromNib(cellID: "UserManagementTableViewCell")
    }
  }
  @IBOutlet weak var noDataFoundLabel: UILabel!
  @IBOutlet weak var previousButton: UIButton!
  @IBOutlet weak var nextButton: UIButton!
  @IBOutlet weak var pageCountLabel: UILabel!
  @IBOutlet weak var searchTextField: UITextField!
  
  private lazy var viewModel = UserManagementViewModel(hostVC: self)
  private var searchWorkItem: DispatchWorkItem?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    searchTextField.delegate = self
    updatePaginationButtonImages()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    viewModel.currentPage = 1
    viewModel.getAllUsers()
  }
  
  @IBAction func backDidTapped(_ sender: Any) {
    self.navigationController?.popViewController(animated: true)
  }
  
  @IBAction func nextButtonAction(_ sender: Any) {
    viewModel.goToNextPage()
  }
  
  @IBAction func previousButtonAction(_ sender: Any) {
    viewModel.goToPreviousPage()
  }
  
  @IBAction func filterDidTapped(_ sender: Any) {
    let vc = UserListFilterViewController.instantiate(fromAppStoryboard: .ReasonManagement)
       vc.selectedFilter = viewModel.appliedFilter
       vc.onApplyFilter = { [weak self] filter in
           guard let self = self else { return }
           self.viewModel.appliedFilter = filter
           self.viewModel.currentPage = 1
           self.viewModel.getAllUsers()
       }
       vc.onClearFilter = { [weak self] in
           guard let self = self else { return }
           self.viewModel.appliedFilter = UserFilterModel()
           self.viewModel.currentPage = 1
           self.viewModel.getAllUsers()
       }
       self.navigationController?.present(vc, animated: true)
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
    var user = viewModel.usersListData[indexPath.row]
    let newStatus = user.status == "1" ? "0" : "1"
    let params: [String: Any] = ["user_id": user.id ?? 0]
    viewModel.updateActiveStatus(param: params) { [weak self] success in
      guard let self = self else { return }
      if success {
        user.status = newStatus
        self.viewModel.usersListData[indexPath.row] = user
        self.userTableView.reloadRows(at: [indexPath], with: .automatic)
        if let status = user.status {
          if status == "1" {
            CommonUtils.showToast(message: "User Unblocked Succesfully ")
          } else {
            CommonUtils.showToast(message: "User Blocked Succesfully")
          }
        }
      }
    }
  }
  
  
}

extension UserManagementViewController: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.usersListData.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "UserManagementTableViewCell", for: indexPath) as! UserManagementTableViewCell
    let data = viewModel.usersListData[indexPath.row]
    cell.configData(data: data)
    cell.onStatusToggle = { [weak self] in
      guard let self = self else { return }
      self.toggleReasonStatus(at: indexPath)
    }
    cell.onViewDetails = {[weak self] in
      guard let self = self else { return }
      let vc = UserManagementDetailsViewController.instantiate(fromAppStoryboard: .ReasonManagement)
      vc.userId = viewModel.usersListData[indexPath.row].id
      self.navigationController?.pushViewController(vc, animated: false)
    }
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
  }
  
//  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//    let vc = UserManagementDetailsViewController.instantiate(fromAppStoryboard: .ReasonManagement)
//    vc.userId = viewModel.usersListData[indexPath.row].id
//    self.navigationController?.pushViewController(vc, animated: false)
//  }
  
}

extension UserManagementViewController: UITextFieldDelegate {
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    let currentText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
    searchWorkItem?.cancel()
    let workItem = DispatchWorkItem { [weak self] in
      guard let self = self else { return }
      self.viewModel.searchText = currentText
      self.viewModel.currentPage = 1
      self.viewModel.getAllUsers()
    }
    searchWorkItem = workItem
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: workItem)
    return true
  }
}

