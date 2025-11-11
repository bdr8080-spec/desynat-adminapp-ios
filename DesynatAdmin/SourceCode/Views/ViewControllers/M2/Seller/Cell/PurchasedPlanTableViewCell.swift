//
//  PurchasedPlanTableViewCell.swift
//  DesynatAdmin
//
//  Created by Meet Goti on 11/11/25.
//

import UIKit
enum PurchasedStatus:Int {
case none = 0 ,active,expired
    var title:String {
        switch self {
        case .none:
            ""
        case .active:
            "Active"
        case .expired:
            "Expired"
        }
    }
    var titleColor:UIColor {
        switch self {
        case .none:
                .clear
        case .active:
                .init(hexString: "#17854C")
        case .expired:
                .init(hexString: "##D91A1B")
        }
    }
}
struct PurchasedPlanInfo {
    var id:String = UUID().uuidString
    var name: String = ""
    var durationType: DurationType = .none
    var status: PurchasedStatus = .none
    var purchasedOn:String = ""
    var price:String = ""
    static func makeData(_ data:PurchasedPlanDataModel) -> Self {
        PurchasedPlanInfo(
            id: String.getString(data.id),
            name: String.getString(data.planInfo?.planNameEnglish),
            durationType: DurationType(rawValue: Int.getInt(data.planInfo?.durationType)) ?? .none,
            status: PurchasedStatus(rawValue: Int.getInt(data.status)) ?? .none,
            purchasedOn: CommonUtils.getDateString(
                from: Date(iso8601String: String.getString(data.createdAt)),
                format: "dd/MM/yyyy 'at' hh:mm a"
            ),
            price: "KD \(Int.getInt(Double.getDouble(data.planInfo?.price).clean))",
        )
    }
}
class PurchasedPlanTableViewCell: ResuableTableCell {
    @IBOutlet weak var lblPlanDurationType: CustomLabelFont!
    
    @IBOutlet weak var lblTotalAmount: CustomLabelFont!
    @IBOutlet weak var lblPurchasedOn: CustomLabelFont!
    @IBOutlet weak var lblStatus: CustomLabelFont!
    @IBOutlet weak var lblPlanName: CustomLabelFont!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setData(_ data:PurchasedPlanInfo) {
        self.lblPlanDurationType.text = data.durationType.title
        self.lblStatus.text = data.status.title
        self.lblStatus.textColor = data.status.titleColor
        self.lblPurchasedOn.text = data.purchasedOn
        self.lblTotalAmount.text = data.price
    }
    
}
