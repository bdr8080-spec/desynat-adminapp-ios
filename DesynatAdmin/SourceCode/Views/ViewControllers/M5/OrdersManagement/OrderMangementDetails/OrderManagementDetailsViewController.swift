//
//  OrderManagementDetailsViewController.swift
//  DesynatAdmin
//
//  Created by fluper on 17/12/25.
//

import UIKit

class OrderManagementDetailsViewController: UIViewController {

  @IBOutlet weak var assignDriverView: UIView!
  @IBOutlet weak var driverDetailsView: UIView!
  @IBOutlet weak var productTableView: UITableView! {
    didSet {
      productTableView.registerCellFromNib(cellID: "ProductListTableViewCell")
    }
  }
  
    override func viewDidLoad() {
        super.viewDidLoad()
      driverDetailsView.isHidden = true
    }

  @IBAction func backDidTapped(_ sender: Any) {
    self.navigationController?.popViewController(animated: true)
  }
  
  @IBAction func assignDriverDidTapped(_ sender: Any) {
    let nextVC = DriversListViewController.instantiate(fromAppStoryboard: .AffiliatedBannerOrder)
    nextVC.driverIsAssigned = { [weak self] in
      guard let self else { return }
      assignDriverView.isHidden = true
      driverDetailsView.isHidden = false
    }
    self.navigationController?.present(nextVC, animated: true)
  }
  
  @IBAction func editDriverDidTapped(_ sender: Any) {
    let nextVC = DriversListViewController.instantiate(fromAppStoryboard: .AffiliatedBannerOrder)
    nextVC.driverIsAssigned = { [weak self] in
      guard let self else { return }
    }
    self.navigationController?.present(nextVC, animated: true)
  }
  
}

extension OrderManagementDetailsViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 2
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ProductListTableViewCell", for: indexPath) as! ProductListTableViewCell
    return cell
  }
  
  
}
