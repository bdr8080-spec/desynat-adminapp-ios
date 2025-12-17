//
//  DriversListViewController.swift
//  DesynatAdmin
//
//  Created by fluper on 17/12/25.
//

import UIKit

class DriversListViewController: UIViewController {
  
  @IBOutlet weak var headerView: UIView!
  @IBOutlet weak var driverTableView: TableViewDynamicHeight! {
    didSet {
      driverTableView.registerCellFromNib(cellID: "DriversListTableViewCell")
    }
  }
  
  var driverIsAssigned: (() -> Void)?
  var selectedIndex: Int = 0
  
  override func viewDidLoad() {
    super.viewDidLoad()
    handleUISetup()
  }
  
  @IBAction func dismissDidTapped(_ sender: Any) {
    self.dismiss(animated: true)
  }
  
  @IBAction func submitDidTapped(_ sender: Any) {
    driverIsAssigned?()
    self.dismiss(animated: true)
  }
  
  private func handleUISetup() {
    headerView.layer.cornerRadius = 24
    headerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    headerView.clipsToBounds = true
  }
  
}

extension DriversListViewController: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 5
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "DriversListTableViewCell", for: indexPath) as! DriversListTableViewCell
    if selectedIndex == indexPath.row {
      cell.selectedImageView.image = UIImage(named: "radioSelected")
    } else {
      cell.selectedImageView.image = UIImage(named: "radioUnselected")
    }
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    selectedIndex = indexPath.row
    driverTableView.reloadData()
  }
  
}
