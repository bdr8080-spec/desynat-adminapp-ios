//
//  SubAdminListViewController.swift
//  DesynatAdmin
//
//  Created by fluper_mac3 on 26/03/26.
//

import UIKit

class SubAdminListViewController: UIViewController {
    
    // MARK: - IBOutlet's
    @IBOutlet weak var inactiveLabel: UILabel!
    @IBOutlet weak var inactiveBottomLabel: UILabel!
    @IBOutlet weak var activeLabel: UILabel!
    @IBOutlet weak var activeBottomLabel: UILabel!
    @IBOutlet weak var allBottomLabel: UILabel!
    @IBOutlet weak var allLabel: UILabel!
    @IBOutlet weak var noDataFoundLabel: UILabel!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var pageCountLabel: UILabel!
    @IBOutlet weak var serachTF: BindableTextField!
    @IBOutlet weak var listTableView: UITableView! {
        didSet {
            listTableView.registerCellFromNib(cellID: "SubAdminTableViewCell")
        }
    }
    @IBOutlet weak var plusButton: UIButton!
    
    // MARK: - Property Decalaration
    private var searchWorkItem: DispatchWorkItem?
    private lazy var viewModel = SubAdminListViewModel(hostVC: self)
    var userType: SubAdminListType = .all
    var hasActionPermission: Bool = false
    
    // MARK: - View's LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        serachTF.delegate = self
        plusButton.isHidden = !hasActionPermission
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.currentPage = 1
        switch userType {
        case .all:
            viewModel.fetchAllSubAdminUsersList()
        case .active:
            viewModel.fetchActiveSubAdminsList()
        case .inactive:
            viewModel.fetchInactiveSubAdminList()
        }
    }
    
    // MARK: - Button's Action
    @IBAction func backDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func exportDidTapped(_ sender: Any) {
        var csv = "Name,Email,Phone,Country,Joined On,Status\n"
        for user in viewModel.subAdminUsersList {
            let name = user.fullName ?? ""
            let email = user.email ?? ""
            let phone = "\(user.countryCode ?? "")-\(user.mobile ?? "")"
            let country = user.countryInfo?.name ?? ""
            let joined = convertISOToDMY(user.createdAt ?? "") ?? ""
            let status: String
            switch userType {
            case .all:
                status = "All"
            case .active:
                status = "Active"
            case .inactive:
                status = "Inactive"
            }
            let row = "\(name),\(email),\(phone),\(country),\(joined),\(status)\n"
            csv.append(row)
        }
        CSVExporter.exportCSV(fileName: "SubAdmins", csvString: csv, vc: self)
    }
    
    @IBAction func allDidTapped(_ sender: Any) {
        userType = .all
        updateTabUI()
        viewModel.currentPage = 1
        viewModel.fetchAllSubAdminUsersList()
    }
    
    @IBAction func activeDidTapped(_ sender: Any) {
        userType = .active
        updateTabUI()
        viewModel.currentPage = 1
        viewModel.fetchActiveSubAdminsList()
    }
    
    @IBAction func inactiveDidTapped(_ sender: Any) {
        userType = .inactive
        updateTabUI()
        viewModel.currentPage = 1
        viewModel.fetchInactiveSubAdminList()
    }
    
    @IBAction func filterDidTapped(_ sender: Any) {
        let vc = AffiliatedUserFilterViewController.instantiate(fromAppStoryboard: .LiveStoryDealManagement)
        vc.selectedFilter = viewModel.filter(for: userType)
        vc.disbaleFutureDateSelection = true
        vc.onApplyFilter = { [weak self] filter in
            guard let self = self else { return }
            self.viewModel.setFilter(filter, for: self.userType)
            self.viewModel.currentPage = 1
            switch self.userType {
            case .all:
                self.viewModel.fetchAllSubAdminUsersList()
            case .active:
                self.viewModel.fetchActiveSubAdminsList()
            case .inactive:
                self.viewModel.fetchInactiveSubAdminList()
            }
        }
        vc.onClearFilter = { [weak self] in
            guard let self = self else { return }
            self.viewModel.setFilter(FullScreenBannerFilterModel(), for: self.userType)
            self.viewModel.currentPage = 1
            switch self.userType {
            case .all:
                self.viewModel.fetchAllSubAdminUsersList()
            case .active:
                self.viewModel.fetchActiveSubAdminsList()
            case .inactive:
                self.viewModel.fetchInactiveSubAdminList()
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
    
    
    @IBAction func addDidTapped(_ sender: Any) {
        let nextVc = AddNewStaffViewController.instantiate(fromAppStoryboard: .NotificationCMS)
        nextVc.comingReason = .addNewStaff
        self.navigationController?.pushViewController(nextVc, animated: true)
    }
    
    //MARK: Function's declaration
    func updateTabUI() {
        allLabel.textColor = userType == .all ? .darkBrown : UIColor(hexString: "#C0BBBB")
        allBottomLabel.backgroundColor = userType == .all ? .darkBrown : UIColor(hexString: "#C0BBBB")
        
        activeLabel.textColor = userType == .active ? .darkBrown : UIColor(hexString: "#C0BBBB")
        activeBottomLabel.backgroundColor = userType == .active ? .darkBrown : UIColor(hexString: "#C0BBBB")
        
        inactiveLabel.textColor = userType == .inactive ? .darkBrown : UIColor(hexString: "#C0BBBB")
        inactiveBottomLabel.backgroundColor = userType == .inactive ? .darkBrown : UIColor(hexString: "#C0BBBB")
        searchWorkItem?.cancel()
        serachTF.text = ""
        viewModel.searchText = ""
    }
    
    func convertISOToDMY(_ isoString: String) -> String? {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        guard let date = isoFormatter.date(from: isoString) else {
            return nil
        }
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "dd/MM/yyyy"
        
        return outputFormatter.string(from: date)
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
extension SubAdminListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.subAdminUsersList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubAdminTableViewCell", for: indexPath) as! SubAdminTableViewCell
        let data = viewModel.subAdminUsersList[indexPath.row]
        cell.configUserData(data: data)
        cell.shareButton.isHidden = !hasActionPermission
        cell.onShareTapped = { [weak self] in
            guard let self else { return }
            viewModel.shareStaffDetails(userId: data.id ?? 0)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nextVC = StaffDetailsViewController.instantiate(fromAppStoryboard: .NotificationCMS)
        nextVC.staffID = viewModel.subAdminUsersList[indexPath.row].id
        nextVC.hasActionPermission = hasActionPermission
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
}

//MARK: UITextFieldDelegate Methods
extension SubAdminListViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
        searchWorkItem?.cancel()
        let workItem = DispatchWorkItem { [weak self] in
            guard let self = self else { return }
            self.viewModel.searchText = currentText
            self.viewModel.currentPage = 1
            switch userType {
            case .all:
                self.viewModel.fetchAllSubAdminUsersList()
            case .active:
                self.viewModel.fetchActiveSubAdminsList()
            case .inactive:
                self.viewModel.fetchInactiveSubAdminList()
            }
        }
        searchWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: workItem)
        return true
    }
}

enum SubAdminListType: Int {
    case all = 1
    case active = 2
    case inactive = 3
}

