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
    private lazy var viewModel = AffiliatedUsersListViewModel(hostVC: self)
    var userType: AffiliatedUsersListType = .newUsers
    
    override func viewDidLoad() {
        super.viewDidLoad()
        serachTF.delegate = self
        updatePaginationButtonImages()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.currentPage = 1
        switch userType {
        case .newUsers:
            viewModel.fetchNewAffiliatedUsersList()
        case .approvedUsers:
            viewModel.fetchApprovedAffiliatedUsersList()
        case .rejectedUsers:
            viewModel.fetchRejectedAffiliatedUsersList()
        }
    }
    
    
    @IBAction func backDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func exportDidTapped(_ sender: Any) {
    }
    
    @IBAction func newDidTapped(_ sender: Any) {
        userType = .newUsers
        updateTabUI()
        viewModel.currentPage = 1
        viewModel.fetchNewAffiliatedUsersList()
    }
    
    @IBAction func approvedDidTapped(_ sender: Any) {
        userType = .approvedUsers
        updateTabUI()
        viewModel.currentPage = 1
        viewModel.fetchApprovedAffiliatedUsersList()
    }
    
    @IBAction func rejectedDidTapped(_ sender: Any) {
        userType = .rejectedUsers
        updateTabUI()
        viewModel.currentPage = 1
        viewModel.fetchRejectedAffiliatedUsersList()
    }
    
    @IBAction func filterDidTapped(_ sender: Any) {
        let vc = AffiliatedUserFilterViewController.instantiate(fromAppStoryboard: .LiveStoryDealManagement)
        vc.selectedFilter = viewModel.filter(for: userType)

        vc.onApplyFilter = { [weak self] filter in
                guard let self = self else { return }

                self.viewModel.setFilter(filter, for: self.userType)
                self.viewModel.currentPage = 1

                switch self.userType {
                case .newUsers:
                    self.viewModel.fetchNewAffiliatedUsersList()
                case .approvedUsers:
                    self.viewModel.fetchApprovedAffiliatedUsersList()
                case .rejectedUsers:
                    self.viewModel.fetchRejectedAffiliatedUsersList()
                }
            }
        vc.onClearFilter = { [weak self] in
                guard let self = self else { return }

                self.viewModel.setFilter(FullScreenBannerFilterModel(), for: self.userType)
                self.viewModel.currentPage = 1

                switch self.userType {
                case .newUsers:
                    self.viewModel.fetchNewAffiliatedUsersList()
                case .approvedUsers:
                    self.viewModel.fetchApprovedAffiliatedUsersList()
                case .rejectedUsers:
                    self.viewModel.fetchRejectedAffiliatedUsersList()
                }
            }
           self.navigationController?.present(vc, animated: true)
    }
    
    @IBAction func nextDidTapped(_ sender: Any) {
        viewModel.goToNextPage(type: userType)
    }
    
    @IBAction func previousDidTapped(_ sender: Any) {
        viewModel.goToPreviousPage(type: userType)
    }
    
    func updateTabUI() {
        newLabel.textColor = userType == .newUsers ? .darkBrown : UIColor(hexString: "#C0BBBB")
        newBottomLabel.backgroundColor = userType == .newUsers ? .darkBrown : UIColor(hexString: "#C0BBBB")
        
        approvedLabel.textColor = userType == .approvedUsers ? .darkBrown : UIColor(hexString: "#C0BBBB")
        approvedBottomLabel.backgroundColor = userType == .approvedUsers ? .darkBrown : UIColor(hexString: "#C0BBBB")
        
        rejectedLabel.textColor = userType == .rejectedUsers ? .darkBrown : UIColor(hexString: "#C0BBBB")
        rejectedBottomLabel.backgroundColor = userType == .rejectedUsers ? .darkBrown : UIColor(hexString: "#C0BBBB")
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

extension AffiliatedUsersListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.affilitaitedUsersList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AffiliatedUsersListTableViewCell", for: indexPath) as! AffiliatedUsersListTableViewCell
        let data = viewModel.affilitaitedUsersList[indexPath.row]
        cell.configData(userType: userType, data: data)
        cell.onAcceptAction = {
            let param: [String: Any] = ["user_id": data.id ?? 0]
            self.viewModel.AcceptUserRequest(param: param)
        }
        cell.onRejectAction = {
            let vc = RejectReasonViewController.viewFromNIB
            vc.needToShowButtonStackView = true
            vc.setCallback { reason,type in
              let param: [String: Any] = ["user_id": data.id ?? 0,
                                          "reject_type": type.paramterValue,
                                          "reject_reason": reason]
              self.viewModel.RejectUserRequest(param: param)
                vc.dismiss(animated: false)
            }
            self.presentVC(vc,withAnimation: false,modalPresentationStyle: .overCurrentContext)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = AffiliatedUserDetailsViewController.instantiate(fromAppStoryboard: .LiveStoryDealManagement)
        vc.userType = userType
        vc.userId = viewModel.affilitaitedUsersList[indexPath.row].id
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
                self.viewModel.fetchNewAffiliatedUsersList()
            case .approvedUsers:
                self.viewModel.fetchApprovedAffiliatedUsersList()
            case .rejectedUsers:
                self.viewModel.fetchRejectedAffiliatedUsersList()
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
