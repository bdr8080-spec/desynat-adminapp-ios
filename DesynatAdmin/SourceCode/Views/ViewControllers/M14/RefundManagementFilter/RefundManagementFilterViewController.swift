//
//  RefundManagementFilterViewController.swift
//  DesynatAdmin
//
//  Created by  shailendra singh on 30/03/26.
//

import UIKit

class RefundManagementFilterViewController: UIViewController {
    @IBOutlet weak var headerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        handleUISetup()
        // Do any additional setup after loading the view.
    }

    // MARK: - Navigation

    @IBAction func crossBtn(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    private func handleUISetup() {
        headerView.layer.cornerRadius = 24
        headerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        headerView.clipsToBounds = true
       // setUpTextFields()
    }
    

}
