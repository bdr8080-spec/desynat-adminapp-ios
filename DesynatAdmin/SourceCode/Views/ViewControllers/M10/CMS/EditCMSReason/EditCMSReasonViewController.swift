//
//  EditCMSReasonViewController.swift
//  DesynatAdmin
//
//  Created by fluper_mac3 on 18/03/26.
//

import UIKit

class EditCMSReasonViewController: UIViewController {
    
    @IBOutlet weak var inputTextView: UITextView!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var headerView: UIView!
    
    var selectedUserType = 1
    var cmsType: CmsArray = .returnPolicy
    private lazy var viewModel = EditCMSReasonViewModel(hostVC: self)
    var comingForArabic: Bool = false
    var changesAreDone: (() -> Void)?
    var termsAndConditonData: CMSTermsConditionDataModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        handleUISetup()
        inputTextView.delegate = self
    }
    
    @IBAction func dismissDidTapepd(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func submitDidTapped(_ sender: Any) {
        guard inputTextView.text != nil else {
            CommonUtils.showToast(message: "Please enter text")
            return
        }
        switch cmsType {
        case .termsAndCondition:
            viewModel.createUpdateTermsRequest()
        case .returnPolicy:
            viewModel.createUpdateReturnRequest()
        case .aboutUs:
            viewModel.createUpdateAboutUsRequest()
        case .cancellationPolicy:
            viewModel.createUpdateCancellationRequest()
        default:
            viewModel.createUpdateExchangePolicyRequest()
        }
    }
    
    //MARK: Function's declaration
    private func handleUISetup() {
        headerView.layer.cornerRadius = 24
        headerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        headerView.clipsToBounds = true
        handleUI()
    }
    
    private func handleUI() {
        switch cmsType {
        case .termsAndCondition:
            titleLabel.text = "Edit Terms & Condition"
        case .returnPolicy:
            titleLabel.text = "Edit Return Policy"
        case .aboutUs:
            titleLabel.text = "Edit About Us"
        case .cancellationPolicy:
            titleLabel.text = "Edit Cancellation Policy"
        default:
            titleLabel.text = "Edit Exchange Policy"
        }
        if comingForArabic {
            headerLabel.text = "Arabic"
            self.inputTextView.text = termsAndConditonData?.contentArabic?.htmlToPlainText() ?? ""
            
        } else {
            headerLabel.text = "English"
            self.inputTextView.text = termsAndConditonData?.contentEnglish?.htmlToPlainText() ?? ""
        }
    }
    
}

//MARK: UITextViewDelegate Methods
//extension EditCMSReasonViewController: UITextViewDelegate {
    
//    func textView(_ textView: UITextView,
//                  shouldChangeTextIn range: NSRange,
//                  replacementText text: String) -> Bool {
//        
//        let currentText = (textView.text as NSString).replacingCharacters(in: range, with: text)
//        var validation: StringValidation?
//        
//        // Allow backspace
//        if text.isEmpty { return true }
//        
//        // MARK: - English Description
//        if comingForArabic == false {
//            if textView == inputTextView {
//                
//                // Prevent starting with space
//                if currentText.hasPrefix(" ") {
//                    return false
//                }
//                
//                // Only limit length
////                return currentText.count <= 500
//                return true
//            }
//        } else {
//            
//            // MARK: - Arabic Description
//            if textView == inputTextView {
//                
//                let allowedSet = CharacterSet(charactersIn: "\u{0600}"..."\u{06FF}")
//                    .union(CharacterSet(charactersIn: "\u{0750}"..."\u{077F}"))
//                    .union(CharacterSet(charactersIn: "\u{08A0}"..."\u{08FF}"))
//                    .union(.whitespacesAndNewlines)
//                
//                for scalar in text.unicodeScalars {
//                    if !allowedSet.contains(scalar) {
//                        CommonUtils.showToast(message: "Please switch to Arabic keyboard")
//                        return false
//                    }
//                }
//                
//                return true
//            }
//        }
//        
//        if let data = validation {
//            return data.validate()
//        } else {
//            return true
//        }
//    }
    
// MARK: UITextViewDelegate Methods
extension EditCMSReasonViewController: UITextViewDelegate {
    
    func textView(_ textView: UITextView,
                  shouldChangeTextIn range: NSRange,
                  replacementText text: String) -> Bool {
        
        if text.isEmpty {           // Allow backspace
            return true
        }
        
        let currentText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        
        // Prevent starting with space
        if currentText.hasPrefix(" ") {
            return false
        }
        
        // Check each Character (this handles combined emojis properly)
        for character in text {
            
            // ✅ Allow ALL Emojis — skip language check
//            if character.isEmoji {
//                continue
//            }
            
            // English Mode
            if !comingForArabic {
                if !isAllowedEnglish(character) {
                    CommonUtils.showToast(message: "Please switch to English keyboard")
                    return false
                }
            }
            // Arabic Mode
            else {
                if !isAllowedArabic(character) {
                    CommonUtils.showToast(message: "Please switch to Arabic keyboard")
                    return false
                }
            }
        }
        
        return true
    }
    
    // MARK: - Helper Functions
    
    private func isAllowedEnglish(_ char: Character) -> Bool {
        let allowedSet = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 .,?!'-()\"&@#$%^*+=:;/\\")
            .union(.whitespacesAndNewlines)
        
        // Check all scalars of the character
        return char.unicodeScalars.allSatisfy { allowedSet.contains($0) }
    }
    
    private func isAllowedArabic(_ char: Character) -> Bool {
        let allowedSet = CharacterSet(charactersIn: "\u{0600}"..."\u{06FF}")
            .union(CharacterSet(charactersIn: "\u{0750}"..."\u{077F}"))
            .union(CharacterSet(charactersIn: "\u{08A0}"..."\u{08FF}"))
            .union(CharacterSet(charactersIn: "\u{FB50}"..."\u{FDFF}"))
            .union(CharacterSet(charactersIn: "\u{FE70}"..."\u{FEFF}"))
            .union(.whitespacesAndNewlines)
        
        return char.unicodeScalars.allSatisfy { allowedSet.contains($0) }
    }
}

// MARK: - Character + Emoji Extension
//extension Character {
//    var isEmoji: Bool {
//        if unicodeScalars.count == 1 {
//            guard let scalar = unicodeScalars.first else { return false }
//            return scalar.properties.isEmoji && scalar.properties.isEmojiPresentation
//        }
//        
//        // For combined emojis (skin tones, families, flags, ZWJ sequences, etc.)
//        return unicodeScalars.contains { $0.properties.isEmoji }
//    }
//}

extension String {
    func htmlToPlainText() -> String {
        // Replace common HTML tags that collapse space
        var cleaned = self
            .replacingOccurrences(of: "<br>", with: "\n", options: .caseInsensitive)
            .replacingOccurrences(of: "<br/>", with: "\n", options: .caseInsensitive)
            .replacingOccurrences(of: "<br />", with: "\n", options: .caseInsensitive)
            .replacingOccurrences(of: "</p><p>", with: "\n\n", options: .caseInsensitive)
            .replacingOccurrences(of: "<p>", with: "\n", options: .caseInsensitive)
            .replacingOccurrences(of: "</p>", with: "\n", options: .caseInsensitive)
        
        // Decode HTML entities
        cleaned = cleaned
            .replacingOccurrences(of: "&nbsp;", with: " ")
            .replacingOccurrences(of: "&amp;", with: "&")
            .replacingOccurrences(of: "&lt;", with: "<")
            .replacingOccurrences(of: "&gt;", with: ">")
        
        return cleaned
    }
}
