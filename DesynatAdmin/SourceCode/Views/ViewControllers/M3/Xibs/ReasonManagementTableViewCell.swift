//
//  ReasonManagementTableViewCell.swift
//  DesynatAdmin
//
//  Created by fluper on 20/11/25.
//

import UIKit

class ReasonManagementTableViewCell: UITableViewCell {

  @IBOutlet weak var raesonLabel: UILabel!
  @IBOutlet weak var deleteButtonOutlet: UIButton!
  @IBOutlet weak var editButtonOutlet: UIButton!
  @IBOutlet weak var statusButtonOutlet: UIButton!
  
  weak var delegate: ReasonManagementCellDelegate?
  var onStatusToggle: (() -> Void)?
  
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
  
  
  @IBAction func editDidTapepd(_ sender: Any) {
    delegate?.didTapEdit(self)
  }
  
  @IBAction func deleteDidTapped(_ sender: Any) {
    delegate?.didTapDelete(self)
  }
  
  @IBAction func activeStatusDidTapped(_ sender: Any) {
    onStatusToggle?()
  }
  
  
  func configData(data: ReasonsListModel?) {
    raesonLabel.text = data?.reasonEnglish
    if data?.status == 1 {
      statusButtonOutlet.setImage(UIImage(named: "toggleOn"), for: .normal)
    } else {
      statusButtonOutlet.setImage(UIImage(named: "toggleOff"), for: .normal)
    }
  }
    
}

protocol ReasonManagementCellDelegate: AnyObject {
    func didTapEdit(_ cell: ReasonManagementTableViewCell)
    func didTapDelete(_ cell: ReasonManagementTableViewCell)
}
