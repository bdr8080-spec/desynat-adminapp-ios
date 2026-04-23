//
//  FAQViewController.swift
//  DesynatAdmin
//
//  Created by fluper_mac3 on 16/03/26.
//

import UIKit

class FAQViewController: UIViewController {
    
    // MARK: - IBOutlet's
    @IBOutlet weak var listTableView: UITableView! {
        didSet {
            listTableView.registerCellFromNib(cellID: "FAQTableViewCell")
        }
    }
    @IBOutlet weak var plusButton: UIButton!
    
    // MARK: - Property Decalaration
    private var selecetdIndex = 0
    private lazy var viewModel = FAQViewModel(hostVC: self)
    var selectedUserType = 1
    var hasActionPermission: Bool = false
    
    // MARK: - View's LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.getFAQRequest()
        plusButton.isHidden = !hasActionPermission
    }
    
    // MARK: - Button's Action
    @IBAction func addDidTapped(_ sender: Any) {
        let nextVC = AddFAQViewController.instantiate(fromAppStoryboard: .NotificationCMS)
        nextVC.isComingForEdit = false
        nextVC.selectedUserType = self.selectedUserType
        nextVC.onChangesAreDone = { [weak self] in
            self?.viewModel.getFAQRequest()
        }
        self.navigationController?.present(nextVC, animated: true)
    }
    
    @IBAction func backDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: Function's declaration
}

// MARK: - TABLE VIEW METHODS
extension FAQViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.faqListData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FAQTableViewCell", for: indexPath) as! FAQTableViewCell
        if selecetdIndex == indexPath.row {
            cell.descriptionView.isHidden = false
            cell.vectorImageView.image = .upwardVector
        } else {
            cell.descriptionView.isHidden = true
            cell.vectorImageView.image = .downVector
        }
        cell.editButton.isHidden = !hasActionPermission
        cell.deleteButton.isHidden = !hasActionPermission
        let data = viewModel.faqListData?[indexPath.row]
        cell.configData(data: data, index: indexPath.row)
        cell.onEditTapped = { [weak self] in
            let nextVC = AddFAQViewController.instantiate(fromAppStoryboard: .NotificationCMS)
            nextVC.isComingForEdit = true
            nextVC.faqData = data
            nextVC.selectedUserType = self?.selectedUserType ?? 1
            nextVC.onChangesAreDone = { [weak self] in
                self?.viewModel.getFAQRequest()
            }
            self?.navigationController?.present(nextVC, animated: true)
        }
        cell.onDeleteTapped = { [weak self] in
            self?.showConfirmationAlert(msg: "Are you sure you want to delete this faq?") { [weak self] in
                guard let self = self else { return }
                viewModel.deleteFAQRequest(id: data?.id ?? 0)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selecetdIndex = indexPath.row
        listTableView.reloadData()
    }
    
}
