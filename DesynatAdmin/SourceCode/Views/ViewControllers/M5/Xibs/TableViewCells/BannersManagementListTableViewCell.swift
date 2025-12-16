//
//  BannersManagementListTableViewCell.swift
//  DesynatAdmin
//
//  Created by fluper on 16/12/25.
//

import UIKit

class BannersManagementListTableViewCell: UITableViewCell {

  @IBOutlet weak var reasonStackView: UIStackView!
  @IBOutlet weak var bankInfoStackView: UIStackView!
  @IBOutlet weak var availableAmountstackView: UIStackView!
  @IBOutlet weak var requestStackView: UIStackView!
  @IBOutlet weak var totalAmountStackView: UIStackView!
  @IBOutlet weak var durationstackView: UIStackView!
  @IBOutlet weak var acceptRejectstackView: UIStackView!
  @IBOutlet weak var statusValueLabel: UILabel!
  @IBOutlet weak var statusLabel: UILabel!
  @IBOutlet weak var amountStackView: UIStackView!
  @IBOutlet weak var bannerPosiitonStackView: UIStackView!
  
  
  var rejectAction: (() -> Void)?
  var acceptAction: (() -> Void)?
  
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
  @IBAction func rejectDidTapped(_ sender: Any) {
    rejectAction?()
  }
  
  
  @IBAction func acceptDidTapped(_ sender: Any) {
    acceptAction?()
  }
  
  func hideAndShowDetails(for type: BannersSelectedListType) {

          // Hide everything first (default state)
          [
              acceptRejectstackView,
              statusLabel,
              statusValueLabel,
              amountStackView,
              bannerPosiitonStackView,
              totalAmountStackView,
              durationstackView,
              bankInfoStackView,
              availableAmountstackView,
              requestStackView,
              reasonStackView
          ].forEach { $0?.isHidden = true }

          switch type {
          case .new:
              acceptRejectstackView.isHidden = false
              totalAmountStackView.isHidden = false
              durationstackView.isHidden = false

          case .approved:
              statusLabel.isHidden = false
              statusValueLabel.isHidden = false
              amountStackView.isHidden = false
              bannerPosiitonStackView.isHidden = false
              totalAmountStackView.isHidden = false
              durationstackView.isHidden = false

          case .rejected:
              statusLabel.isHidden = false
              statusValueLabel.isHidden = false
              bankInfoStackView.isHidden = false
              availableAmountstackView.isHidden = false
              requestStackView.isHidden = false
              reasonStackView.isHidden = false
          }
      }
}
