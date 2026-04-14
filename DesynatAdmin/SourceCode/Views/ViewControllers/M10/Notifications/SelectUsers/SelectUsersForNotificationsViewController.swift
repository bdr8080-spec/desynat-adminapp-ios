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
    @IBOutlet weak var selectAllImageView: UIImageView!
    
    // MARK: - Property Decalaration
    private var selectedUserIds: Set<Int> = []
    var onUserSelected: (([SelectableUser]) -> Void)?
    var usersList: [SelectableUser] = []
    var preselectedUserIds: Set<Int> = []
    var isComingWhenAllUserIsSelected: Bool = false
    
    // MARK: - View's LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        handleUISetup()
        selectedUserIds = preselectedUserIds
        
        updateSelectAllState() // important
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        handleHeightOfCustomerTableView()
    }
    
    // MARK: - Button's Action
    @IBAction func submitDidTapped(_ sender: Any) {
        let selectedUsers = usersList.filter {
            selectedUserIds.contains($0.id)
        }
        onUserSelected?(selectedUsers)
        self.dismiss(animated: true)
    }
    
    @IBAction func selectAllDidTapped(_ sender: Any) {
//        if selectedUserIds.count == usersList.count {
//               selectedUserIds.removeAll()
//           } else {
//               selectedUserIds = Set(usersList.map { $0.id })
//           }
//           
//           listTableView.reloadData()   // 🔥 first reload
//           updateSelectAllState()
        
        let allIds = Set(usersList.map { $0.id })
            
            if selectedUserIds == allIds {
                selectedUserIds.removeAll()
            } else {
                selectedUserIds = allIds
            }
            
            listTableView.reloadData()
            updateSelectAllState()
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
    
    private func updateSelectAllState() {
        let allIds = Set(usersList.map { $0.id })
        
        if !usersList.isEmpty && selectedUserIds == allIds {
            selectAllImageView.image = .filledCheckBox
        } else {
            selectAllImageView.image = .unseletedCheckBox
        }
    }
    
//    private func updateSelectAllState() {
//        if isComingWhenAllUserIsSelected {
//            
//        }
//        DispatchQueue.main.async {
//            if !self.usersList.isEmpty && self.selectedUserIds.count == self.usersList.count {
//                self.selectAllImageView.image = .filledCheckBox
//            } else {
//                self.selectAllImageView.image = .unseletedCheckBox
//            }
//        }
//    }
    
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
        return usersList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectUsersTableViewCell", for: indexPath) as! SelectUsersTableViewCell
        let user = usersList[indexPath.row]
        cell.titleLabel.text = user.name
        if selectedUserIds.contains(user.id) {
            cell.mainImageView.image = .filledCheckBox
        } else {
            cell.mainImageView.image = .unseletedCheckBox
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = usersList[indexPath.row]
        
        if selectedUserIds.contains(user.id) {
            selectedUserIds.remove(user.id)
        } else {
            selectedUserIds.insert(user.id)
        }
        
        updateSelectAllState() // 🔥 important
        
        tableView.reloadRows(at: [indexPath], with: .none)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        super.viewDidLayoutSubviews()
    }
}
