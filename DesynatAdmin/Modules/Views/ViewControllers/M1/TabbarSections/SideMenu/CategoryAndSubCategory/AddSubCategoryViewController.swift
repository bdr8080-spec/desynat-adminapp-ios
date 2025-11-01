//
//  AddSubCategoryViewController.swift
//  DesynatAdmin
//
//  Created by Rakhi Kumari on 31/10/25.
//

import UIKit

class AddSubCategoryViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subCategoryArabicTextField: UITextField!
    @IBOutlet weak var mainImageView: CustomImageView!
    @IBOutlet weak var subCategoryTextField: UITextField!
    
    var categoryId: String = ""
    lazy private var viewModel = AddSubCategoryViewModel(hostVC: self)
    var selectedImageUrl: String = ""
    var isComingForEdit: Bool = false
    var subCategoryData: GetSubCategoryDataList?
    var onSubCategoryUpdated: ((GetSubCategoryDataList) -> Void)?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        if isComingForEdit {
            bindData()
            titleLabel.text = "Edit Sub-Category"
        } else {
            titleLabel.text = "Add Sub-Category"
        }
    }
    
    @IBAction func backDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func submitDidTapped(_ sender: Any) {
        if viewModel.validFields() {
            if isComingForEdit {
                viewModel.editSubCategoryApi()
            } else {
                viewModel.addSubCategoryApi()
            }
        }
    }
    
    @IBAction func uploadImageDidTapped(_ sender: Any) {
        ImagePickerManager().pickImage(self) { [weak self] image, fileName, url in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.mainImageView.image = image
            }
            self.viewModel.uploadDocument(file: image, isImage: true) { [weak self] uploadedUrl in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.selectedImageUrl = uploadedUrl
                }
            }
        }
    }
    
    func bindData() {
        subCategoryTextField.text = subCategoryData?.nameEnglish
        subCategoryArabicTextField.text = subCategoryData?.nameArabic
        if let imageUrlString = subCategoryData?.image,
           let url = URL(string: imageUrlString) {
            mainImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"))
            selectedImageUrl = imageUrlString
        } else {
            mainImageView.image = UIImage(named: "placeholder")
        }
        
    }
    
}
