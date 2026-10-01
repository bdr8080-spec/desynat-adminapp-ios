//
//  ManageSellerPayoutViewController.swift
//  DesynatAdmin
//
//  Created by fluper_mac3 on 19/03/26.
//

import UIKit

class ManageSellerPayoutViewController: UIViewController {

    @IBOutlet weak var totalPendingAmountLabel: UILabel!
    @IBOutlet weak var noDataFoundLabel: UILabel!
    @IBOutlet weak var nextButtonOutlet: UIButton!
    @IBOutlet weak var previousButtonOutlet: UIButton!
    @IBOutlet weak var pageLabel: UILabel!
    @IBOutlet weak var listTableView: UITableView! {
        didSet {
            listTableView.registerCellFromNib(cellID: "ManagePayoutTableViewCell")
        }
    }
    
    var payoutDetails: SellerPayoutListDataList?
    private lazy var viewModel = ManageSellerPayoutViewModel(hostVC: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updatePaginationButtonImages()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.currentPage = 1
        viewModel.getSellerPayoutHistory()
    }

    @IBAction func backDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addPayoutDidTapped(_ sender: Any) {
        let nextVC = AddPayoutAmountViewController.instantiate(fromAppStoryboard: .NotificationCMS)
        nextVC.onSubmit = { [weak self] amount in
            let vc = PaymentMethodVC.instantiate(fromAppStoryboard: .NotificationCMS)
            vc.orderId = self?.payoutDetails?.storeInfo?.sellerId ?? 0
            vc.paymentFrom = .sellerPayout
            vc.payAmount = amount
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        self.navigationController?.present(nextVC, animated: true)
    }
    
    @IBAction func nextDidTapped(_ sender: Any) {
        viewModel.goToNextPage()
    }
    
    @IBAction func previousDidTapped(_ sender: Any) {
        viewModel.goToPreviousPage()
    }
    
    func updatePaginationButtonImages() {
        // Previous Button
        if viewModel.currentPage == 1 {
            previousButtonOutlet.setImage(UIImage(named: "previousLeft"), for: .normal)
            previousButtonOutlet.isUserInteractionEnabled = false
        } else {
            previousButtonOutlet.setImage(UIImage(named: "darkpreviousimage"), for: .normal)
            previousButtonOutlet.isUserInteractionEnabled = true
        }
        
        // Next Button
        if viewModel.currentPage >= viewModel.totalPages {
            nextButtonOutlet.setImage(UIImage(named: "lightnextimage"), for: .normal)
            nextButtonOutlet.isUserInteractionEnabled = false
        } else {
            nextButtonOutlet.setImage(UIImage(named: "nextRight"), for: .normal)
            nextButtonOutlet.isUserInteractionEnabled = true
        }
    }
    
}

extension ManageSellerPayoutViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.historyListData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ManagePayoutTableViewCell", for: indexPath) as! ManagePayoutTableViewCell
        let data = viewModel.historyListData[indexPath.row]
        cell.configData(data: data)
        return cell
    }
    
}
