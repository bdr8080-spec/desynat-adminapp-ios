//
//  ShippingChargesListTableViewCell.swift
//  DesynatAdmin
//
//  Created by fluper on 09/12/25.
//

import UIKit

class ShippingChargesListTableViewCell: UITableViewCell {
  
  @IBOutlet weak var flagEmojiLabel: UILabel!
  @IBOutlet weak var taxAmountLabel: UILabel!
  @IBOutlet weak var titleLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
  }
  
//  func configData(data: ShippingChargesDataModel?) {
//    flagEmojiLabel.text = data?.flag
//    titleLabel.text = data?.name
//    taxAmountLabel.text = "\(data?.taxInfo?.tax ?? "0")%"
//  }
  
  func configData(data: ShippingChargesDataModel?) {
      flagEmojiLabel.text = data?.flag
      titleLabel.text = data?.name
      
      if let taxString = data?.taxInfo?.tax,
         let taxDouble = Double(taxString) {
          
          // Format with up to 2 decimals, trimming unnecessary zeros
          let formatter = NumberFormatter()
          formatter.minimumFractionDigits = 0
          formatter.maximumFractionDigits = 2
          formatter.numberStyle = .decimal
          
          if let formattedTax = formatter.string(from: NSNumber(value: taxDouble)) {
              taxAmountLabel.text = "\(formattedTax)%"
          } else {
              taxAmountLabel.text = "0%"
          }
          
      } else {
          taxAmountLabel.text = "0%"
      }
  }


  
}
