//
//  AddNewBrandViewController.swift
//  DesynatAdmin
//
//  Created by Rakhi Kumari on 31/10/25.
//

import UIKit

class AddNewBrandViewController: UIViewController {
    
    @IBOutlet weak var brandImageView: CustomImageView!
    @IBOutlet weak var brandNameArabicTextField: UITextField!
    @IBOutlet weak var brandNameEnglishTextField: UITextField!
    @IBOutlet weak var titleLabel: UILabel!
    
    lazy private var viewModel = AddBrandViewModel(hostVC: self)
    var selectedImageUrl: String = ""
    var isComingForEdit: Bool = false
    var brandData: GetBrandDataList?
    var onBrandUpdated: ((GetBrandDataList) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if isComingForEdit {
            bindData()
            titleLabel.text = "Edit Brand Details"
        } else {
            titleLabel.text = "Add New Brand"
        }
    }
    
    @IBAction func backDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func submitDidTapped(_ sender: Any) {
        if viewModel.validFields() {
            if isComingForEdit {
                viewModel.editBrandApi()
            } else {
                viewModel.addBrandApi()
            }
        }
    }
    
    @IBAction func uploadImageDidTapped(_ sender: Any) {
        ImagePickerManager().pickImage(self) { [weak self] image, fileName, url in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.brandImageView.image = image
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
        brandNameEnglishTextField.text = brandData?.nameEnglish
        brandNameArabicTextField.text = brandData?.nameArabic
        if let imageUrlString = brandData?.image,
           let url = URL(string: imageUrlString) {
            brandImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"))
            selectedImageUrl = imageUrlString
        } else {
            brandImageView.image = UIImage(named: "placeholder")
        }
        
    }
    
}
