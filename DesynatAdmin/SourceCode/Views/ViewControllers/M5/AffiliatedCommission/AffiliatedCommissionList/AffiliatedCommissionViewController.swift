//
//  AffiliatedCommissionViewController.swift
//  DesynatAdmin
//
//  Created by fluper on 16/12/25.
//

import UIKit

class AffiliatedCommissionViewController: UIViewController {
    
    // MARK: - IBOutlet's
    @IBOutlet weak var noDataFoundLabel: UILabel!
    @IBOutlet weak var affiliatedTableView: UITableView! {
        didSet {
            affiliatedTableView.registerCellFromNib(cellID: "AffiliatedCommissionTableViewCell")
        }
    }
    
    // MARK: - Property Decalaration
    private lazy var viewModel = AffiliatedCommissionViewModel(hostVC: self)
    var hasActionPermission: Bool = false
    
    // MARK: - View's LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getAffiliatedCommissionByCity()
    }
    
    // MARK: - Button's Action
    @IBAction func backDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: Function's declaration
}

// MARK: - TABLE VIEW METHODS
extension AffiliatedCommissionViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.commissionData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AffiliatedCommissionTableViewCell", for: indexPath) as! AffiliatedCommissionTableViewCell
        let data = viewModel.commissionData[indexPath.row]
        cell.configData(data: data)
        cell.onEditTap = { [weak self] in
            guard let self else { return }
            let nextVC = AffiliatedCommissionSetupViewController.instantiate(fromAppStoryboard: .AffiliatedBannerOrder)
            nextVC.taxAmount = data.affiliateCommissionInfo?.commission ?? ""
            nextVC.taxAmountSet = { tax in
                self.viewModel.updateAffiliatedCommissionByCity(countryId: data.affiliateCommissionInfo?.countryID ?? 0, commission: tax)
            }
            self.navigationController?.present(nextVC, animated: true)
        }
        return cell
    }
    
}
