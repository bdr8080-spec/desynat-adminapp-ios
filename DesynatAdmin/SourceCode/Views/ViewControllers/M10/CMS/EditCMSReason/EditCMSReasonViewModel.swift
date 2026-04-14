//
//  EditCMSReasonViewModel.swift
//  DesynatAdmin
//
//  Created by fluper_mac3 on 18/03/26.
//

import Foundation

class EditCMSReasonViewModel {
    
    private var hostVC: EditCMSReasonViewController
    
    init(hostVC: EditCMSReasonViewController) {
        self.hostVC = hostVC
    }
    
    func createUpdateTermsRequest() {
        var param: [String: Any] = ["type": hostVC.selectedUserType]
        if hostVC.comingForArabic {
            param["content_arabic"] = hostVC.inputTextView.text.trimmed()
            param["content_english"] = hostVC.termsAndConditonData?.contentEnglish
        } else {
            param["content_english"] = hostVC.inputTextView.text.trimmed()
            param["content_arabic"] = hostVC.termsAndConditonData?.contentArabic
        }
        WebService.shared.createUpdateTermsServices(parameter: param) { [weak self] response in
            guard let self = self else { return }
            self.hostVC.changesAreDone?()
            self.hostVC.dismiss(animated: true)
        }
    }
    
    func createUpdateReturnRequest() {
        var param: [String: Any] = ["type": hostVC.selectedUserType]
        if hostVC.comingForArabic {
            param["content_arabic"] = hostVC.inputTextView.text.trimmed()
            param["content_english"] = hostVC.termsAndConditonData?.contentEnglish
        } else {
            param["content_english"] = hostVC.inputTextView.text.trimmed()
            param["content_arabic"] = hostVC.termsAndConditonData?.contentArabic
        }
        WebService.shared.createUpdateReturnServices(parameter: param) { [weak self] response in
            guard let self = self else { return }
            self.hostVC.changesAreDone?()
            self.hostVC.dismiss(animated: true)
        }
    }
    
    func createUpdateAboutUsRequest() {
        var param: [String: Any] = ["type": hostVC.selectedUserType]
        if hostVC.comingForArabic {
            param["content_arabic"] = hostVC.inputTextView.text.trimmed()
            param["content_english"] = hostVC.termsAndConditonData?.contentEnglish
        } else {
            param["content_english"] = hostVC.inputTextView.text.trimmed()
            param["content_arabic"] = hostVC.termsAndConditonData?.contentArabic
        }
        WebService.shared.createUpdateAboutUsServices(parameter: param) { [weak self] response in
            guard let self = self else { return }
            self.hostVC.changesAreDone?()
            self.hostVC.dismiss(animated: true)
        }
    }
    
    func createUpdateCancellationRequest() {
        var param: [String: Any] = ["type": hostVC.selectedUserType]
        if hostVC.comingForArabic {
            param["content_arabic"] = hostVC.inputTextView.text.trimmed()
            param["content_english"] = hostVC.termsAndConditonData?.contentEnglish
        } else {
            param["content_english"] = hostVC.inputTextView.text.trimmed()
            param["content_arabic"] = hostVC.termsAndConditonData?.contentArabic
        }
        WebService.shared.createUpdateCancellationServices(parameter: param) { [weak self] response in
            guard let self = self else { return }
            self.hostVC.changesAreDone?()
            self.hostVC.dismiss(animated: true)
        }
    }
    
    func createUpdateExchangePolicyRequest() {
        var param: [String: Any] = ["type": hostVC.selectedUserType]
        if hostVC.comingForArabic {
            param["content_arabic"] = hostVC.inputTextView.text.trimmed()
            param["content_english"] = hostVC.termsAndConditonData?.contentEnglish
        } else {
            param["content_english"] = hostVC.inputTextView.text.trimmed()
            param["content_arabic"] = hostVC.termsAndConditonData?.contentArabic
        }
        WebService.shared.createUpdateExchangePolicyServices(parameter: param) { [weak self] response in
            guard let self = self else { return }
            self.hostVC.changesAreDone?()
            self.hostVC.dismiss(animated: true)
        }
    }
    
}
