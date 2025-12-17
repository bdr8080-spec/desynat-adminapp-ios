//
//  BannersManagementListViewController.swift
//  DesynatAdmin
//
//  Created by fluper on 16/12/25.
//

import UIKit

class BannersManagementListViewController: UIViewController {
  
  @IBOutlet weak var searchTF: UITextField!
  @IBOutlet weak var noDataFoundLabel: UILabel!
  @IBOutlet weak var nowButton: CustomButton!
  @IBOutlet weak var nowLabel: UILabel!
  @IBOutlet weak var approvedButton: CustomButton!
  @IBOutlet weak var approvedLabel: UILabel!
  @IBOutlet weak var rejectedButton: CustomButton!
  @IBOutlet weak var rejectedLabel: UILabel!
  @IBOutlet weak var bannersTableView: UITableView! {
    didSet {
      bannersTableView.registerCellFromNib(cellID: "BannersManagementListTableViewCell")
    }
  }
  
  var type: BannersSelectedListType = .new
  private lazy var viewModel = BannersManagementListViewModel(hostVC: self)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    nowButton.layer.cornerRadius = 5
    nowButton.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
    nowButton.clipsToBounds = true
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    viewModel.getAllBannersList()
  }
  
  @IBAction func nowDidTapped(_ sender: Any) {
    handleNewAction()
    
  }
  
  @IBAction func approveDidTapped(_ sender: Any) {
    handleApproveAction()
  }
  
  @IBAction func rejectedDidTapped(_ sender: Any) {
    handleRejectAction()
  }
  
  @IBAction func backDidTapped(_ sender: Any) {
    self.navigationController?.popViewController(animated: true)
  }
  
  @IBAction func filterDidTapped(_ sender: Any) {
    let vc = BannersMangementFilterViewController.instantiate(fromAppStoryboard: .AffiliatedBannerOrder)
    self.navigationController?.present(vc, animated: true)
  }
  
  private func handleApproveAction() {
    nowButton.setImage(UIImage(named: ""), for: .normal)
    nowButton.layer.cornerRadius = 0
    nowLabel.textColor = UIColor.black
    approvedButton.setImage(UIImage(named: "topTabbar"), for: .normal)
    approvedButton.layer.cornerRadius = 0
    approvedLabel.textColor = UIColor.white
    rejectedButton.setImage(UIImage(named: ""), for: .normal)
    rejectedButton.layer.cornerRadius = 0
    rejectedLabel.textColor = UIColor.black
    type = .approved
    viewModel.getAllBannersList()
  }
  
  private func handleRejectAction() {
    nowButton.setImage(UIImage(named: ""), for: .normal)
    nowButton.layer.cornerRadius = 0
    nowLabel.textColor = UIColor.black
    approvedButton.setImage(UIImage(named: ""), for: .normal)
    approvedLabel.textColor = UIColor.black
    approvedButton.layer.cornerRadius = 0
    rejectedButton.setImage(UIImage(named: "topTabbar"), for: .normal)
    rejectedLabel.textColor = UIColor.white
    rejectedButton.layer.cornerRadius = 5
    rejectedButton.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
    rejectedButton.clipsToBounds = true
    type = .rejected
    viewModel.getAllBannersList()
  }
  
  private func handleNewAction() {
    nowButton.setImage(UIImage(named: "topTabbar"), for: .normal)
    nowButton.layer.cornerRadius = 5
    nowButton.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
    nowButton.clipsToBounds = true
    nowLabel.textColor = UIColor.white
    approvedButton.setImage(UIImage(named: ""), for: .normal)
    approvedButton.layer.cornerRadius = 0
    approvedLabel.textColor = UIColor.black
    rejectedButton.setImage(UIImage(named: ""), for: .normal)
    rejectedButton.layer.cornerRadius = 0
    rejectedLabel.textColor = UIColor.black
    type = .new
    viewModel.getAllBannersList()
    
  }
  
}


extension BannersManagementListViewController: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 4//viewModel.bannersListData.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "BannersManagementListTableViewCell", for: indexPath) as! BannersManagementListTableViewCell
    cell.hideAndShowDetails(for: type)
    cell.rejectAction = { [weak self] in
      guard let self else { return }
      let nextVC = RejectReasonPopupViewController.instantiate(fromAppStoryboard: .AffiliatedBannerOrder)
      nextVC.onChangesAreDone = {
        self.viewModel.getAllBannersList()
      }
      self.navigationController?.present(nextVC, animated: true)
    }
    cell.acceptAction =  {[weak self] in
      guard let self else { return }
      handleApproveAction()
    }
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let nextVC = BannersManagementDetailsViewController.instantiate(fromAppStoryboard: .AffiliatedBannerOrder)
    nextVC.type = type
    self.navigationController?.pushViewController(nextVC, animated: true)
  }
  
}

enum BannersSelectedListType: Int {
  case new = 1
  case approved = 2
  case rejected = 3
}
