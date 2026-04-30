//
//  AddSubCategoryViewController.swift
//  DesynatAdmin
//
//  Created by Rakhi Kumari on 31/10/25.
//

import UIKit

class AddSubCategoryViewController: UIViewController {
    
    // MARK: - IBOutlet's
    @IBOutlet weak var submitLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subCategoryArabicTextField: UITextField!
    @IBOutlet weak var mainImageView: CustomImageView!
    @IBOutlet weak var subCategoryTextField: UITextField!
    
    // MARK: - Property Decalaration
    var categoryId: String = ""
    lazy private var viewModel = AddSubCategoryViewModel(hostVC: self)
    var selectedImageUrl: String = ""
    var isComingForEdit: Bool = false
    var subCategoryData: GetSubCategoryDataList?
    var onSubCategoryUpdated: ((GetSubCategoryDataList) -> Void)?
    
    // MARK: - View's LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        subCategoryTextField.delegate = self
        subCategoryArabicTextField.delegate = self
        if isComingForEdit {
            bindData()
            submitLabel.text = "Update".localiz()
            titleLabel.text = "Edit Sub-Category".localiz()
        } else {
            submitLabel.text = "Submit".localiz()
            titleLabel.text = "Add Sub-Category".localiz()
        }
    }
    
    // MARK: - Button's Action
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
    
    //MARK: Function's declaration
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

//MARK: UITextFieldDelegate Methods
extension AddSubCategoryViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if string.isEmpty { return true }
        
        if textField == subCategoryTextField {
            // Block spaces
            if string == " " { return false }
            
            // Allow only English alphabets
            let englishPattern = "^[A-Za-z]+$"
            return string.range(of: englishPattern, options: .regularExpression) != nil
        }
        
        if textField == subCategoryArabicTextField {
            
            // Allowed Arabic Unicode ranges + spaces
            let allowedSet = CharacterSet(charactersIn: "\u{0600}"..."\u{06FF}")
                .union(CharacterSet(charactersIn: "\u{0750}"..."\u{077F}"))
                .union(CharacterSet(charactersIn: "\u{08A0}"..."\u{08FF}"))
                .union(CharacterSet.whitespaces)
            
            // Check every character (handles paste)
            for scalar in string.unicodeScalars {
                if !allowedSet.contains(scalar) {
                    CommonUtils.showToast(message: "Please switch to Arabic keyboard".localiz())
                    return false
                }
            }
            
            return true
        }
        
        return true
    }
}
