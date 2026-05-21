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
    @IBOutlet weak var questionArabicTF: ArabicTextField!
    @IBOutlet weak var answerEnglishTF: UITextField!
    @IBOutlet weak var answerArabicTF: ArabicTextField!
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
            headerLabel.text = "Edit FAQ".localiz()
            buttonTitleLabel.text = "Submit".localiz()
            questionEngTF.text = faqData?.questionEnglish
            questionArabicTF.text = faqData?.questionArabic
            answerEnglishTF.text = faqData?.answerEnglish
            answerArabicTF.text = faqData?.answerArabic
        } else {
            headerLabel.text = "Add FAQ".localiz()
            buttonTitleLabel.text = "Add".localiz()
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
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        
        let currentText = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        
        // Allow backspace
        if string.isEmpty { return true }
        
        // ---------------------------
        // MARK: English TextFields
        // ---------------------------
//        if textField == questionEngTF || textField == answerEnglishTF {
//
//            
//            if !isAllowedEnglish(currentText) {
//                CommonUtils.showToast(message: "Please switch to English keyboard".localiz())
//                return false
//            }
//        }
        
        // ---------------------------
        // MARK: Arabic TextFields
        // ---------------------------
//        if textField == questionArabicTF || textField == answerArabicTF {
//            
//            if !isAllowedArabic(currentText) {
//                CommonUtils.showToast(message: "Please switch to Arabic keyboard".localiz())
//                return false
//            }
//            
//            return true
//        }
        
        return true
    }
    
    private func isAllowedEnglish(_ string: String) -> Bool {
        let allowedSet = CharacterSet(charactersIn:
            "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 .,?!'-()\"&@#$%^*+=:;/\\"
        ).union(.whitespacesAndNewlines)
        
        return string.unicodeScalars.allSatisfy { allowedSet.contains($0) || $0.properties.isEmoji }
    }

    private func isAllowedArabic(_ string: String) -> Bool {
        let allowedSet = CharacterSet(charactersIn: "\u{0600}"..."\u{06FF}")
            .union(CharacterSet(charactersIn: "\u{0750}"..."\u{077F}"))
            .union(CharacterSet(charactersIn: "\u{08A0}"..."\u{08FF}"))
            .union(CharacterSet(charactersIn: "\u{FB50}"..."\u{FDFF}"))
            .union(CharacterSet(charactersIn: "\u{FE70}"..."\u{FEFF}"))
            .union(.whitespacesAndNewlines)
        
        return string.unicodeScalars.allSatisfy { allowedSet.contains($0) || $0.properties.isEmoji }
    }
}

