//
//  NotificationsListViewController.swift
//  DesynatAdmin
//
//  Created by Geetam   on 09/03/26.
//

import UIKit

class NotificationsListViewController: UIViewController {
    
    // MARK: - IBOutlet's
    @IBOutlet weak var listTableView: UITableView! {
        didSet {
            listTableView.registerCellFromNib(cellID: "NotificationsListTableViewCell")
        }
    }
    
    // MARK: - Property Decalaration
    private var notifications: [String] = []
    
    // MARK: - View's LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        notifications = ["Welcome", "System update available", "New message received"]
        listTableView.reloadData()
    }
    
    // MARK: - Button's Action
    @IBAction func backDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func sendNotificationDidTapped(_ sender: Any) {
        let nextVC = SendNewNotificationViewController.instantiate(fromAppStoryboard: .NotificationCMS)
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    //MARK: Function's declaration
}

// MARK: - TABLE VIEW METHODS
extension NotificationsListViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationsListTableViewCell", for: indexPath) as! NotificationsListTableViewCell
        if indexPath.row == 1 {
            cell.mainImageView.image = .selectedBellIcon
        } else {
            cell.mainImageView.image = .unselectedBellIcon
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Tapped")
    }
}
