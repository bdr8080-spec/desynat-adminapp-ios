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
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblCity: UILabel!
    @IBOutlet weak var lblRequestId: UILabel!
    @IBOutlet weak var lblRequestOn: UILabel!
    @IBOutlet weak var lblDuration: UILabel!
    @IBOutlet weak var lblTotalAmount: UILabel!
    @IBOutlet weak var lblBannerPosition: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblFrom: UILabel!
    @IBOutlet weak var lblTo: UILabel!
    @IBOutlet weak var lblTransactionId: UILabel!
    @IBOutlet weak var lblSubcategoryName: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
  
    //MARK: VARIABLE
    var type: BannersSelectedListType = .new
    var detailData = BannerListInfo()
    private var viewModel : BannersManagementListViewModel = BannersManagementListViewModel()
  
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
      setData()
  }
    
    
    func setData() {
        self.lblName.text = detailData.name
        self.lblCity.text = detailData.country
        let fullId = detailData.orderID
        let last7 = fullId.count >= 7 ? String(fullId.suffix(7)) : fullId
        self.lblRequestId.text = "#\(last7)"
        let fullTransactionId = detailData.transactionID
        let lastTransactionId7 = fullTransactionId.count >= 7 ? String(fullTransactionId.suffix(7)) : fullTransactionId
        self.lblTransactionId.text = "#\(lastTransactionId7)"
        self.lblRequestOn.text = detailData.joinedOn
        self.lblDuration.text = "\(detailData.totalDays) days"
        self.lblTotalAmount.text = detailData.totalEarning
        if detailData.bannerPosition == "1" {
            self.lblBannerPosition.text = "Home-Top"
        } else if detailData.bannerPosition == "2" {
            self.lblBannerPosition.text = "Home-Bottom"
        } else if detailData.bannerPosition == "3" {
            self.lblBannerPosition.text = "Sub-Category"
        }
       // payment status - 0 pending, 1 paid , 2 cancelled, 3 failed
        if detailData.paymentStatus == "0" {
            self.lblAmount.text = "Pending"
        } else if detailData.paymentStatus == "1" {
            self.lblAmount.text = "Paid"
        } else if detailData.paymentStatus == "2" {
            self.lblAmount.text = "Cancelled"
        } else if detailData.paymentStatus == "3" {
            self.lblAmount.text = "Failed"
        }
        if type.rawValue == 1 {
            if detailData.paymentStatus == "0" {
                self.lblStatus.text = "Upcoming"
            } else if detailData.paymentStatus == "1" {
                self.lblStatus.text = "Active"
            }
        }else if type.rawValue == 2 {
            self.lblStatus.text = "Rejected"
        }
        self.lblFrom.text = detailData.from
        self.lblTo.text = detailData.to
        self.banneImageView.image = .placeholder
        if let url = URL(string: detailData.image) {
            self.banneImageView.sd_setImage(with: url,placeholderImage: .placeholder)
        }
    }
    

    @IBAction func rejectDidTapped(_ sender: Any) {
        let vc = RejectReasonViewController.viewFromNIB
        vc.setCallback { reason,type in
            self.viewModel.rejectBanner(id: self.detailData.id, reason: reason) {
                DispatchQueue.main.async {
                    let succesVC = RegisterationSuccessViewController.instantiate(fromAppStoryboard: .Main)
                    succesVC.setTitle("Banner rejected\nsuccessfully!")
                    succesVC.callBackDismiss = {
                        self.navigationController?.popViewController(animated: true)
                    }
                    vc.dismiss(animated: false)
                    self.presentVC(succesVC)
                }
            }
        }
        self.presentVC(vc,withAnimation: false,modalPresentationStyle: .overCurrentContext)
    }
    
    
    @IBAction func acceptDidTapped(_ sender: Any) {
        viewModel.acceptBanner(id: self.detailData.id) {
            DispatchQueue.main.async {
                let vc = RegisterationSuccessViewController.instantiate(fromAppStoryboard: .Main)
                vc.setTitle("Banner approved\nsuccessfully!")
                vc.callBackDismiss = {
                    self.navigationController?.popViewController(animated: true)
                }
                self.presentVC(vc,modalPresentationStyle: .overCurrentContext)
            }
        }
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

