//
//  BrandManagementViewController.swift
//  DesynatAdmin
//
//  Created by Rakhi Kumari on 31/10/25.
//

import UIKit

class BrandManagementViewController: UIViewController {

    @IBOutlet weak var pageCountLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var brandTableView: UITableView! {
        didSet {
            brandTableView.registerCellFromNib(cellID: "BrandManagementTableViewCell")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func backDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func plusDidTapped(_ sender: Any) {
//        let vc = SubCategoryViewController.instantiate(fromAppStoryboard: .SideMenu)
//        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    @IBAction func nextButtonAction(_ sender: Any) {
        
    }
    
    @IBAction func previousButtonAction(_ sender: Any) {
        
    }
    
    
}

extension BrandManagementViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BrandManagementTableViewCell", for: indexPath) as! BrandManagementTableViewCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 178
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = BrandDetailsViewController.instantiate(fromAppStoryboard: .SideMenu)
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    
}


