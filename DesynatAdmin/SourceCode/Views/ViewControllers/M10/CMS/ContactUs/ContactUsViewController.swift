//
//  ContactUsViewController.swift
//  DesynatAdmin
//
//  Created by fluper_mac3 on 16/03/26.
//

import UIKit

class ContactUsViewController: UIViewController {
    
    // MARK: - IBOutlet's
    @IBOutlet weak var contactUsTableView: UITableView! {
        didSet {
            contactUsTableView.registerCellFromNib(cellID: "ContactUsTableViewCell")
        }
    }
    
    // MARK: - Property Decalaration
    private lazy var viewModel = ContactUsViewModel(hostVC: self)
    var selectedUserType = 1
    var hasActionPermission: Bool = false
    
    // MARK: - View's LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.getContactUsRequest()
    }
    
    // MARK: - Button's Action
    @IBAction func backDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: Function's declaration
}

// MARK: - TABLE VIEW METHODS
extension ContactUsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactUsTableViewCell", for: indexPath) as! ContactUsTableViewCell
        cell.editButton.isHidden = !hasActionPermission
        switch indexPath.row {
        case 0:
            cell.titleLabel.text = "Support Email Address"
            cell.descriptionLabel.text = viewModel.contactListData?.contentEnglish?.email
            cell.supporttypeImageView.image = .supportEmailIcon
            cell.onEditAction = {
                let nextVC = EditContactUsViewController.instantiate(fromAppStoryboard: .NotificationCMS)
                nextVC.comingReason = .email
                nextVC.contactListData = self.viewModel.contactListData
                self.navigationController?.present(nextVC, animated: true)
            }
        case 1:
            cell.titleLabel.text = "Support Contact Number"
            cell.descriptionLabel.text = viewModel.contactListData?.contentEnglish?.mobile
            cell.supporttypeImageView.image = .supportContact
            cell.onEditAction = {
                let nextVC = EditContactUsViewController.instantiate(fromAppStoryboard: .NotificationCMS)
                nextVC.comingReason = .phoneNumber
                nextVC.contactListData = self.viewModel.contactListData
                self.navigationController?.present(nextVC, animated: true)
            }
        default:
            cell.titleLabel.text = "Support Contact Number"
            cell.descriptionLabel.text = viewModel.contactListData?.contentEnglish?.whatsapp
            cell.supporttypeImageView.image = .whatsappIcon
            cell.onEditAction = {
                let nextVC = EditContactUsViewController.instantiate(fromAppStoryboard: .NotificationCMS)
                nextVC.comingReason = .whatsApp
                nextVC.contactListData = self.viewModel.contactListData
                self.navigationController?.present(nextVC, animated: true)
            }
        }
        return cell
    }
    
}
