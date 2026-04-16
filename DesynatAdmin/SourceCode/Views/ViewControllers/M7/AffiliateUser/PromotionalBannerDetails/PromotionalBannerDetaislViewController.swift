//
//  PromotionalBannerDetaislViewController.swift
//  DesynatAdmin
//
//  Created by fluper_mac3 on 05/02/26.
//

import UIKit
import SDWebImage

class PromotionalBannerDetaislViewController: UIViewController {
    
    // MARK: - IBOutlet's
    @IBOutlet weak var categoryStackView: UIStackView!
    @IBOutlet weak var categorynameLabel: UILabel!
    @IBOutlet weak var subcatgeoryStackView: UIStackView!
    @IBOutlet weak var subCategoryLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var statusImageView: UIImageView!
    @IBOutlet weak var cardImageView: CustomImageView!
    @IBOutlet weak var endDateLabel: UILabel!
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var countryNameLabel: UILabel!
    
    // MARK: - Property Decalaration
    var bannerId: Int = 0
    var bannerListData: GetPromotionalBannersList?
    private lazy var viewModel = PromotionalBannerDetailsViewModel(hostVC: self)
    var bannerType: BannerMangementType = .fullScreen
    private var toggleStatus: String = "0"
    var onStatusUpdated: ((GetPromotionalBannersList) -> Void)?
    
    // MARK: - View's LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.getPromotionalScreenBannerDetailsList()
    }
    
    // MARK: - Button's Action
    @IBAction func backDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func editDidTapped(_ sender: Any) {
        let vc = AddPromotionalBannerViewController.instantiate(fromAppStoryboard: .AffiliatedBannerOrder)
        vc.isComingForEdit = true
        vc.giftsListData = bannerListData
        vc.onCardUpdated = { [weak self] updatedData in
            guard let self = self else { return }
            viewModel.getPromotionalScreenBannerDetailsList()
        }
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    @IBAction func deleteDidTapped(_ sender: Any) {
        guard let gift = bannerListData else { return }
        self.showConfirmationAlert(msg: "Are you sure you want to delete this banner?"){ [weak self] in
            guard let self = self else { return }
            let param:[String:Any] = ["banner_id": bannerId]
            viewModel.deletePromtoionalBanner(param: param)
        }
    }
    
    @IBAction func toggleButtonDidTapped(_ sender: Any) {
        let newStatus = toggleStatus == "1" ? "0" : "1"
        let param: [String: Any] = ["banner_id": bannerId]
        
        viewModel.upadteBannerStatus(param: param) { [weak self] success in
            guard let self = self, success else { return }
            
            DispatchQueue.main.async {
                // Update SINGLE source
                self.toggleStatus = newStatus
                self.bannerListData?.status = newStatus
                
                self.updateToggleUI()
                
                let message = newStatus == "1"
                ? "Banner activated successfully"
                : "Banner deactivated successfully"
                
                CommonUtils.showToast(message: message)
                
                if let data = self.bannerListData {
                    self.onStatusUpdated?(data)
                }
            }
        }
    }
    
    //MARK: Function's declaration
    private func updateToggleUI() {
        // Toggle image
        statusImageView.image = toggleStatus == "1"
        ? UIImage(named: "toggleOn")
        : UIImage(named: "toggleOff")
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        
        let today = Calendar.current.startOfDay(for: Date())
        
        guard toggleStatus == "1" else {
            statusLabel.text = "Inactive"
            return
        }
        
        guard
            let startDateStr = bannerListData?.startDate,
            let endDateStr = bannerListData?.endDate,
            let startDate = formatter.date(from: startDateStr),
            let endDate = formatter.date(from: endDateStr)
        else {
            statusLabel.text = "Upcoming"
            return
        }
        
        let start = Calendar.current.startOfDay(for: startDate)
        let end = Calendar.current.startOfDay(for: endDate)
        
        if today < start {
            statusLabel.text = "Upcoming"
        } else if today > end {
            statusLabel.text = "Inactive"
        } else {
            statusLabel.text = "Active"
        }
    }
    
    
    func bindData() {
        if let imageUrlString = bannerListData?.uploadBanner,
           let url = URL(string: imageUrlString) {
            cardImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            cardImageView.sd_imageIndicator?.startAnimatingIndicator()
            cardImageView.sd_setImage(with: url, placeholderImage: UIImage(named: ""))
        } else {
            cardImageView.image = UIImage(named: "placeholder")
        }
        cardImageView.enableFullscreenZoom()
        startDateLabel.text = convertDateFormat(bannerListData?.startDate ?? "")
        endDateLabel.text = convertDateFormat(bannerListData?.endDate ?? "")
        subcatgeoryStackView.isHidden = true
        categoryStackView.isHidden = true
        countryNameLabel.text = bannerListData?.countryInfo?.name
        if bannerListData?.bannerPosition == "1" {
            positionLabel.text = "Home Top"
        } else if bannerListData?.bannerPosition == "2" {
            positionLabel.text = "Home Bottom"
        } else {
            positionLabel.text = "Category"
            subCategoryLabel.text = bannerListData?.subcategoryDetails?.nameEnglish
            categorynameLabel.text = bannerListData?.categoryDetails?.name
            subcatgeoryStackView.isHidden = false
            categoryStackView.isHidden = false
        }
        toggleStatus = bannerListData?.status ?? "0"
        self.updateToggleUI()
    }
    
    
    func convertDateFormat(
        _ dateString: String,
        from inputFormat: String = "yyyy-MM-dd",
        to outputFormat: String = "dd/MM/yyyy"
    ) -> String? {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = inputFormat
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        guard let date = inputFormatter.date(from: dateString) else {
            return nil
        }
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = outputFormat
        outputFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        return outputFormatter.string(from: date)
    }
    
}
