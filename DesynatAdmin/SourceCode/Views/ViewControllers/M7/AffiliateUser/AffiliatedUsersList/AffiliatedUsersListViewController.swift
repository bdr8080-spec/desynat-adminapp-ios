//
//  AffiliatedUsersListViewController.swift
//  DesynatAdmin
//
//  Created by fluper on 20/01/26.
//

import UIKit

class AffiliatedUsersListViewController: UIViewController {
    
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
    @IBOutlet weak var serachTF: BindableTextField!
    @IBOutlet weak var listTableView: UITableView! {
        didSet {
            listTableView.registerCellFromNib(cellID: "AffiliatedUsersListTableViewCell")
        }
    }
    
    private var searchWorkItem: DispatchWorkItem?
    private lazy var viewModel = AffiliatedUsersListViewModel()
    var userType: AffiliatedUsersListType = .newUsers
    
    override func viewDidLoad() {
        super.viewDidLoad()
        serachTF.delegate = self
        updatePaginationButtonImages()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.currentPage = 1
        viewModel.fetchAffiliatedUsersList()
    }
    
    
    @IBAction func backDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func exportDidTapped(_ sender: Any) {
    }
    
    @IBAction func newDidTapped(_ sender: Any) {
        userType = .newUsers
        updateTabUI()
        viewModel.fetchAffiliatedUsersList()
        listTableView.reloadData()
    }
    
    @IBAction func approvedDidTapped(_ sender: Any) {
        userType = .approvedUsers
        updateTabUI()
        viewModel.fetchAffiliatedUsersList()
        listTableView.reloadData()
    }
    
    @IBAction func rejectedDidTapped(_ sender: Any) {
        userType = .rejectedUsers
        updateTabUI()
        viewModel.fetchAffiliatedUsersList()
        listTableView.reloadData()
    }
    
    @IBAction func filterDidTapped(_ sender: Any) {
        let vc = PromocodeFilterViewController.instantiate(fromAppStoryboard: .ShippingPromocode)
           vc.selectedFilter = viewModel.appliedFilter
           vc.onApplyFilter = { [weak self] filter in
               guard let self = self else { return }
               self.viewModel.appliedFilter = filter
               self.viewModel.currentPage = 1
               self.viewModel.fetchAffiliatedUsersList()
           }
           vc.onClearFilter = { [weak self] in
               guard let self = self else { return }
               self.viewModel.appliedFilter = UserFilterModel()
               self.viewModel.currentPage = 1
               self.viewModel.fetchAffiliatedUsersList()
           }
           self.navigationController?.present(vc, animated: true)
    }
    
    @IBAction func nextDidTapped(_ sender: Any) {
        viewModel.goToNextPage(type: userType.rawValue)
    }
    
    @IBAction func previousDidTapped(_ sender: Any) {
        viewModel.goToPreviousPage(type: userType.rawValue)
    }
    
    func updateTabUI() {
        newLabel.textColor = userType == .newUsers ? .darkBrown : UIColor(hexString: "#C0BBBB")
        newBottomLabel.backgroundColor = userType == .newUsers ? .darkBrown : UIColor(hexString: "#C0BBBB")
        
        approvedLabel.textColor = userType == .approvedUsers ? .darkBrown : UIColor(hexString: "#C0BBBB")
        approvedBottomLabel.backgroundColor = userType == .approvedUsers ? .darkBrown : UIColor(hexString: "#C0BBBB")
        
        rejectedLabel.textColor = userType == .rejectedUsers ? .darkBrown : UIColor(hexString: "#C0BBBB")
        rejectedBottomLabel.backgroundColor = userType == .rejectedUsers ? .darkBrown : UIColor(hexString: "#C0BBBB")
    }
    
    
    //    func getProductByTab(_ index: Int) -> ProductsList {
    //      switch selectedTab {
    //      case .all:
    //        return viewModel.productsListData!.allProductData![index]
    //      case .active:
    //        return viewModel.productsListData!.activeProduct![index]
    //      case .inactive:
    //        return viewModel.productsListData!.inactiveProduct![index]
    //      }
    //    }
    
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

extension AffiliatedUsersListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AffiliatedUsersListTableViewCell", for: indexPath) as! AffiliatedUsersListTableViewCell
        cell.configData(userType: userType)
        cell.onAcceptAction = {
            let vc = RegisterationSuccessViewController.instantiate(fromAppStoryboard: .Main)
            vc.comingReason = .AffiliateUserManagement
            vc.callBackDismiss = {
                self.viewModel.fetchAffiliatedUsersList()
            }
            self.navigationController?.present(vc, animated: true)
        }
        cell.onRejectAction = {
            let vc = RejectReasonViewController.viewFromNIB
            vc.needToShowButtonStackView = true
            vc.setCallback { reason,type in
//              let param: [String: Any] = ["request_id": data.id ?? 0,
//                                          "reject_reason": reason]
//              self.viewModel.rejectLiveRequest(param: param)
            }
            self.presentVC(vc,withAnimation: false,modalPresentationStyle: .overCurrentContext)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = AffiliatedUserDetailsViewController.instantiate(fromAppStoryboard: .LiveStoryDealManagement)
        vc.userType = userType
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
}

extension AffiliatedUsersListViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
        searchWorkItem?.cancel()
        let workItem = DispatchWorkItem { [weak self] in
            guard let self = self else { return }
            self.viewModel.searchText = currentText
            self.viewModel.currentPage = 1
            switch userType {
            case .newUsers:
                self.viewModel.fetchAffiliatedUsersList()
            case .approvedUsers:
                self.viewModel.fetchAffiliatedUsersList()
            case .rejectedUsers:
                self.viewModel.fetchAffiliatedUsersList()
            }
        }
        searchWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: workItem)
        return true
    }
}

enum AffiliatedUsersListType: Int {
    case newUsers = 1
    case approvedUsers = 2
    case rejectedUsers = 3
}
