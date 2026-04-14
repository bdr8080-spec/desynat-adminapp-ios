//
//  CMSDetailsViewModel.swift
//  DesynatAdmin
//
//  Created by fluper_mac3 on 16/03/26.
//

import Foundation

class CMSDetailsViewModel {
    
    private var hostVC: CMSDetailsViewController
    var cmsDetailsData: CMSTermsConditionDataModel?
    
    init(hostVC: CMSDetailsViewController) {
        self.hostVC = hostVC
    }
    
    func getReturnPolicyRequest() {
        let param: [String: Any] = ["type": hostVC.selectedUserType]
        WebService.shared.getReturnPolicyService(parameter: param) { [weak self] response in
            guard let self = self else { return }
            cmsDetailsData = response
            CommonUtils.loadHTMLContent(response.contentEnglish ?? "N/A", webView: hostVC.contentView)
        }
    }
    
    func getAboutUsRequest() {
        let param: [String: Any] = ["type": hostVC.selectedUserType]
        WebService.shared.getReturnPolicyService(parameter: param) { [weak self] response in
            guard let self = self else { return }
            cmsDetailsData = response
            CommonUtils.loadHTMLContent(response.contentEnglish ?? "N/A", webView: hostVC.contentView)
        }
    }
    
    func getCancellationPolicyRequest() {
        let param: [String: Any] = ["type": hostVC.selectedUserType]
        WebService.shared.getCancellationPolicyService(parameter: param) { [weak self] response in
            guard let self = self else { return }
            cmsDetailsData = response
            CommonUtils.loadHTMLContent(response.contentEnglish ?? "N/A", webView: hostVC.contentView)
        }
    }
    
    func getExchangePolicyRequest() {
        let param: [String: Any] = ["type": hostVC.selectedUserType]
        WebService.shared.getExchangePolicyService(parameter: param) { [weak self] response in
            guard let self = self else { return }
            cmsDetailsData = response
            CommonUtils.loadHTMLContent(response.contentEnglish ?? "N/A", webView: hostVC.contentView)
        }
    }
}
