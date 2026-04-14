//
//  EnrolledSellerTableViewCell.swift
//  DesynatAdmin
//
//  Created by fluper on 07/01/26.
//

import UIKit

class EnrolledSellerTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var productAddedLabel: UILabel!
    @IBOutlet weak var productSoldLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configData(data: SellerDealrecord?) {
        nameLabel.text = "\(data?.sellerDetails?.firstName ?? "") \(data?.sellerDetails?.lastName ?? "")"
        locationLabel.text = "\(data?.sellerDetails?.countryDetails?.name ?? "")"
        productAddedLabel.text = "\(data?.productCount ?? 0) Products"
        //        productAddedLabel.text = data?.?.description
        
    }
    
}
