//
//  SellersListTableViewCell.swift
//  DesynatAdmin
//
//  Created by Meet Goti on 07/11/25.
//

import UIKit

class SellersListTableViewCell: ResuableTableCell {
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblCountry: UILabel!
    @IBOutlet weak var lblJoinOn: UILabel!
    @IBOutlet weak var btnReject: CustomButton!
    @IBOutlet weak var btnAccept: CustomButton!
    @IBOutlet weak var lblMobileNumber: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var viewStats: UIView!
    @IBOutlet weak var lblTotalOrders: UILabel!
    @IBOutlet weak var viewReason: UIView!
    @IBOutlet weak var lblTotalEarning: UILabel!
    @IBOutlet weak var stackActionButton: UIStackView!
    @IBOutlet weak var lblReason: UILabel!
    @IBOutlet weak var imgProfile: CustomImageView!
    private var data : SellerListInfo?
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setUpUi()
    }
    private func setUpUi() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.btnReject.addGradientBorder(cornerRadius: 5,direction: .topToBottom,colors: [UIColor.init(hexString: "#DFBF8F"), UIColor.init(hexString: "#6E4527")])
            self.btnAccept.applyGradient(colours: [UIColor.init(hexString: "#DFBF8F"), UIColor.init(hexString: "#6E4527")],gradientDirection: .topToBottom,cornerRadius: 5)
        }

    }

    func setData(_ data:SellerListInfo) {
        self.data = data
        self.lblName.text = data.name
        self.imgProfile.image = .sellerActive
        if let url = URL(string: data.image) {
            self.imgProfile.sd_setImage(with: url,placeholderImage: .sellerActive)
        }
        self.lblJoinOn.text = "Joined on \(data.joinedOn)"
        self.lblMobileNumber.text = data.mobileNumber
        self.lblEmail.text = data.email
        self.lblCountry.text = data.country
        self.lblReason.text = data.reason
        self.lblTotalOrders.text = data.totalOrders
        self.lblTotalEarning.text = data.totalEarning
        
        self.stackActionButton.isHidden = data.status != .new
        self.viewStats.isHidden = data.status != .approved
        self.viewReason.isHidden = data.status != .reject
    }
    @IBAction func hadlerReject(_ sender: Any) {
        self.data?.rejectSeller()
    }
    
    @IBAction func hadlerAccept(_ sender: Any) {
        self.data?.accceptSeller()
    }
}
