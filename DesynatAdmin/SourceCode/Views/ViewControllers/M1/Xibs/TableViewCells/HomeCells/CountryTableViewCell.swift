//
//  CountryTableViewCell.swift
//  DesynatAdmin
//
//  Created by Rakhi Kumari on 01/11/25.
//

import UIKit

class CountryTableViewCell: ResuableTableCell {

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
    
    func configData(data: GetCountryDataModel,isSelected:Bool) {
        if AppLanguageManager.shared.currentLanguage == .ar {
            countryLabel.text = data.nameAr
        }else {
            countryLabel.text = data.name
        }
        countryFlagEmojiLabel.text = data.flag
        self.selectedImageView.image = UIImage(named: isSelected ? "radioSelected" : "radioUnselected")
    }
    
    func configAdminDashboardData(data: GetAllUserCountryModel,isSelected:Bool) {
        countryLabel.text = data.name
        countryFlagEmojiLabel.text = data.flag1
        self.selectedImageView.image = UIImage(named: isSelected ? "radioSelected" : "radioUnselected")
    }
    
    func configCityData(data: CountryCitiesDataModel,isSelected:Bool) {
        countryLabel.text = data.name
        countryFlagEmojiLabel.isHidden = true
        self.selectedImageView.image = UIImage(named: isSelected ? "radioSelected" : "radioUnselected")
    }
    
}
