//
//  CategoryViewController.swift
//  DesynatAdmin
//
//  Created by Rakhi Kumari on 31/10/25.
//

import UIKit

class CategoryViewController: UIViewController {

    @IBOutlet weak var categoryTableView: UITableView! {
        didSet {
            categoryTableView.registerCellFromNib(cellID: "CategoryTableViewCell")
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func backDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }

}

extension CategoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryTableViewCell", for: indexPath) as! CategoryTableViewCell
        if indexPath.row % 2 == 0 {
            cell.leftImageView.isHidden = true
            cell.rightImageView.isHidden = false
            cell.mainContentView.layer.borderColor = UIColor.systemGray5.cgColor
        } else{
            cell.leftImageView.isHidden = false
            cell.rightImageView.isHidden = true
            cell.mainContentView.layer.borderColor = UIColor(named: "darkBrown")?.withAlphaComponent(0.5).cgColor
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = SubCategoryViewController.instantiate(fromAppStoryboard: .SideMenu)
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    
}


