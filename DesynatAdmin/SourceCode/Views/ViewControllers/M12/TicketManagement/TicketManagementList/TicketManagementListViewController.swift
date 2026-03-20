//
//  TicketManagementListViewController.swift
//  DesynatAdmin
//
//  Created by fluper_mac3 on 20/03/26.
//

import UIKit

class TicketManagementListViewController: UIViewController {

    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var noDataFoundLabel: UILabel!
    @IBOutlet weak var pageCountLabel: UILabel!
    @IBOutlet weak var txtFieldSearch: BindableTextField!
    @IBOutlet weak var newButton: CustomButton!
    @IBOutlet weak var newLabel: UILabel!
    @IBOutlet weak var ongoingLabel: UILabel!
    @IBOutlet weak var ongoingButton: CustomButton!
    @IBOutlet weak var pastLabel: UILabel!
    @IBOutlet weak var pastButton: CustomButton!
    @IBOutlet weak var listTableView: UITableView! {
        didSet {
            listTableView.registerCellFromNib(cellID: "TicketManagementTableViewCell")
        }
    }
    
    var type: TicketManagementSelectedListType = .new
    private lazy var viewModel = TicketManagementListViewModel(hostVC: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        handleNewAction()
        txtFieldSearch.delegate = self
        updatePaginationButtonImages()
    }

    @IBAction func backDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func newDidTapped(_ sender: Any) {
        handleNewAction()
    }
    
    @IBAction func ongoingDidTapped(_ sender: Any) {
        handleApproveAction()
    }
    
    @IBAction func pastDidTapped(_ sender: Any) {
        handleRejectAction()
    }
    
    @IBAction func filterDidTapped(_ sender: Any) {
        
    }
    
    @IBAction func nextDidTapped(_ sender: Any) {
        
    }
    
    @IBAction func previousDidTapped(_ sender: Any) {
        
    }
    
    private func handleRejectAction() {
        newButton.setImage(UIImage(named: ""), for: .normal)
        newButton.layer.cornerRadius = 0
        newLabel.textColor = UIColor.black
        ongoingButton.setImage(UIImage(named: ""), for: .normal)
        ongoingLabel.textColor = UIColor.black
        ongoingButton.layer.cornerRadius = 0
        pastButton.setImage(UIImage(named: "topTabbar"), for: .normal)
        pastLabel.textColor = UIColor.white
        pastButton.layer.cornerRadius = 5
        pastButton.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        pastButton.clipsToBounds = true
        type = .past
        txtFieldSearch.text = ""
//        viewModel.changeTab(.reject)
    }
    
    private func handleApproveAction() {
        newButton.setImage(UIImage(named: ""), for: .normal)
        newButton.layer.cornerRadius = 0
        newLabel.textColor = UIColor.black
        ongoingButton.setImage(UIImage(named: "topTabbar"), for: .normal)
        ongoingButton.layer.cornerRadius = 0
        ongoingLabel.textColor = UIColor.white
        pastButton.setImage(UIImage(named: ""), for: .normal)
        pastButton.layer.cornerRadius = 0
        pastLabel.textColor = UIColor.black
        type = .ongoing
        txtFieldSearch.text = ""
//        viewModel.changeTab(.approved)
    }
    
    private func handleNewAction() {
        newButton.setImage(UIImage(named: "topTabbar"), for: .normal)
        newButton.layer.cornerRadius = 5
        newButton.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        newButton.clipsToBounds = true
        newLabel.textColor = UIColor.white
        ongoingButton.setImage(UIImage(named: ""), for: .normal)
        ongoingButton.layer.cornerRadius = 0
        ongoingLabel.textColor = UIColor.black
        pastButton.setImage(UIImage(named: ""), for: .normal)
        pastButton.layer.cornerRadius = 0
        pastLabel.textColor = UIColor.black
        type = .new
        txtFieldSearch.text = ""
//        viewModel.changeTab(.new)
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

extension TicketManagementListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TicketManagementTableViewCell", for: indexPath) as! TicketManagementTableViewCell
        return cell
    }
    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return viewModel.affilitaitedUsersList.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "TicketManagementTableViewCell", for: indexPath) as! TicketManagementTableViewCell
//        let data = viewModel.affilitaitedUsersList[indexPath.row]
//        cell.configData(userType: userType, data: data)
//        return cell
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let vc = AffiliatedUserDetailsViewController.instantiate(fromAppStoryboard: .LiveStoryDealManagement)
//        vc.userType = userType
//        vc.userId = viewModel.affilitaitedUsersList[indexPath.row].id
//        self.navigationController?.pushViewController(vc, animated: false)
    }
    
}

//MARK: UITextFieldDelegate Methods
extension TicketManagementListViewController: UITextFieldDelegate {
    
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        let currentText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
//        searchWorkItem?.cancel()
//        let workItem = DispatchWorkItem { [weak self] in
//            guard let self = self else { return }
//            self.viewModel.searchText = currentText
//            self.viewModel.currentPage = 1
//            switch userType {
//            case .newUsers:
//                self.viewModel.fetchNewAffiliatedUsersList()
//            case .approvedUsers:
//                self.viewModel.fetchApprovedAffiliatedUsersList()
//            case .rejectedUsers:
//                self.viewModel.fetchRejectedAffiliatedUsersList()
//            }
//        }
//        searchWorkItem = workItem
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: workItem)
//        return true
//    }
}

enum TicketManagementSelectedListType {
    case new
    case ongoing
    case past
}
