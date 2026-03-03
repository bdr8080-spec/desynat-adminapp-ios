//
//  BannerPerDayListTableViewCell.swift
//  DesynatAdmin
//
//  Created by fluper on 09/12/25.
//

import UIKit

class BannerPerDayListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var countryNameLabel: UILabel!
    @IBOutlet weak var countryEmojiLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
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
    
    func configData(data: BannersPerDayListDataModel?) {
        countryNameLabel.text = data?.countryInfo?.name
        countryEmojiLabel.text = data?.countryInfo?.flag
        priceLabel.text = "\(data?.perDayPrice ?? "") KD"
    }
}
