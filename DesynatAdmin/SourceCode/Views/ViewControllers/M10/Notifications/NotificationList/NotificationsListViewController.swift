//
//  NotificationsListViewController.swift
//  DesynatAdmin
//
//  Created by Geetam   on 09/03/26.
//

import UIKit

class NotificationsListViewController: UIViewController {

    @IBOutlet weak var listTableView: UITableView! {
        didSet {
            // Register a basic cell to avoid empty identifier issues.
            listTableView.registerCellFromNib(cellID: "NotificationsListTableViewCell")
        }
    }

    // Temporary placeholder data; replace with your actual model.
    private var notifications: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Seed some data so the table renders; hook up real data here.
        notifications = ["Welcome", "System update available", "New message received"]
        listTableView.reloadData()
    }

    @IBAction func backDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension NotificationsListViewController: UITableViewDelegate, UITableViewDataSource {

    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationsListTableViewCell", for: indexPath) as! NotificationsListTableViewCell
        return cell
    }

    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Tapped")
    }
}
