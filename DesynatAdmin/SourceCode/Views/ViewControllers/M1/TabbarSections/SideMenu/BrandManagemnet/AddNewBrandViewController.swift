//
//  AddNewBrandViewController.swift
//  DesynatAdmin
//
//  Created by Rakhi Kumari on 31/10/25.
//

import UIKit

class AddNewBrandViewController: UIViewController {
    
    // MARK: - IBOutlet's
    @IBOutlet weak var submitTitleLabel: UILabel!
    @IBOutlet weak var brandImageView: CustomImageView!
    @IBOutlet weak var brandNameArabicTextField: ArabicTextField!
    @IBOutlet weak var brandNameEnglishTextField: UITextField!
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: - Property Decalaration
    lazy private var viewModel = AddBrandViewModel(hostVC: self)
    var selectedImageUrl: String = ""
    var isComingForEdit: Bool = false
    var brandData: GetBrandDataList?
    var onBrandUpdated: ((GetBrandDataList) -> Void)?
    
    // MARK: - View's LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        brandNameEnglishTextField.delegate = self
        brandNameArabicTextField.delegate = self
        if isComingForEdit {
            bindData()
            submitTitleLabel.text = "Update".localiz()
            titleLabel.text = "Edit Brand Details".localiz()
        } else {
            submitTitleLabel.text = "Submit".localiz()
            titleLabel.text = "Add New Brand".localiz()
        }
    }
    
    // MARK: - Button's Action
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
    
    //MARK: Function's declaration
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

//MARK: UITextFieldDelegate Methods
extension AddNewBrandViewController: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        guard let text = textField.text else { return true }

        let currentText = (text as NSString).replacingCharacters(in: range, with: string)

        // Allow Backspace
        if string.isEmpty {
            return true
        }

        // Prevent first character as space
        if currentText.hasPrefix(" ") {
            return false
        }

        // Maximum 30 characters
        if currentText.count > 30 {
            return false
        }

        // MARK: English Brand Name
        if textField == brandNameEnglishTextField {

            let allowedSet = CharacterSet.letters
                .union(.decimalDigits)
                .union(.whitespaces)

            for scalar in string.unicodeScalars {
                if !allowedSet.contains(scalar) {
                    return false
                }
            }

            return true
        }

        // MARK: Arabic Brand Name
        if textField == brandNameArabicTextField {

            let allowedSet = CharacterSet(charactersIn: "\u{0600}"..."\u{06FF}")
                .union(CharacterSet(charactersIn: "\u{0750}"..."\u{077F}"))
                .union(CharacterSet(charactersIn: "\u{08A0}"..."\u{08FF}"))
                .union(.decimalDigits)
                .union(.whitespaces)

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
