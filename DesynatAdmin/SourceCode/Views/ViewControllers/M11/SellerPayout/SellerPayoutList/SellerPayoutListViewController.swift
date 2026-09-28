//
//  SellerPayoutListViewController.swift
//  DesynatAdmin
//
//  Created by fluper_mac3 on 19/03/26.
//

import UIKit

class SellerPayoutListViewController: UIViewController {
    
    @IBOutlet weak var totalPayoutPendingLabel: UILabel!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var listTableView: UITableView! {
        didSet {
            listTableView.registerCellFromNib(cellID: "SellerPayoutTableViewCell")
        }
    }
    @IBOutlet weak var lblNoData: UILabel!
    
    var hasActionPermission: Bool = false
    lazy private var viewModel = SellerPayoutListViewModel(hostVC: self)
    private var searchWorkItem: DispatchWorkItem?
    var countryId: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtSearch.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
        viewModel.resetPagination()
            viewModel.getSellerPayoutList()
    }
    
    @IBAction func backDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func filterBtnTapped(_ sender: Any) {
        let vc =  SellerPayoutFiltersViewController.instantiate(fromAppStoryboard: .NotificationCMS)
        vc.selectedFilter = viewModel.appliedFilter
            vc.disbaleFutureDateSelection = true
            vc.onApplyFilter = { [weak self] filter in
                guard let self = self else { return }
                self.viewModel.appliedFilter = filter
                self.viewModel.currentPage = 1
                self.viewModel.hasMoreData = true
                self.viewModel.sellerPayoutList.removeAll()
                self.viewModel.getSellerPayoutList()
            }
            vc.onClearFilter = { [weak self] in
                guard let self = self else { return }
                self.viewModel.appliedFilter = SellerPayoutFilterModel()
                self.viewModel.currentPage = 1
                self.viewModel.hasMoreData = true
                self.viewModel.sellerPayoutList.removeAll()
                self.viewModel.getSellerPayoutList()
            }
        self.present(vc, animated: true)
    }
}

extension SellerPayoutListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.sellerPayoutList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SellerPayoutTableViewCell", for: indexPath) as! SellerPayoutTableViewCell
        cell.configData(data: viewModel.sellerPayoutList[indexPath.row])
        cell.onManagePayoutTapped = { [weak self] in
            let nextVC = ManageSellerPayoutViewController.instantiate(fromAppStoryboard: .NotificationCMS)
            self?.navigationController?.pushViewController(nextVC, animated: true)
        }
        return cell
    }
}

extension SellerPayoutListViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
        searchWorkItem?.cancel()
        let workItem = DispatchWorkItem { [weak self] in
            guard let self = self else { return }

            self.viewModel.searchText = currentText
            self.viewModel.resetPagination()
            self.viewModel.getSellerPayoutList()
        }
        searchWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: workItem)
        return true
    }
}
