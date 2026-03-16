//
//  CMSTermsAndConditionViewModel.swift
//  DesynatAdmin
//
//  Created by fluper_mac3 on 16/03/26.
//

import Foundation

class CMSTermsConditionViewModel {
    
    private var hostVC: CMSTermsConditionViewController
    var termsAndConditonData: CMSTermsConditionDataModel?
    
    init(hostVC: CMSTermsConditionViewController) {
        self.hostVC = hostVC
    }
    
    func getTermsAndConditionRequest() {
        let param: [String: Any] = ["type": hostVC.selectedUserType]
        WebService.shared.getTermsConditionService(parameter: param) { [weak self] response in
            guard let self = self else { return }
            termsAndConditonData = response
            CommonUtils.loadHTMLContent(response.contentEnglish ?? "N/A", webView: hostVC.englishContentWebView)
            CommonUtils.loadHTMLContent(response.contentArabic ?? "N/A", webView: hostVC.arabicContentWebView)
        }
    }
}
