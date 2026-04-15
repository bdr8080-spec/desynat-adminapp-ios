//
//  TicketManagementTableViewCell.swift
//  DesynatAdmin
//
//  Created by fluper_mac3 on 20/03/26.
//

import UIKit

class TicketManagementTableViewCell: UITableViewCell {
    
    @IBOutlet weak var requestedByLabel: UILabel!
    @IBOutlet weak var ticketIdLabel: UILabel!
    @IBOutlet weak var submittedByLabel: UILabel!
    @IBOutlet weak var ticketTypeLabel: UILabel!
    @IBOutlet weak var raisedOnLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func statusType(status: Int) -> (text: String, color: UIColor) {
        let state = TicketStatus(rawValue: status)
        return (state?.text ?? "Unknown", state?.color ?? .gray)
    }
    
    func configData(data: TicketManagementList?, status: TiketListType = .newList) {
        var fullname: String? = ""
        let senderTypeRequest = data?.senderType ?? 1
        
        switch senderTypeRequest {
        case 2:
            fullname  = "\(data?.senderDetails?.firstName ?? "") \(data?.senderDetails?.lastName ?? "")"
        case 4:
            fullname  = data?.senderDetails?.fullNameEnglish
        default:
            fullname = data?.senderDetails?.fullName
        }
        requestedByLabel.text = fullname
        ticketIdLabel.text = data?.ticketID
        submittedByLabel.text = senderType(role: data?.senderType ?? 1)
        ticketTypeLabel.text = data?.ticketTypeDetails?.name
        raisedOnLabel.text = convertServerDate(data?.createdAt ?? "")
        switch status {
            
        case .newList:
            statusLabel.text = "Pending"
            let status = statusType(status: data?.status ?? 0)
            statusLabel.textColor = status.color
        case .ongoingList:
            let status = statusType(status: data?.status ?? 0)
            statusLabel.text = "Ongoing"
            statusLabel.textColor = status.color
        case .pastList:
            let status = statusType(status: data?.status ?? 0)
            statusLabel.text = "Resolved"
            statusLabel.textColor = status.color
        }
    }
    
    func senderType(role: Int) -> String {
        let state = SenderRoleType(rawValue: role)
        return state?.text ?? "Customer"
    }
    
    func convertServerDate(_ isoString: String) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"

        guard let date = formatter.date(from: isoString) else {
            return isoString
        }

        let outputFormatter = DateFormatter()
        outputFormatter.locale = Locale(identifier: "en_US_POSIX")
        outputFormatter.dateFormat = "dd MMM yy, h:mm a"   // <- Output format

        return outputFormatter.string(from: date)
    }
    
}

enum SenderRoleType: Int {
    case user = 1
    case seller = 2
    case affiliate = 3
    case driver = 4
    
    var text: String {
        switch self {
        case .user: return "Customer"
        case .seller: return "Seller"
        case .affiliate: return "Affiliate User"
        case .driver: return "Driver"
        }
    }
}
