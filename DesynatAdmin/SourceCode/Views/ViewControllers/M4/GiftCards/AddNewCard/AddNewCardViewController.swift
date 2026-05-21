//
//  AddNewCardViewController.swift
//  DesynatAdmin
//
//  Created by fluper on 09/12/25.
//

import UIKit

class AddNewCardViewController: UIViewController {
    
    // MARK: - IBOutlet's
    @IBOutlet weak var submitTitleLabel: UILabel!
    @IBOutlet weak var cardImageView: CustomImageView!
    @IBOutlet weak var cardNameArabicTextField: ArabicTextField!
    @IBOutlet weak var cardNameEnglishTextField: UITextField!
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: - Property Decalaration
    lazy private var viewModel = AddNewCardViewModel(hostVC: self)
    var selectedImageUrl: String = ""
    var isComingForEdit: Bool = false
    var giftsListData: GiftCardsList?
    var onCardUpdated: ((GiftCardsList) -> Void)?
    
    // MARK: - View's LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        cardNameArabicTextField.delegate = self
        cardNameEnglishTextField.delegate = self
        if isComingForEdit {
            bindData()
            submitTitleLabel.text = "Update".localiz()
            titleLabel.text = "Edit Gift Card Category Details".localiz()
        } else {
            submitTitleLabel.text = "Submit".localiz()
            titleLabel.text = "Add New Gift Card Category".localiz()
        }
    }
    
    // MARK: - Button's Action
    @IBAction func backDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func submitDidTapped(_ sender: Any) {
        if viewModel.validFields() {
            if isComingForEdit {
                viewModel.editCardApi()
            } else {
                viewModel.addCardApi()
            }
        }
    }
    
    @IBAction func uploadImageDidTapped(_ sender: Any) {
        ImagePickerManager().pickImage(self) { [weak self] image, fileName, url in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.cardImageView.image = image
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
        cardNameEnglishTextField.text = giftsListData?.nameEnglish
        cardNameArabicTextField.text = giftsListData?.nameArabic
        if let imageUrlString = giftsListData?.image,
           let url = URL(string: imageUrlString) {
            cardImageView.sd_setImage(with: url, placeholderImage: UIImage(named: ""))
            selectedImageUrl = imageUrlString
        }
        
    }
    
}

//MARK: UITextFieldDelegate Methods
extension AddNewCardViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        var validation: StringValidation?
        
        if string.isEmpty { return true }
        
        if textField == cardNameEnglishTextField {
            if currentText.hasPrefix(" ") {
                return false
            }
            validation = StringValidation(string: currentText, characterCount: 30, validation: .firstName)
        }
        
        if textField == cardNameArabicTextField {
            
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
        
        if let data = validation {
            return data.validate()
        } else {
            return true
        }
    }
}
