//
//  AddFAQViewModel.swift
//  DesynatAdmin
//
//  Created by fluper_mac3 on 18/03/26.
//

import Foundation

class AddFAQViewModel {
    
    private var hostVC: AddFAQViewController
    
    init(hostVC: AddFAQViewController) {
        self.hostVC = hostVC
    }
    
    func validFields() -> Bool {
        var errorMessage: AlertConstant = .none
        
        //Title
        let titleInEng = String.getString(hostVC.questionEngTF.text)
            .trimmingCharacters(in: .whitespacesAndNewlines)
        
        if errorMessage == .none && titleInEng.isEmpty {
            errorMessage = .enterQuestionInEng
        }
        
        let titleInArabic = String.getString(hostVC.questionArabicTF.text)
            .trimmingCharacters(in: .whitespacesAndNewlines)
        
        if errorMessage == .none && titleInArabic.isEmpty {
            errorMessage = .enterQuestionInArab
        }
        
        //Description
        let descInEng = String.getString(hostVC.answerEnglishTF.text)
            .trimmingCharacters(in: .whitespacesAndNewlines)
        
        if errorMessage == .none && descInEng.isEmpty {
            errorMessage = .enterAnswerInEng
        }
        
        let descInArabic = String.getString(hostVC.answerArabicTF.text)
            .trimmingCharacters(in: .whitespacesAndNewlines)
        
        if errorMessage == .none && descInArabic.isEmpty {
            errorMessage = .enterAnswerInArab
        }
        
        if errorMessage != .none {
            hostVC.showAlert(msg: errorMessage.rawValue.localiz())
            hostVC.view.endEditing(true)
            return false
        }
        
        hostVC.view.endEditing(true)
        return true
    }
    
    func addFAQRequest() {
        let param: [String: Any] = ["type": hostVC.selectedUserType,
                                    "question_english": hostVC.questionEngTF.text?.trimmed() ?? "",
                                    "answer_english": hostVC.answerEnglishTF.text?.trimmed() ?? "",
                                    "question_arabic": hostVC.questionArabicTF.text?.trimmed() ?? "",
                                    "answer_arabic": hostVC.answerArabicTF.text?.trimmed() ?? ""]
        WebService.shared.addFAQService(parameter: param) { [weak self] response in
            guard let self = self else { return }
            CommonUtils.showToast(message: "New FAQ is added successully".localiz())
            self.hostVC.onChangesAreDone?()
            self.hostVC.dismiss(animated: true)
        }
    }

    func updateFAQRequest() {
        let param: [String: Any] = ["faq_id": hostVC.faqData?.id ?? 0, //1-user,2-seller,3-delivery boy
                                    "question_english": hostVC.questionEngTF.text?.trimmed() ?? "",
                                    "answer_english": hostVC.answerEnglishTF.text?.trimmed() ?? "",
                                    "question_arabic": hostVC.questionArabicTF.text?.trimmed() ?? "",
                                    "answer_arabic": hostVC.answerArabicTF.text?.trimmed() ?? ""]
        WebService.shared.updateFAQService(parameter: param) { [weak self] response in
            guard let self = self else { return }
            CommonUtils.showToast(message: "FAQ is updatedd successully".localiz())
            self.hostVC.onChangesAreDone?()
            self.hostVC.dismiss(animated: true)
        }
    }
}
