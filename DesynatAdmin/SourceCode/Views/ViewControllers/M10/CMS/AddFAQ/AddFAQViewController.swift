//
//  AddFAQViewController.swift
//  DesynatAdmin
//
//  Created by fluper_mac3 on 18/03/26.
//

import UIKit

class AddFAQViewController: UIViewController {
    
    @IBOutlet weak var questionEngTF: UITextField!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var questionArabicTF: UITextField!
    @IBOutlet weak var answerEnglishTF: UITextField!
    @IBOutlet weak var answerArabicTF: UITextField!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var buttonTitleLabel: UILabel!
    
    private lazy var viewModel = AddFAQViewModel(hostVC: self)
    var isComingForEdit: Bool = false
    var selectedUserType = 1
    var faqData: FAQListDataModel?
    var onChangesAreDone: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        handleUISetup()
        questionEngTF.delegate = self
        questionArabicTF.delegate = self
        answerEnglishTF.delegate = self
        answerArabicTF.delegate = self
        if isComingForEdit {
            headerLabel.text = "Edit FAQ"
            buttonTitleLabel.text = "Submit"
            questionEngTF.text = faqData?.questionEnglish
            questionArabicTF.text = faqData?.questionArabic
            answerEnglishTF.text = faqData?.answerEnglish
            answerArabicTF.text = faqData?.answerArabic
        } else {
            headerLabel.text = "Add FAQ"
            buttonTitleLabel.text = "Add"
        }
    }
    
    @IBAction func dismissDidTapepd(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func submitDidTapped(_ sender: Any) {
        if viewModel.validFields() {
            if isComingForEdit {
                viewModel.updateFAQRequest()
            } else {
                viewModel.addFAQRequest()
            }
        }
    }
    
    //MARK: Function's declaration
    private func handleUISetup() {
        headerView.layer.cornerRadius = 24
        headerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        headerView.clipsToBounds = true
    }
    
}

//MARK: UITextFieldDelegate Methods
extension AddFAQViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        var validation: StringValidation?
        
        if string.isEmpty { return true }
        
        if textField == questionEngTF || textField == answerEnglishTF{
            // Prevent starting with space
            if currentText.hasPrefix(" ") {
                return false
            }
            
            // Only limit length
            return currentText.count <= 500
        }
        
        if textField == questionArabicTF || textField == answerArabicTF {
            
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
        
        if let data = validation {
            return data.validate()
        } else {
            return true
        }
    }
}
