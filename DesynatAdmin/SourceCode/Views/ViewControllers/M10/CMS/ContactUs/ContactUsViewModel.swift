//
//  ContactUsViewModel.swift
//  DesynatAdmin
//
//  Created by fluper_mac3 on 16/03/26.
//

import Foundation

class ContactUsViewModel {
    
    private var hostVC: ContactUsViewController
    var termsAndConditonData: CMSTermsConditionDataModel?
    var contactListData: [FAQListDataModel]?
    
    init(hostVC: ContactUsViewController) {
        self.hostVC = hostVC
    }
    
    func getContactUsRequest() {
        let param: [String: Any] = ["type": hostVC.selectedUserType]
        WebService.shared.getContactUsService(parameter: param) { [weak self] response in
            guard let self = self else { return }
            contactListData = response
            hostVC.contactUsTableView.reloadData()
        }
    }
}
