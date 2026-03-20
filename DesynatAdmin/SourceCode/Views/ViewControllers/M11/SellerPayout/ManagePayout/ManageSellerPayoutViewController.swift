//
//  ManageSellerPayoutViewController.swift
//  DesynatAdmin
//
//  Created by fluper_mac3 on 19/03/26.
//

import UIKit

class ManageSellerPayoutViewController: UIViewController {

    @IBOutlet weak var nextButtonOutlet: UIButton!
    @IBOutlet weak var previousButtonOutlet: UIButton!
    @IBOutlet weak var pageLabel: UILabel!
    @IBOutlet weak var listTableView: UITableView! {
        didSet {
            listTableView.registerCellFromNib(cellID: "ManagePayoutTableViewCell")
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func backDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addPayoutDidTapped(_ sender: Any) {
        let nextVC = AddPayoutAmountViewController.instantiate(fromAppStoryboard: .NotificationCMS)
        nextVC.onSubmit = { [weak self] in
            // Call API Here
        }
        self.navigationController?.present(nextVC, animated: true)
    }
    
    @IBAction func nextDidTapped(_ sender: Any) {
        
    }
    
    @IBAction func previousDidTapped(_ sender: Any) {
        
    }
    
}

extension ManageSellerPayoutViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ManagePayoutTableViewCell", for: indexPath) as! ManagePayoutTableViewCell
        return cell
    }
    
}
