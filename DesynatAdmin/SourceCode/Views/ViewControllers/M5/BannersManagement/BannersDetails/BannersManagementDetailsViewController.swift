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
  
  @IBOutlet weak var subCategoryStackView: UIStackView!
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
    @IBOutlet weak var toggleImageView: UIImageView!
    @IBOutlet weak var toggleButtonOutlet: UIButton!
    
    //MARK: VARIABLE
  var type: BannersSelectedListType = .new
  var detailData = BannerListInfo()
  private var viewModel : BannersManagementListViewModel = BannersManagementListViewModel()
    private var toggleStatus: Int = 0
    var onStatusUpdated: ((BannerListInfo) -> Void)?

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
      if type == .approved {
          toggleImageView.isHidden = false
          toggleButtonOutlet.isHidden = false
      } else {
          toggleImageView.isHidden = true
          toggleButtonOutlet.isHidden = true
      }
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
    self.subCategoryStackView.isHidden = true
    self.lblSubcategoryName.text = detailData.subcategory
    if detailData.bannerPosition == "1" {
      self.lblBannerPosition.text = "Home-Top"
    } else if detailData.bannerPosition == "2" {
      self.lblBannerPosition.text = "Home-Bottom"
    } else if detailData.bannerPosition == "3" {
      self.lblBannerPosition.text = "Category"
      self.subCategoryStackView.isHidden = false
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
    self.lblStatus.textColor = UIColor(hexString: "34A853") //green
    self.transactionIdStackView.isHidden = true
      toggleStatus = detailData.bannerBlockStatus == "1" ? 1 : 0
      updateToggleUI()
    if type.rawValue == 1 {
      if detailData.paymentStatus == "0" {
        self.lblStatus.text = "Upcoming"
      } else if detailData.paymentStatus == "1" {
        self.lblStatus.text = "Active"
        self.transactionIdStackView.isHidden = false
      }
    }else if type.rawValue == 2 {
      self.lblStatus.textColor = .red
      self.lblStatus.text = "Rejected"
    }
    self.lblFrom.text = detailData.from
    self.lblTo.text = detailData.to
    self.banneImageView.image = .placeholder
    if let url = URL(string: detailData.image) {
      self.banneImageView.sd_setImage(with: url,placeholderImage: .placeholder)
    }
  }
    
    private func updateToggleUI() {
        toggleImageView.image = toggleStatus == 1
            ? UIImage(named: "toggleOn")   // Unblocked
            : UIImage(named: "toggleOff")  // Blocked
    }

    @IBAction func bannerImageDidTapped(_ sender: Any) {
        let nextVC = SizeChartViewController.instantiate(fromAppStoryboard: .AffiliatedBannerOrder)
        nextVC.sizeChartUrl = detailData.image
        self.navigationController?.present(nextVC, animated: true)
    }
    
    @IBAction func toggleButtonDidTapped(_ sender: Any) {
        let newStatus = toggleStatus == 1 ? 0 : 1

            let param: [String: Any] = [
                "id": detailData.id,
//                "status": newStatus
            ]

            viewModel.upadteBannerStatus(param: param) { [weak self] success in
                guard let self = self else { return }

                DispatchQueue.main.async {
                    if success {
                        // 1️⃣ Update local toggle
                        self.toggleStatus = newStatus
                        self.updateToggleUI()

                        // 2️⃣ Update model object
                        self.detailData.bannerBlockStatus = "\(newStatus)"

                        // 3️⃣ Send updated model back
                        self.onStatusUpdated?(self.detailData)
                        let message = newStatus == 1
                                            ? "Banner activated successfully"
                                            : "Banner deactivated successfully"

//                                        self.view.showToast(message)
                        CommonUtils.showToast(message: message)
                    }
                }
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

