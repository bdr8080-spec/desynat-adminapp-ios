//
//  FullScreenBanerDetailsViewController.swift
//  DesynatAdmin
//
//  Created by fluper on 08/01/26.
//

import UIKit
import SDWebImage

class FullScreenBanerDetailsViewController: UIViewController {

  @IBOutlet weak var statusImageView: UIImageView!
  @IBOutlet weak var statusLabel: UILabel!
  @IBOutlet weak var countryNameLabel: UILabel!
  @IBOutlet weak var cardImageView: CustomImageView!
  @IBOutlet weak var endDateLabel: UILabel!
  @IBOutlet weak var startDateLabel: UILabel!
  @IBOutlet weak var titleLabel: UILabel!
  
  var bannerId: Int = 0
  var giftsListData: FullScreenBannerDataList?
  private lazy var viewModel = FullScreenBannerDetailsViewModel(hostVC: self)
  
  override func viewDidLoad() {
      super.viewDidLoad()
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
  
//  @IBAction func statusDidTapped(_ sender: Any) {
//      guard let card = giftsListData else { return }
//      viewModel.upadteCardStatus(param: ["giftCard_id": card.id ?? 0])
//  }
  
  
  @IBAction func deleteDidTapped(_ sender: Any) {
      guard let gift = giftsListData else { return }
      self.showConfirmationAlert(msg: "Are you sure you want to delete this banner"){ [weak self] in
          guard let self = self else { return }
          self.viewModel.deleteFullScreenBanner(param: ["banner_id": gift.id ?? 0])
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
        
//      statusImageView.image = UIImage(named: "toggleOn")
    } else {
      statusLabel.text = "Inactive"
//      statusImageView.image = UIImage(named: "toggleOff")
    }
    startDateLabel.text = convertDateFormat(giftsListData?.startDate ?? "")
    endDateLabel.text = convertDateFormat(giftsListData?.endDate ?? "")
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
