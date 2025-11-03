//
//  CountryTableViewCell.swift
//  DesynatAdmin
//
//  Created by Rakhi Kumari on 01/11/25.
//

import UIKit

class CountryTableViewCell: UITableViewCell {

    @IBOutlet weak var countryImageView: UIImageView!
    @IBOutlet weak var countryLabel: CustomLabelFont!
    @IBOutlet weak var selectedImageView: UIImageView!
    @IBOutlet weak var countryFlagEmojiLabel: CustomLabelFont!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configData(data: GetCountryDataModel) {
        countryLabel.text = data.name
        countryFlagEmojiLabel.text = data.flag
    }
    
}
