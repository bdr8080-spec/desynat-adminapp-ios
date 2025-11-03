//
//  SubCatgoryDetailsViewController.swift
//  DesynatAdmin
//
//  Created by Rakhi Kumari on 31/10/25.
//

import UIKit

class SubCatgoryDetailsViewController: UIViewController {
    
    @IBOutlet weak var statusImageView: UIImageView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var statusButton: UIButton!
    @IBOutlet weak var mainImageView: CustomImageView!
    @IBOutlet weak var subCatgeoryLabel: UILabel!
    
    var subCategoryData: GetSubCategoryDataList?
    private lazy var viewModel = SubCatgoryDetailsViewModel(hostVC: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindData()
    }
    
    @IBAction func backDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func editDidTapped(_ sender: Any) {
        let vc = AddSubCategoryViewController.instantiate(fromAppStoryboard: .SideMenu)
        vc.categoryId = "\(subCategoryData?.categoryID ?? 0)"
        vc.isComingForEdit = true
        vc.subCategoryData = subCategoryData
        vc.onSubCategoryUpdated = { [weak self] updatedData in
            guard let self = self else { return }
            self.subCategoryData = updatedData
            self.bindData()
        }
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    @IBAction func deleteDidTapped(_ sender: Any) {
        guard let subCategory = subCategoryData else { return }
        self.showConfirmationAlert(msg: "Are you sure you want to delete this sub-category?"){ [weak self] in
            guard let self = self else { return }
            self.viewModel.deleteSubcategory(param: ["subcategory_id": subCategory.id ?? 0])
        }
    }
    
    @IBAction func activeStatusDidTapped(_ sender: Any) {
        guard let subCategory = subCategoryData else { return }
        viewModel.upadteSubcategory(param: ["subcategory_id": subCategory.id ?? 0])
    }
    
    @IBAction func uploadImageDidTapped(_ sender: Any) {
    }
    
    func bindData() {
        subCatgeoryLabel.text = subCategoryData?.nameEnglish
        if let imageUrlString = subCategoryData?.image,
           let url = URL(string: imageUrlString) {
            mainImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"))
        } else {
            mainImageView.image = UIImage(named: "placeholder")
        }
        
        if subCategoryData?.status == 1 {
            statusLabel.text = "Active"
            statusImageView.image = UIImage(named: "toggleOn")
        } else {
            statusLabel.text = "Inactive"
            statusImageView.image = UIImage(named: "toggleOff")
        }
        
    }
    
}
