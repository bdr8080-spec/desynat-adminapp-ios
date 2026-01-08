//
//  DealDetailsViewController.swift
//  DesynatAdmin
//
//  Created by fluper on 07/01/26.
//

import UIKit
import SDWebImage

class DealDetailsViewController: UIViewController {
  
  @IBOutlet weak var mainImageView: CustomImageView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var previousButton: UIButton!
  @IBOutlet weak var nextButton: UIButton!
  @IBOutlet weak var pageCountLabel: UILabel!
  @IBOutlet weak var enrollTableView: UITableView! {
    didSet {
      enrollTableView.registerCellFromNib(cellID: "EnrolledSellerTableViewCell")
    }
  }
  
  @IBOutlet weak var statusImageView: UIImageView!
  @IBOutlet weak var statusLabel: UILabel!
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var discountLabel: UILabel!
  @IBOutlet weak var activeButtonStackView: UIStackView!
  @IBOutlet weak var revenueDetailsView: CustomView!
  
  var type: Int = 1 // 1 active 2 expired
  var dealId: Int = 0
  var dealData: DealListManagementList?
  private lazy var viewModel = DealDetailsViewModel(hostVC: self)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    if type == 1 {
      activeButtonStackView.isHidden = false
      revenueDetailsView.isHidden = true
    } else {
      activeButtonStackView.isHidden = true
      revenueDetailsView.isHidden = false
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    viewModel.getDealDetailsList()
  }
  
  @IBAction func backDidTapped(_ sender: Any) {
    self.navigationController?.popViewController(animated: true)
  }
  
  @IBAction func nextDidTapped(_ sender: Any) {
    //    viewModel.goToNextPage(type: type)
  }
  
  @IBAction func previousDidTapped(_ sender: Any) {
    //    viewModel.goToPreviousPage(type: type)
  }
  
  @IBAction func editDidTapped(_ sender: Any) {
    let nextVC = AddDealViewController.instantiate(fromAppStoryboard: .LiveStoryDealManagement)
    nextVC.comingforEdit = true
    nextVC.dealData = dealData
    self.navigationController?.pushViewController(nextVC, animated: true)
  }
  
  @IBAction func statusDidTapped(_ sender: Any) {
    viewModel.upadteDealStatus(param: ["deal_id": dealId])
  }
  
  @IBAction func deleteDidTapped(_ sender: Any) {
    guard let gift = dealData else { return }
    self.showConfirmationAlert(msg: "Are you sure you want to delete this deal?"){ [weak self] in
        guard let self = self else { return }
        self.viewModel.deleteDealDetails(param: ["deal_id": gift.id ?? 0])
    }
  }
  
  func bindData() {
    titleLabel.text = dealData?.nameEnglish
    if let imageUrlString = dealData?.image,
       let url = URL(string: imageUrlString) {
      mainImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
      mainImageView.sd_imageIndicator?.startAnimatingIndicator()
      mainImageView.sd_setImage(with: url, placeholderImage: UIImage(named: ""))
    } else {
      mainImageView.image = UIImage(named: "")
    }
    mainImageView.enableFullscreenZoom()
    discountLabel.text = "\(CommonUtils.formatPriceStringInput(dealData?.discount, currency: "%"))"
    let startDate = convertDateFormat(dealData?.from ?? "") ?? ""
    let endDate = convertDateFormat(dealData?.to ?? "") ?? ""
    dateLabel.text = "\(startDate) - \(endDate)"
    if dealData?.status == 1 {
        statusLabel.text = "Active"
        statusImageView.image = UIImage(named: "toggleOn")
    } else {
        statusLabel.text = "Inactive"
        statusImageView.image = UIImage(named: "toggleOff")
    }
//    totalSellerLabel.text = data.t
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

extension DealDetailsViewController: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 4
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "EnrolledSellerTableViewCell", for: indexPath) as! EnrolledSellerTableViewCell
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let nextVC = EnrollDealDetailsViewController.instantiate(fromAppStoryboard: .LiveStoryDealManagement)
    nextVC.type = type
    self.navigationController?.pushViewController(nextVC, animated: true)
  }
  
}
