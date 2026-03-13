//
//  CMSTermsConditionViewController.swift
//  DesynatAdmin
//
//  Created by fluper_mac3 on 13/03/26.
//

import UIKit

class CMSTermsConditionViewController: UIViewController {
    
    @IBOutlet weak var cmsOptionView: CustomView!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var sellerLabel: UILabel!
    @IBOutlet weak var deliveryBoyLabel: UILabel!
    @IBOutlet weak var deliveryBoyButton: CustomButton!
    @IBOutlet weak var sellerButton: CustomButton!
    @IBOutlet weak var userButton: CustomButton!
    @IBOutlet weak var cmsTableView: UITableView! {
        didSet {
            cmsTableView.registerCellFromNib(cellID: "CMSTableViewCell")
        }
    }
    
    private var cmsArray = ["Return Policy", "About Us", "Cancellation Policy", "Exchange Policy", "FAQs", "Contact Us"]
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func userDidTapped(_ sender: Any) {
        
    }
    
    @IBAction func sellerDidTapped(_ sender: Any) {
        
    }
    
    @IBAction func deliveryboyDidTapped(_ sender: Any) {
        
    }
    
    @IBAction func TermsAndCondition(_ sender: Any) {
        cmsOptionView.isHidden = false
    }
    
    @IBAction func backDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension CMSTermsConditionViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cmsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CMSTableViewCell", for: indexPath) as! CMSTableViewCell
        cell.titleLabel.text = cmsArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("")
    }
}
