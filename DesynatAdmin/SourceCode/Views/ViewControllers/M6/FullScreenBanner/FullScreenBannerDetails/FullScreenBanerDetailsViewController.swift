//
//  FullScreenBanerDetailsViewController.swift
//  DesynatAdmin
//
//  Created by fluper on 08/01/26.
//

import UIKit
import SDWebImage

class FullScreenBanerDetailsViewController: UIViewController {
    
    @IBOutlet weak var coountryView: UIStackView!
    @IBOutlet weak var typeTitleLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var statusImageView: UIImageView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var countryNameLabel: UILabel!
    @IBOutlet weak var cardImageView: CustomImageView!
    @IBOutlet weak var endDateLabel: UILabel!
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    var bannerId: Int = 0
    var giftsListData: FullScreenBannerDataList?
    var bannerListData: GetPromotionalBannersList?
    private lazy var viewModel = FullScreenBannerDetailsViewModel(hostVC: self)
    var bannerType: BannerMangementType = .fullScreen
    
    override func viewDidLoad() {
        super.viewDidLoad()
        typeTitleLabel.text = "Type"
        viewModel.getFullScreenBannerDetailsList()
        
    }
    
    @IBAction func backDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func editDidTapped(_ sender: Any) {
        let vc = AddAdvertisementViewController.instantiate(fromAppStoryboard: .AffiliatedBannerOrder)
        vc.isComingForEdit = true
        vc.giftsListData = giftsListData
        vc.onCardUpdated = { [weak self] updatedData in
            guard let self = self else { return }
            viewModel.getFullScreenBannerDetailsList()
        }
        self.navigationController?.pushViewController(vc, animated: false)
        
        
    }
    
    @IBAction func deleteDidTapped(_ sender: Any) {
        guard let gift = giftsListData else { return }
        self.showConfirmationAlert(msg: "Are you sure you want to delete this banner"){ [weak self] in
            guard let self = self else { return }
            switch bannerType {
            case .fullScreen:
                self.viewModel.deleteFullScreenBanner(param: ["banner_id": gift.id ?? 0])
            case .promotional:
                print("")
                //CALL API HERE
            }
        }
    }
    
    func bindData() {
        titleLabel.text = giftsListData?.title
        if let imageUrlString = giftsListData?.image,
           let url = URL(string: imageUrlString) {
            cardImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            cardImageView.sd_imageIndicator?.startAnimatingIndicator()
            cardImageView.sd_setImage(with: url, placeholderImage: UIImage(named: ""))
        } else {
            cardImageView.image = UIImage(named: "placeholder")
        }
        cardImageView.enableFullscreenZoom()
        countryNameLabel.text = giftsListData?.countryInfo?.name
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        
        let today = Calendar.current.startOfDay(for: Date())
        
        if giftsListData?.status == 1 {
            if let startDateStr = giftsListData?.startDate,
               let endDateStr = giftsListData?.endDate,
               let startDate = formatter.date(from: startDateStr),
               let endDate = formatter.date(from: endDateStr) {
                
                let start = Calendar.current.startOfDay(for: startDate)
                let end = Calendar.current.startOfDay(for: endDate)
                
                if today < start {
                    statusLabel.text = "Upcoming"
                } else if today > end {
                    statusLabel.text = "Inactive"
                } else {
                    statusLabel.text = "Active"
                }
            } else {
                statusLabel.text = "Upcoming"
            }
        } else {
            statusLabel.text = "Inactive"
        }
        startDateLabel.text = convertDateFormat(giftsListData?.startDate ?? "")
        endDateLabel.text = convertDateFormat(giftsListData?.endDate ?? "")
        switch bannerType {
        case .fullScreen:
            if giftsListData?.type == "1" {
                typeLabel.text = "App Banner"
            } else {
                typeLabel.text = "Web Banner"
            }
        case .promotional:
            if giftsListData?.type == "1" {
                typeLabel.text = "Top"
            } else if giftsListData?.type == "2" {
                typeLabel.text = "Bottom"
            } else {
                typeLabel.text = "Category"
            }
        }
        
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
