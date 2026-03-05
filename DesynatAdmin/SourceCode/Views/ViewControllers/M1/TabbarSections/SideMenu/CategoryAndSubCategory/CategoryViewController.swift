//
//  CategoryViewController.swift
//  DesynatAdmin
//
//  Created by Rakhi Kumari on 31/10/25.
//

import UIKit

class CategoryViewController: UIViewController {
    
    // MARK: - IBOutlet's
    @IBOutlet weak var noDataFoundLabel: UILabel!
    @IBOutlet weak var categoryTableView: UITableView! {
        didSet {
            categoryTableView.registerCellFromNib(cellID: "CategoryTableViewCell")
        }
    }
    
    // MARK: - Property Decalaration
    private lazy var viewModel = CategoryViewModel(hostVC: self)
    
    // MARK: - View's LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getAllCategory()
    }
    
    // MARK: - Button's Action
    @IBAction func backDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
    
    //MARK: Function's declaration
    private func toggleCategoryStatus(at indexPath: IndexPath) {
        var category = viewModel.categoryListData[indexPath.row]
        let newStatus = category.status == 1 ? 0 : 1
        let params: [String: Any] = ["category_id": category.id ?? 0]
        viewModel.upadteCategory(param: params) { [weak self] success in
            guard let self = self else { return }
            if success {
                category.status = newStatus
                self.viewModel.categoryListData[indexPath.row] = category
                self.categoryTableView.reloadRows(at: [indexPath], with: .automatic)
                if let status = category.status {
                    if status == 1 {
                        CommonUtils.showToast(message: "Category has been activated Successfully")
                    } else {
                        CommonUtils.showToast(message: "Category has been Deactivated Successfully")
                    }
                }
            }
        }
    }
}

// MARK: - TABLE VIEW METHODS
extension CategoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.categoryListData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryTableViewCell", for: indexPath) as! CategoryTableViewCell
        let data = viewModel.categoryListData[indexPath.row]
        cell.configData(data: data)
        cell.onStatusToggle = { [weak self] in
            guard let self = self else { return }
            self.toggleCategoryStatus(at: indexPath)
        }
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
        vc.categoryId = "\(viewModel.categoryListData[indexPath.row].id ?? 0)"
        self.navigationController?.pushViewController(vc, animated: false)
    }
}


