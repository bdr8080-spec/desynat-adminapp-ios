//
//  UserManagementDetailsViewController.swift
//  DesynatAdmin
//
//  Created by fluper on 21/11/25.
//

import UIKit
import SDWebImage

class UserManagementDetailsViewController: UIViewController {

  @IBOutlet weak var usernameLabel: UILabel!
  @IBOutlet weak var mainImageView: CustomImageView!
  @IBOutlet weak var locationLabel: UILabel!
  @IBOutlet weak var statusButton: UIButton!
  @IBOutlet weak var phoneLabel: UILabel!
  @IBOutlet weak var emailLabel: UILabel!
  @IBOutlet weak var walletBalanceCount: UILabel!
  @IBOutlet weak var joinedLabel: UILabel!
  @IBOutlet weak var completedOrderCount: UILabel!
  @IBOutlet weak var cancelledOrderCount: UILabel!
  
  
  var userId: Int? = 0
  private lazy var viewModel = UserManagementDetailViewModel(hostVC: self)
  
    override func viewDidLoad() {
        super.viewDidLoad()

    }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
      viewModel.getAUserDetails()
  }
    

  @IBAction func addMoneyDidTapped(_ sender: Any) {
    let nextVC = AddAmountForUserViewController.instantiate(fromAppStoryboard: .ReasonManagement)
    nextVC.userId = userId
    nextVC.onAmountAdded = { [weak self] in
        guard let self = self else { return }
        self.viewModel.getAUserDetails()   // reload API
    }
    self.navigationController?.present(nextVC, animated: true)
  }
  
  
  @IBAction func backDidTapped(_ sender: Any) {
    self.navigationController?.popViewController(animated: true)
  }
  
  @IBAction func updateStatusDidTapped(_ sender: Any) {
    guard var user = viewModel.userDetail else { return }
    let newStatus = user.status == "1" ? "0" : "1"
      let params: [String: Any] = ["user_id": user.id ?? 0]
      viewModel.updateActiveStatus(param: params) { [weak self] success in
        guard let self = self else { return }
        if success {
          user.status = newStatus
          configData(data: user)
          if let status = user.status {
            if status == "1" {
              CommonUtils.showToast(message: "User has been activated Successfully")
            } else {
              CommonUtils.showToast(message: "User has been Deactivated Successfully")
            }
          }
        }
      }
  }
  
  func configData(data: UsersListModel) {
    usernameLabel.text = data.fullName
    if let imageUrlString = data.profileImage,
       let url = URL(string: imageUrlString) {
      mainImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
      mainImageView.sd_imageIndicator?.startAnimatingIndicator()
      mainImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "userProfile"))
    } else {
      mainImageView.image = UIImage(named: "userProfile")
    }
    
    locationLabel.text = data.countryInfo?.name
    let result = convertISOToDMY(data.createdAt ?? "") ?? ""
    joinedLabel.text = "Joined on \(result)"
    phoneLabel.text = "\(data.countryCode ?? "")-\(data.mobile ?? "")"
    emailLabel.text = data.email
    walletBalanceCount.text = "\(data.walletInfo?.amount ?? "") KD"
//    completedOrderCount.text = data.
    if data.status == "1" {
      statusButton.setImage(UIImage(named: "toggleOn"), for: .normal)
    } else {
      statusButton.setImage(UIImage(named: "toggleOff"), for: .normal)
    }
  }
  
  private func convertISOToDMY(_ isoString: String) -> String? {
      // ISO8601 parser
      let isoFormatter = ISO8601DateFormatter()
      isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

      // Parse to Date
      guard let date = isoFormatter.date(from: isoString) else {
          return nil
      }

      // Output formatter
      let outputFormatter = DateFormatter()
      outputFormatter.dateFormat = "dd/MM/yyyy"

      return outputFormatter.string(from: date)
  }
  

}
