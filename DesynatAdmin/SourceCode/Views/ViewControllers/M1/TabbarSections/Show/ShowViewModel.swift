//
//  ShowViewModel.swift
//  DesynatAdmin
//
//  Created by fluper_mac3 on 20/03/26.
//

import Foundation

class ShowViewModel {
    
    private var hostVC: ShowViewController?
    var countryListData: [GetCountryDataModel] = []
    var liveEventListData: [ShowLiveEvenetsDataModel] = []
    
    init(hostVC: ShowViewController) {
        self.hostVC = hostVC
    }
    
    func getAllCountry() {
        WebService.shared.getAllCountry(){ [weak self] response in
            guard let self = self else { return }
            countryListData = response
            adminAllLiveRequest(countryId: response.first?.id ?? 0)
        }
    }
    
    func adminAllLiveRequest(countryId: Int) {
        let param: [String:Any] = ["country_id": countryId]
        WebService.shared.adminAllLiveService(param: param){ [weak self] response in
            guard let self = self else { return }
            liveEventListData = response
            hostVC?.listTableView.reloadData()
            hostVC?.noDataFoundLabel.isHidden = !response.isEmpty
        }
    }
    
    func generateLiveStramingTokenRequest(id: Int) {
        let param: [String:Any] = ["id": id, "role": 1]
        WebService.sharedInstance.generateLiveStramingTokenService(param: param) { [weak self] response in
            guard let self = self else { return }
            let nextVC = LiveStreamingViewController.instantiate(fromAppStoryboard: .Home)
            nextVC.isHost = false
            nextVC.token = response.token
            nextVC.uid = response.uid ?? UInt.random(in: 1...9999)
            nextVC.appID = response.appID ?? ""
            nextVC.channelName = response.channel ?? ""
            nextVC.modalPresentationStyle = .fullScreen
            self.hostVC?.navigationController?.present(nextVC, animated: false)
        }
    }
    
}
