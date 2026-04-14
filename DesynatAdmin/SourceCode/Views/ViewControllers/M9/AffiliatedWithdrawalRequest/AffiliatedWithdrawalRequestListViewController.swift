//
//  AffiliatedWithdrawalRequestListViewController.swift
//  DesynatAdmin
//
//  Created by fluper_mac3 on 25/02/26.
//

import UIKit

class AffiliatedWithdrawalRequestListViewController: UIViewController {
    
    // MARK: - IBOutlet's
    @IBOutlet weak var rejectedLabel: UILabel!
    @IBOutlet weak var rejectedBottomLabel: UILabel!
    @IBOutlet weak var approvedLabel: UILabel!
    @IBOutlet weak var approvedBottomLabel: UILabel!
    @IBOutlet weak var newBottomLabel: UILabel!
    @IBOutlet weak var newLabel: UILabel!
    @IBOutlet weak var noDataFoundLabel: UILabel!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var pageCountLabel: UILabel!
    @IBOutlet weak var listTableView: UITableView! {
        didSet {
            listTableView.registerCellFromNib(cellID: "AffiliatedWithdrawalTableViewCell")
        }
    }
    
    // MARK: - Property Decalaration
    private var searchWorkItem: DispatchWorkItem?
    private lazy var viewModel = AffiliatedWithdrawalRequestListViewModel(hostVC: self)
    var requestType: AffiliatedWithdrawalListType = .newRequest
    
    // MARK: - View's LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        updatePaginationButtonImages()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.currentPage = 1
        switch requestType {
        case .newRequest:
            viewModel.fetchNewAffiliatedUsersList()
        case .approvedRequest:
            viewModel.fetchApprovedAffiliatedUsersList()
        case .rejectedRequest:
            viewModel.fetchRejectedAffiliatedUsersList()
        }
    }
    
    // MARK: - Button's Action
    @IBAction func backDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func newDidTapped(_ sender: Any) {
        requestType = .newRequest
        updateTabUI()
        viewModel.currentPage = 1
        viewModel.fetchNewAffiliatedUsersList()
        listTableView.reloadData()
    }
    
    @IBAction func approvedDidTapped(_ sender: Any) {
        handleApprovedSelection()
    }
    
    @IBAction func rejectedDidTapped(_ sender: Any) {
        handleRejectedSelection()
    }
    
    @IBAction func nextDidTapped(_ sender: Any) {
        viewModel.goToNextPage(type: requestType)
    }
    
    @IBAction func previousDidTapped(_ sender: Any) {
        viewModel.goToPreviousPage(type: requestType)
    }
    
    //MARK: Function's declaration
    func handleApprovedSelection() {
        requestType = .approvedRequest
        updateTabUI()
        viewModel.currentPage = 1
        viewModel.fetchApprovedAffiliatedUsersList()
        listTableView.reloadData()
    }
    
    func handleRejectedSelection() {
        requestType = .rejectedRequest
        updateTabUI()
        viewModel.currentPage = 1
        viewModel.fetchRejectedAffiliatedUsersList()
        listTableView.reloadData()
    }
    
    func updateTabUI() {
        newLabel.textColor = requestType == .newRequest ? .darkBrown : UIColor(hexString: "#C0BBBB")
        newBottomLabel.backgroundColor = requestType == .newRequest ? .darkBrown : UIColor(hexString: "#C0BBBB")
        
        approvedLabel.textColor = requestType == .approvedRequest ? .darkBrown : UIColor(hexString: "#C0BBBB")
        approvedBottomLabel.backgroundColor = requestType == .approvedRequest ? .darkBrown : UIColor(hexString: "#C0BBBB")
        
        rejectedLabel.textColor = requestType == .rejectedRequest ? .darkBrown : UIColor(hexString: "#C0BBBB")
        rejectedBottomLabel.backgroundColor = requestType == .rejectedRequest ? .darkBrown : UIColor(hexString: "#C0BBBB")
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
}

// MARK: - TABLE VIEW METHODS
extension AffiliatedWithdrawalRequestListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.affilitaitedUsersList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AffiliatedWithdrawalTableViewCell", for: indexPath) as! AffiliatedWithdrawalTableViewCell
        let data = viewModel.affilitaitedUsersList[indexPath.row]
        cell.configData(requestType: requestType, data: data)
        cell.onAcceptTap = { [weak self] in
            let param: [String: Any] = ["req_id": data.id ?? 0,
                                        "transaction_id": data.id ?? 0,
                                        "payment_status": 1]
            self?.viewModel.AcceptUserRequest(param: param)
        }
        cell.onRejectTap = {
            let vc = RejectReasonPopupViewController.instantiate(fromAppStoryboard: .LiveStoryDealManagement)
            vc.onChangesAreDone = { reason in
                let param: [String: Any] = ["req_id": data.id ?? 0,
                                            "reject_reason": reason]
                self.viewModel.RejectUserRequest(param: param)
            }
            self.presentVC(vc,withAnimation: false,modalPresentationStyle: .overCurrentContext)
        }
        return cell
    }
    
}

enum AffiliatedWithdrawalListType: Int {
    case newRequest = 1
    case approvedRequest = 2
    case rejectedRequest = 3
}
