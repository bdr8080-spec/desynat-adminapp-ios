//
//  TicketManagementDetailsViewModel.swift
//  DesynatAdmin
//
//  Created by fluper_mac3 on 08/04/26.
//

import Foundation

class TicketManagementDetailsViewModel {
    
    private var hostVC: TicketManagementDetailsViewController
    
    init(hostVC: TicketManagementDetailsViewController) {
        self.hostVC = hostVC
    }
    
    func updateStatusRequest() {
        let params: [String : Any] = ["ticket_id": hostVC.ticketDetails?.id ?? 0,
                                      "status": hostVC.selectedStatusIndex ?? 0] // //0-pending,1-resolved
        WebService.shared.updateTicketStatusService(param: params) { [weak self] response in
            guard let self = self else { return }
            CommonUtils.showToast(message: "Status is updated".localiz())
            self.hostVC.isStatusUpdated?()
            self.hostVC.navigationController?.popViewController(animated: true)
        }
    }
}
