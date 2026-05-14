//
//  ShippingChargesListViewController.swift
//  DesynatAdmin
//
//  Created by fluper on 09/12/25.
//

import UIKit

class ShippingChargesListViewController: UIViewController {
    
    // MARK: - IBOutlet's
    @IBOutlet weak var noDataFoundLabel: UILabel!
    @IBOutlet weak var shippingTableView: UITableView! {
        didSet {
            shippingTableView.registerCellFromNib(cellID: "ShippingChargesListTableViewCell")
        }
    }
    
    // MARK: - Property Decalaration
    private lazy var viewModel = ShippingChargesViewModel(hostVC: self)
    var hasActionPermission: Bool = false
    
    // MARK: - View's LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getAllshippingTaxList()
    }
    
    // MARK: - Button's Action
    @IBAction func backDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: Function's declaration
}

// MARK: - TABLE VIEW METHODS
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
        nextVC.countryName = AppLanguageManager.shared.currentLanguage == .ar ? viewModel.shippingDetails?[indexPath.row].nameAr : viewModel.shippingDetails?[indexPath.row].name
        nextVC.taxAmount = viewModel.shippingDetails?[indexPath.row].taxInfo?.tax
        nextVC.hasActionPermission = hasActionPermission
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
}
