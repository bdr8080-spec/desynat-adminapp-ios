//
//  LiveRequestListViewCell.swift
//  DesynatAdmin
//
//  Created by fluper on 06/01/26.
//

import UIKit

class LiveRequestListViewCell: UITableViewCell {

  @IBOutlet weak var toggleImageView: UIImageView!
  @IBOutlet weak var timeLabel: UILabel!
  
  var onDeleteToggle:(() -> Void)?
  var onEditToggle:(() -> Void)?
  var onStatusToggle:(() -> Void)?
  
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
  @IBAction func deleteDidTapped(_ sender: Any) {
    onDeleteToggle?()
  }
  
  @IBAction func editDidTapped(_ sender: Any) {
    onEditToggle?()
  }
  
  @IBAction func toggleDidTapped(_ sender: Any) {
    onStatusToggle?()
  }
  
  
}
