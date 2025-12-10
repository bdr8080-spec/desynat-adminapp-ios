//
//  ShippingChargesListViewController.swift
//  DesynatAdmin
//
//  Created by fluper on 09/12/25.
//

import UIKit

class ShippingChargesListViewController: UIViewController {

  @IBOutlet weak var noDataFoundLabel: UILabel!
  @IBOutlet weak var shippingTableView: UITableView! {
    didSet {
      shippingTableView.registerCellFromNib(cellID: "ShippingChargesListTableViewCell")
    }
  }
  private lazy var viewModel = ShippingChargesViewModel(hostVC: self)
  
    override func viewDidLoad() {
        super.viewDidLoad()

    }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    viewModel.getAllshippingTaxList()
  }

  @IBAction func backDidTapped(_ sender: Any) {
    self.navigationController?.popViewController(animated: true)
  }
  
}

extension ShippingChargesListViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.shippingDetails?.count ?? 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ShippingChargesListTableViewCell", for: indexPath) as! ShippingChargesListTableViewCell
    let data = viewModel.shippingDetails?[indexPath.row]
    cell.configData(data: data)
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let nextVC = ShippingChargesAndTaxViewController.instantiate(fromAppStoryboard: .ShippingPromocode)
    nextVC.countryId = viewModel.shippingDetails?[indexPath.row].id
    nextVC.flag = viewModel.shippingDetails?[indexPath.row].flag
    nextVC.countryName = viewModel.shippingDetails?[indexPath.row].name
    nextVC.taxAmount = viewModel.shippingDetails?[indexPath.row].taxInfo?.tax
    self.navigationController?.pushViewController(nextVC, animated: true)
  }
  
  
}
