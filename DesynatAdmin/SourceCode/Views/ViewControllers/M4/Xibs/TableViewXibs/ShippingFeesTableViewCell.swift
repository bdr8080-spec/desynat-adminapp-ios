//
//  ShippingFeesTableViewCell.swift
//  DesynatAdmin
//
//  Created by fluper on 09/12/25.
//

import UIKit

class ShippingFeesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var statusButtonOutlet: UIButton!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    var onEditTap: (() -> Void)?
    var onStatusToggle: (() -> Void)?
    var onDeleteTap: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    @IBAction func editDidTapped(_ sender: Any) {
        onEditTap?()
    }
    
    @IBAction func deleteDidTapped(_ sender: Any) {
        onDeleteTap?()
    }
    
    @IBAction func statusToggleDidTapped(_ sender: Any) {
        onStatusToggle?()
    }
    
    func configData(data: ShippingChargesList?) {
        let rangeFrom = Int(Double(data?.rangeFrom ?? "0") ?? 0)
        let rangeTo = Int(Double(data?.rangeTo ?? "0") ?? 0)
        let shippingFee = Int(Double(data?.shippingFee ?? "0") ?? 0)
        let text = "km".localiz()
        let text1 = "KD".localiz()
        distanceLabel.text = "\(rangeFrom)\(text) - \(rangeTo)\(text)"
//        priceLabel.text = "\(shippingFee) \(text1)"
        priceLabel.text = CommonUtils.formatPriceStringInputDecimal(data?.shippingFee ?? "0", currency: data?.countryInfo?.currencyCode ?? "")
        
        if data?.status == 1 {
            statusButtonOutlet.setImage(UIImage(named: "toggleOn"), for: .normal)
        } else {
            statusButtonOutlet.setImage(UIImage(named: "toggleOff"), for: .normal)
        }
    }
    
}
