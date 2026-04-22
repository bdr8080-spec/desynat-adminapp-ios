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
    
    var ticketType: TiketListType = .newList
    private lazy var viewModel = TicketManagementListViewModel(hostVC: self)
    private var searchWorkItem: DispatchWorkItem?
    var hasActionPermission: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        handleNewAction()
        txtFieldSearch.delegate = self
        updatePaginationButtonImages()
        viewModel.fetchNewTicketsList()
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
        let vc = TicketManagementFilterViewController.instantiate(fromAppStoryboard: .NotificationCMS)
        vc.selectedFilter = viewModel.filter(for: ticketType)
        vc.disbaleFutureDateSelection = true
        vc.onApplyFilter = { [weak self] filter in
            guard let self = self else { return }
            
            self.viewModel.setFilter(filter, for: self.ticketType)
            self.viewModel.currentPage = 1
            
            switch self.ticketType {
            case .newList:
                self.viewModel.fetchNewTicketsList()
            case .ongoingList:
                self.viewModel.fetchOngoingList()
            case .pastList:
                self.viewModel.fetchPastList()
            }
        }
        vc.onClearFilter = { [weak self] in
            guard let self = self else { return }
            
            self.viewModel.setFilter(UserFilterModel(), for: self.ticketType)
            self.viewModel.currentPage = 1
            
            switch self.ticketType {
            case .newList:
                self.viewModel.fetchNewTicketsList()
            case .ongoingList:
                self.viewModel.fetchOngoingList()
            case .pastList:
                self.viewModel.fetchPastList()
            }
        }
        self.navigationController?.present(vc, animated: true)
    }
    
    @IBAction func nextDidTapped(_ sender: Any) {
        viewModel.goToNextPage(type: ticketType)
    }
    
    @IBAction func previousDidTapped(_ sender: Any) {
        viewModel.goToPreviousPage(type: ticketType)
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
        ticketType = .pastList
        txtFieldSearch.text = ""
        viewModel.currentPage = 1
        viewModel.fetchPastList()
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
        ticketType = .ongoingList
        txtFieldSearch.text = ""
        viewModel.currentPage = 1
        viewModel.fetchOngoingList()
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
        ticketType = .newList
        txtFieldSearch.text = ""
        viewModel.currentPage = 1
        viewModel.fetchNewTicketsList()
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
        return viewModel.ticketsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TicketManagementTableViewCell", for: indexPath) as! TicketManagementTableViewCell
        let data = viewModel.ticketsList[indexPath.row]
        cell.configData(data: data, status: ticketType)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = TicketManagementDetailsViewController.instantiate(fromAppStoryboard: .NotificationCMS)
        vc.ticketType = ticketType
        vc.ticketDetails = viewModel.ticketsList[indexPath.row]
        vc.isStatusUpdated = { [weak self] in
            guard let self else { return }
            ticketType = .pastList
            handleRejectAction()
            self.viewModel.currentPage = 1
            switch ticketType {
            case .newList:
                self.viewModel.fetchNewTicketsList()
            case .ongoingList:
                self.viewModel.fetchOngoingList()
            case .pastList:
                self.viewModel.fetchPastList()
            }
        }
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
}

//MARK: UITextFieldDelegate Methods
extension TicketManagementListViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
        searchWorkItem?.cancel()
        let workItem = DispatchWorkItem { [weak self] in
            guard let self = self else { return }
            self.viewModel.searchText = currentText
            self.viewModel.currentPage = 1
            switch ticketType {
            case .newList:
                self.viewModel.fetchNewTicketsList()
            case .ongoingList:
                self.viewModel.fetchOngoingList()
            case .pastList:
                self.viewModel.fetchPastList()
            }
        }
        searchWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: workItem)
        return true
    }
}

