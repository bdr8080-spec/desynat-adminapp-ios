//
//  SellerPayoutListViewController.swift
//  DesynatAdmin
//
//  Created by fluper_mac3 on 19/03/26.
//

import UIKit

class SellerPayoutListViewController: UIViewController {

    @IBOutlet weak var listTableView: UITableView! {
        didSet {
            listTableView.registerCellFromNib(cellID: "SellerPayoutTableViewCell")
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func backDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension SellerPayoutListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SellerPayoutTableViewCell", for: indexPath) as! SellerPayoutTableViewCell
        cell.onManagePayoutTapped = { [weak self] in
            let nextVC = ManageSellerPayoutViewController.instantiate(fromAppStoryboard: .NotificationCMS)
            self?.navigationController?.pushViewController(nextVC, animated: true)
        }
        return cell
    }
}
