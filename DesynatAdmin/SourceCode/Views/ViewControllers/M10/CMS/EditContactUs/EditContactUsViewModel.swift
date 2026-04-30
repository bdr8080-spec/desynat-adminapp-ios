//
//  EditContactUsViewModel.swift
//  DesynatAdmin
//
//  Created by fluper_mac3 on 18/03/26.
//

import Foundation

class EditContactUsViewModel {
    
    private var hostVC: EditContactUsViewController
    
    init(hostVC: EditContactUsViewController) {
        self.hostVC = hostVC
    }
    
    func validFields() -> Bool {
        var errorMessage: AlertConstant = .none
        let input = String.getString(hostVC.inputTF.text).trimmingCharacters(in: .whitespacesAndNewlines)
        switch hostVC.comingReason {
        case .email:
            if input.isEmpty {
                errorMessage = .EnterEmailAddress
            } else if input.isEmail() {
                if !input.isValidEmail() {
                    errorMessage = .EnterValidEmailAddress
                }
            }
        default:
            if input.isEmpty {
                errorMessage = .EnterMobileNumber
            } else if input.isPhoneNumber() {
                if !input.isValidPhoneNumber() {
                    errorMessage = .validMobileNumber
                }
            }
        }
        
        if errorMessage != .none {
            hostVC.showAlert(msg: errorMessage.rawValue.localiz())
        }
        
        hostVC.view.endEditing(true)
        return errorMessage == .none
    }
    
    func updateFAQRequest() {
        var param: [String: Any] = ["type": hostVC.selectedUserType]//, //1-user,2-seller,3-delivery boy
        switch hostVC.comingReason {
        case .email:
            param["email"] = hostVC.inputTF.text?.trimmed() ?? ""
            param["mobile"] = hostVC.contactListData?.contentEnglish?.mobile
            param["whatsapp"] = hostVC.contactListData?.contentEnglish?.whatsapp
        case .phoneNumber:
            param["email"] = hostVC.contactListData?.contentEnglish?.email
            param["mobile"] = hostVC.inputTF.text?.trimmed() ?? ""
            param["whatsapp"] = hostVC.contactListData?.contentEnglish?.whatsapp
        case .whatsApp:
            param["email"] = hostVC.contactListData?.contentEnglish?.email
            param["mobile"] = hostVC.contactListData?.contentEnglish?.mobile
            param["whatsapp"] = hostVC.inputTF.text?.trimmed() ?? ""
            
        }
        WebService.shared.updateContactUsService(parameter: param) { [weak self] response in
            guard let self = self else { return }
            CommonUtils.showToast(message: "New FAQ is updated successully".localiz())
            self.hostVC.dismiss(animated: true)
        }
    }
}
