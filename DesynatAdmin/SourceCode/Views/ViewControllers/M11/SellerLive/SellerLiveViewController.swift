//
//  SellerLiveViewController.swift
//  DesynatAdmin
//
//  Created by fluper_mac3 on 20/03/26.
//

import UIKit

class SellerLiveViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func backDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

}
