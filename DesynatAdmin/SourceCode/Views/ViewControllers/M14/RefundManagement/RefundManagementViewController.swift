//
//  RefundManagementViewController.swift
//  DesynatAdmin
//
//  Created by  shailendra singh on 27/03/26.
//

import UIKit

class RefundManagementViewController: UIViewController {

    
    @IBOutlet weak var refundTableView: UITableView!{
        didSet{
            refundTableView.registerCellFromNib(cellID: "")
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: - Navigation

    @IBAction func backBtnTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func filterBtnTapped(_ sender: Any) {
        
    }
    
}
