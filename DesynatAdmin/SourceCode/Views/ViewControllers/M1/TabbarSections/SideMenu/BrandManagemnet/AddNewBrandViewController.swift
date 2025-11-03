//
//  AddNewBrandViewController.swift
//  DesynatAdmin
//
//  Created by Rakhi Kumari on 31/10/25.
//

import UIKit

class AddNewBrandViewController: UIViewController {
    
    @IBOutlet weak var submitTitleLabel: UILabel!
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
        brandNameEnglishTextField.delegate = self
        brandNameArabicTextField.delegate = self
        if isComingForEdit {
            bindData()
            submitTitleLabel.text = "Update"
            titleLabel.text = "Edit Brand Details"
        } else {
            submitTitleLabel.text = "Submit"
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
            guard let compressedImage = image.jpegData(compressionQuality: 0.25),
                          let finalImage = UIImage(data: compressedImage) else {
                        return
                    }
            
            self.viewModel.uploadDocument(file: finalImage, isImage: true) { [weak self] uploadedUrl in
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

extension AddNewBrandViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if string.isEmpty { return true }
        
        if textField == brandNameEnglishTextField {
            // Block spaces
            if string == " " { return false }
            
            // Allow only English alphabets
            let englishPattern = "^[A-Za-z]+$"
            return string.range(of: englishPattern, options: .regularExpression) != nil
        }
        
        if textField == brandNameArabicTextField {
                    
                    // Allowed Arabic Unicode ranges + spaces
                    let allowedSet = CharacterSet(charactersIn: "\u{0600}"..."\u{06FF}")
                        .union(CharacterSet(charactersIn: "\u{0750}"..."\u{077F}"))
                        .union(CharacterSet(charactersIn: "\u{08A0}"..."\u{08FF}"))
                        .union(CharacterSet.whitespaces)
                    
                    // Check every character (handles paste)
                    for scalar in string.unicodeScalars {
                        if !allowedSet.contains(scalar) {
                            CommonUtils.showToast(message: "Please switch to Arabic keyboard")
                            return false
                        }
                    }
                    
                    return true
                }
        
        return true
    }
}
