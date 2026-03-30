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
            refundTableView.registerCellFromNib(cellID: "RefundManagementTableViewCell")
        }
    }
    
    var expandedIndex: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Navigation
    
    @IBAction func backBtnTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func filterBtnTapped(_ sender: Any) {
        let vc =  RefundManagementFilterViewController.instantiate(fromAppStoryboard: .NotificationCMS)
        self.present(vc, animated: true)
        
    }
    
}
extension RefundManagementViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RefundManagementTableViewCell", for: indexPath) as! RefundManagementTableViewCell
        let isExpanded = expandedIndex == indexPath
        cell.configure(isExpanded: isExpanded)
        cell.isViewMore = {
            if self.expandedIndex == indexPath {
                self.expandedIndex = nil
            } else {
                self.expandedIndex = indexPath
            }
            
            self.refundTableView.reloadData()
        }
        return cell
    }
}
