//
//  BannersManagementDetailsViewController.swift
//  DesynatAdmin
//
//  Created by fluper on 16/12/25.
//

import UIKit

class BannersManagementDetailsViewController: UIViewController {
  
  @IBOutlet weak var acceptView: UIView!
  @IBOutlet weak var rejectView: UIView!
  @IBOutlet weak var banneImageView: UIImageView!
  @IBOutlet weak var rejectAcceptStackView: UIStackView!
  @IBOutlet weak var transactionIdStackView: UIStackView!
  @IBOutlet weak var amountPaidOrNotStackView: UIStackView!
  
  var type: BannersSelectedListType = .new
  
  override func viewDidLoad() {
    super.viewDidLoad()
    if type == .new { //new
      transactionIdStackView.isHidden = true
      amountPaidOrNotStackView.isHidden = true
      rejectAcceptStackView.isHidden = false
      acceptView.isHidden = false
      rejectView.isHidden = false
    } else { //approved and rejected
      transactionIdStackView.isHidden = false
      amountPaidOrNotStackView.isHidden = false
      rejectAcceptStackView.isHidden = true
      acceptView.isHidden = true
      rejectView.isHidden = true
    }
    initialSetUp()
  }
  
  @IBAction func rejectDidTapped(_ sender: Any) {
    let nextVC = RejectReasonPopupViewController.instantiate(fromAppStoryboard: .AffiliatedBannerOrder)
    self.navigationController?.present(nextVC, animated: true)
  }
  
  @IBAction func backDidTapped(_ sender: Any) {
    self.navigationController?.popViewController(animated: true)
  }
  
  func initialSetUp() {
    banneImageView.layer.cornerRadius = 8
    banneImageView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
    banneImageView.clipsToBounds = true

  }
  
}
