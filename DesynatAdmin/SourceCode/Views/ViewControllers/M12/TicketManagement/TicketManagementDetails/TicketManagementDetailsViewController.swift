//
//  TicketManagementDetailsViewController.swift
//  DesynatAdmin
//
//  Created by fluper_mac3 on 26/03/26.
//

import UIKit

class TicketManagementDetailsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func backDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

}
