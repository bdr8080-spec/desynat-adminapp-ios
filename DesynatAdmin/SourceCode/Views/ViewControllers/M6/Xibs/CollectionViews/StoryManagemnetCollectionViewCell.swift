//
//  StoryManagemnetCollectionViewCell.swift
//  DesynatAdmin
//
//  Created by fluper on 07/01/26.
//

import UIKit

class StoryManagemnetCollectionViewCell: UICollectionViewCell {

  @IBOutlet weak var mainImageView: CustomImageView!
  @IBOutlet weak var statusLabel: UILabel!
  @IBOutlet weak var postedDateLabel: UILabel!
  
  var onDeleteToggle:(() -> Void)?
  
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

  @IBAction func deleteDidTapped(_ sender: Any) {
    onDeleteToggle?()
  }
}
