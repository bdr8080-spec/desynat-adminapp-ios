//
//  SelectUsersForNotificationsViewController.swift
//  DesynatAdmin
//
//  Created by fluper_mac3 on 13/03/26.
//

import UIKit

class SelectUsersForNotificationsViewController: UIViewController {
    
    // MARK: - IBOutlet's
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var heightOfCustomerTableView: NSLayoutConstraint!
    @IBOutlet weak var listTableView: UITableView! {
        didSet{
            listTableView.registerCellFromNib(cellID: "SelectUsersTableViewCell")
        }
    }
    @IBOutlet weak var selectAllButton: UIButton!
    
    // MARK: - Property Decalaration
    private var selectedUserIds: Set<Int> = []
    var onUserSelected: (([Int]) -> Void)?
    var usersCount = 14
    
    // MARK: - View's LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        handleUISetup()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        handleHeightOfCustomerTableView()
    }
    
    // MARK: - Button's Action
    @IBAction func submitDidTapped(_ sender: Any) {
        onUserSelected?(Array(selectedUserIds))
        self.dismiss(animated: true)
    }
    
    @IBAction func selectAllDidTapped(_ sender: Any) {
        if selectedUserIds.count == usersCount {
            selectedUserIds.removeAll()
            selectAllButton.setImage(.unseletedCheckBox, for: .normal)
        } else {
            selectedUserIds = Set(0..<usersCount)
            selectAllButton.setImage(.filledCheckBox, for: .normal)
        }
        
        listTableView.reloadData()
    }
    
    @IBAction func dismissDidTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    //MARK: Function's declaration
    private func handleUISetup() {
        headerView.layer.cornerRadius = 24
        headerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        headerView.clipsToBounds = true
    }
    
    func handleHeightOfCustomerTableView() {
        DispatchQueue.main.async {
            let height = self.listTableView.contentSize.height
            self.heightOfCustomerTableView.constant = min(height, 700)
        }
    }
}

// MARK: - TABLE VIEW METHODS
extension SelectUsersForNotificationsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usersCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectUsersTableViewCell", for: indexPath) as! SelectUsersTableViewCell
        if selectedUserIds.contains(indexPath.row) {
            cell.mainImageView.image = .filledCheckBox
        } else {
            cell.mainImageView.image = .unseletedCheckBox
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectedUserIds.contains(indexPath.row) {
                selectedUserIds.remove(indexPath.row)
            } else {
                selectedUserIds.insert(indexPath.row)
            }

            // Update Select All button state
            if selectedUserIds.count == 14 {
                selectAllButton.setImage(.filledCheckBox, for: .normal)
            } else {
                selectAllButton.setImage(.unseletedCheckBox, for: .normal)
            }

            listTableView.reloadRows(at: [indexPath], with: .none)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        super.viewDidLayoutSubviews()
    }
}
