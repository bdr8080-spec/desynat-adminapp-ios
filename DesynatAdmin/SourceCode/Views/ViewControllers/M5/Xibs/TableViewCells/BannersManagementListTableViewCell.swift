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
  @IBOutlet weak var lblName: UILabel!
  @IBOutlet weak var lblCity: UILabel!
  @IBOutlet weak var lblRequestId: UILabel!
  @IBOutlet weak var lblRequestOn: UILabel!
  @IBOutlet weak var lblDuration: UILabel!
  @IBOutlet weak var lblTotalAmount: UILabel!
  @IBOutlet weak var lblBannerPosition: UILabel!
  @IBOutlet weak var lblAmount: UILabel!
  @IBOutlet weak var lblBankAccountNo: UILabel!
  @IBOutlet weak var lblAvailableAmount: UILabel!
  @IBOutlet weak var lblRequestedAmount: UILabel!
  @IBOutlet weak var lblReason: UILabel!
  @IBOutlet weak var lblStatus: UILabel!
  
  
  //MARK: VARIABLE
  var rejectAction: (() -> Void)?
  var acceptAction: (() -> Void)?
  private var data : BannerListInfo?
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
  }
  
  func setData(_ data :BannerListInfo,for type: BannersSelectedListType) {
    print("data====>\(data)")
    self.data = data
    self.lblName.text = data.name
    self.lblCity.text = data.country
    let fullId = data.orderID
    let last7 = fullId.count >= 7 ? String(fullId.suffix(7)) : fullId
    self.lblRequestId.text = "#\(last7)"
    self.lblRequestOn.text = data.joinedOn
    self.lblDuration.text = "\(data.totalDays) days"
    self.lblReason.text = data.reason
    self.lblTotalAmount.text = "\(data.totalEarning) KD"
    self.lblAvailableAmount.text = "\(data.totalEarning) KD"
    self.lblRequestedAmount.text = "\(data.totalEarning) KD"
    if data.bannerPosition == "1" {
      self.lblBannerPosition.text = "Home-Top"
    } else if data.bannerPosition == "2" {
      self.lblBannerPosition.text = "Home-Banner"
    } else if data.bannerPosition == "3" {
      self.lblBannerPosition.text = "Category"
    }
    // payment status - 0 pending, 1 paid , 2 cancelled, 3 failed
    if data.paymentStatus == "0" {
      self.lblAmount.text = "Pending"
    } else if data.paymentStatus == "1" {
      self.lblAmount.text = "Paid"
    } else if data.paymentStatus == "2" {
      self.lblAmount.text = "Cancelled"
    } else if data.paymentStatus == "3" {
      self.lblAmount.text = "Failed"
    }
    self.lblStatus.textColor = UIColor(hexString: "34A853") //green
    if type.rawValue == 1 {
      if data.paymentStatus == "0" {
        self.lblStatus.textColor = UIColor(hexString: "34A853") //green
        self.lblStatus.text = "Upcoming"
        
      } else if data.paymentStatus == "1" {
        self.lblStatus.textColor = UIColor(hexString: "34A853") //green
        self.lblStatus.text = "Active"
      }
    }else if type.rawValue == 2 {
      self.lblStatus.textColor = .red
      self.lblStatus.text = "Rejected"
      
    }
    hideAndShowDetails(for: type)
  }
  
  @IBAction func rejectDidTapped(_ sender: Any) {
    self.data?.rejectBanner()
  }
  
  
  @IBAction func acceptDidTapped(_ sender: Any) {
    self.data?.accceptBanner()
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
      bankInfoStackView.isHidden = true
      availableAmountstackView.isHidden = true
      requestStackView.isHidden = true
      totalAmountStackView.isHidden = false
      reasonStackView.isHidden = false
    }
  }
}
