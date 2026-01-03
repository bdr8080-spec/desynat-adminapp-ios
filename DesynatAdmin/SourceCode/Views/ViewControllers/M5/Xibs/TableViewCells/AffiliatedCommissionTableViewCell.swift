//
//  AffiliatedCommissionTableViewCell.swift
//  DesynatAdmin
//
//  Created by fluper on 16/12/25.
//

import UIKit

class AffiliatedCommissionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var flagEmojLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var commissionLabel: UILabel!
    
    //MARK: VARIABLES
    var onEditTap: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    @IBAction func editDidTapped(_ sender: Any) {
        onEditTap?()
    }
    
    func configData(data: CommissionPercentageModel) {
        self.titleLabel.text = data.name ?? ""
        self.flagEmojLabel.text = data.flag ?? ""
//        if let commissionStr = data.affiliateCommissionInfo?.commission,
//           let commission = Double(commissionStr) {
//            self.commissionLabel.text = String(format: "%.1f %%", commission)
//        } else {
//            self.commissionLabel.text = "0.0 %"
//        }
        commissionLabel.text = "\(CommonUtils.formatPriceStringInputDecimal(data.affiliateCommissionInfo?.commission))"
    }
    
    
    
}
