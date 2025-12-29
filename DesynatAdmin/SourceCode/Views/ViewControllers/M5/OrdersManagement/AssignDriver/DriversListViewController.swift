//
//  DriversListViewController.swift
//  DesynatAdmin
//
//  Created by fluper on 17/12/25.
//

import UIKit

class DriversListViewController: UIViewController {
  
  @IBOutlet weak var submitstackView: UIStackView!
  @IBOutlet weak var maincontentView: CustomView!
  @IBOutlet weak var dropDownView: UIView!
  @IBOutlet weak var noDriverFoundLabel: CustomLabelFont!
  @IBOutlet weak var separatorLabel: UILabel!
  @IBOutlet weak var headerView: UIView!
  @IBOutlet weak var driverTableView: TableViewDynamicHeight!
  @IBOutlet weak var lblDriverName: UILabel!
  @IBOutlet weak var driverTableHeight: NSLayoutConstraint!
  
  // MARK: - VARIABLES
  let viewModel = OrderManagementListViewModel()
  private var isDriverExpanded = false
  private var selectedIndex: Int? = nil
  var driverIsAssigned: ((_ driverId: Int, _ driver: DeliveryBoyListModel) -> Void)?
  var orderId: Int = 0
  
  override func viewDidLoad() {
    super.viewDidLoad()
    handleUISetup()
    getList()
  }
  
  private func handleUISetup() {
    headerView.layer.cornerRadius = 24
    headerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    headerView.clipsToBounds = true
    
    driverTableView.registerCellFromNib(cellID: "DriversListTableViewCell")
    driverTableView.dataSource = self
    driverTableView.delegate = self
    driverTableView.separatorStyle = .none
    
    driverTableHeight.constant = 0
    separatorLabel.isHidden = true
    driverTableView.isHidden = true
  }
  
  
  func getList() {
    viewModel.getAssignDrivers(orderId: orderId) { [weak self] in
      guard let self = self else { return }
      
      self.driverTableView.reloadData()
      
      let count = self.viewModel.driverList.count
      self.separatorLabel.isHidden = true
      if count == 0 {
        self.maincontentView.isHidden = true
        self.noDriverFoundLabel.isHidden = false
        self.submitstackView.isHidden = true
      } else {
        self.maincontentView.isHidden = false
        self.noDriverFoundLabel.isHidden = true
        self.submitstackView.isHidden = false
        
        // ✅ Default selection (first driver)
        self.selectedIndex = 0
        self.lblDriverName.text = self.viewModel.driverList.first?.fullNameEnglish
      }
    }
  }
  
  
  
  @IBAction func handleDriverSelection(_ sender: Any) {
    isDriverExpanded.toggle()
    
    if isDriverExpanded {
      driverTableView.isHidden = false
      driverTableHeight.constant =
      min(CGFloat(viewModel.driverList.count) * 60, 300)
      separatorLabel.isHidden = false
    } else {
      driverTableHeight.constant = 0
      separatorLabel.isHidden = true
    }
    
    UIView.animate(withDuration: 0.25) {
      self.view.layoutIfNeeded()
    }
  }
  
  @IBAction func submitDidTapped(_ sender: Any) {
    guard let index = selectedIndex else {
      dismiss(animated: true)
      return
    }
    
    let driver = viewModel.driverList[index]
    let driverId = driver.id ?? 0   // safe unwrap
    
    driverIsAssigned?(driverId, driver)
    dismiss(animated: true)
  }
  
  @IBAction func dismissDidTapped(_ sender: Any) {
    dismiss(animated: true)
  }
}


extension DriversListViewController: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.driverList.count
  }
  
  func tableView(_ tableView: UITableView,
                 cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(
      withIdentifier: "DriversListTableViewCell",
      for: indexPath
    ) as! DriversListTableViewCell
    
    let driver = viewModel.driverList[indexPath.row]
    cell.titleLabel.text = driver.fullNameEnglish
    
    if selectedIndex == indexPath.row {
      cell.selectedImageView.image = UIImage(named: "radioSelected")
    } else {
      cell.selectedImageView.image = UIImage(named: "radioUnselected")
    }
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    selectedIndex = indexPath.row
    
    let driver = viewModel.driverList[indexPath.row]
    lblDriverName.text = driver.fullNameEnglish
    
    isDriverExpanded = false
    driverTableHeight.constant = 0
    separatorLabel.isHidden = true
    
    UIView.animate(withDuration: 0.25) {
      self.view.layoutIfNeeded()
    }
    
    tableView.reloadData()
  }
  
  
}

