//
//  NotificationsListViewController.swift
//  DesynatAdmin
//
//  Created by fluper_mac3   on 09/03/26.
//

import UIKit

class NotificationsListViewController: UIViewController {
    
    // MARK: - IBOutlet's
    @IBOutlet weak var listTableView: UITableView! {
        didSet {
            listTableView.registerCellFromNib(cellID: "NotificationsListTableViewCell")
        }
    }
    @IBOutlet weak var pageCountLabel: UILabel!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var noDataFoundLabel: UILabel!
    @IBOutlet weak var serachTF: BindableTextField!
    
    // MARK: - Property Decalaration
    private lazy var viewModel = NotificationsListViewModel(hostVC: self)
    private var searchWorkItem: DispatchWorkItem?
    var hasActionPermission: Bool = false
    
    // MARK: - View's LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        serachTF.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.currentPage = 1
        viewModel.getAllSentNotificationRequest()
    }
    
    // MARK: - Button's Action
    @IBAction func backDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func sendNotificationDidTapped(_ sender: Any) {
        let nextVC = SendNewNotificationViewController.instantiate(fromAppStoryboard: .NotificationCMS)
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @IBAction func nextButtonDidTapped(_ sender: Any) {
        viewModel.goToNextPage()
    }
    
    @IBAction func previousButtonDidTapped(_ sender: Any) {
        viewModel.goToPreviousPage()
    }
    
    @IBAction func filterDidTapped(_ sender: Any) {
        let vc = UserListFilterViewController.instantiate(fromAppStoryboard: .ReasonManagement)
        vc.disbaleFutureDateSelection = true
        vc.selectedFilter = viewModel.appliedFilter
        vc.onApplyFilter = { [weak self] filter in
            guard let self = self else { return }
            self.viewModel.appliedFilter = filter
            viewModel.currentPage = 1
            viewModel.getAllSentNotificationRequest()
        }
        vc.onClearFilter = { [weak self] in
            guard let self = self else { return }
            self.viewModel.appliedFilter = UserFilterModel()
            viewModel.currentPage = 1
            viewModel.getAllSentNotificationRequest()
        }
        self.navigationController?.present(vc, animated: true)
    }
    
    //MARK: Function's declaration
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
extension NotificationsListViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.notificationSentList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationsListTableViewCell", for: indexPath) as! NotificationsListTableViewCell
        let data = viewModel.notificationSentList[indexPath.row]
        cell.configData(data: data)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Tapped")
    }
}

//MARK: UITextFieldDelegate Methods
extension NotificationsListViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
        
        // Cancel previous search work item
        searchWorkItem?.cancel()
        
        // Create new one
        let workItem = DispatchWorkItem { [weak self] in
            guard let self = self else { return }
            self.viewModel.searchText = currentText
            self.viewModel.currentPage = 1
            self.viewModel.getAllSentNotificationRequest()
        }
        
        // Store and execute after delay
        searchWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: workItem)
        
        return true
    }
}
