//
//  DealDetailsViewController.swift
//  DesynatAdmin
//
//  Created by fluper on 07/01/26.
//

import UIKit

class DealDetailsViewController: UIViewController {
  
  @IBOutlet weak var previousButton: UIButton!
  @IBOutlet weak var nextButton: UIButton!
  @IBOutlet weak var pageCountLabel: UILabel!
  @IBOutlet weak var enrollTableView: UITableView! {
    didSet {
      enrollTableView.registerCellFromNib(cellID: "EnrolledSellerTableViewCell")
    }
  }
  
  @IBOutlet weak var activeButtonStackView: UIStackView!
  @IBOutlet weak var revenueDetailsView: CustomView!
  var type: Int = 1 // 1 active 2 expired
  
  override func viewDidLoad() {
        super.viewDidLoad()
    if type == 1 {
      activeButtonStackView.isHidden = false
      revenueDetailsView.isHidden = true
    } else {
      activeButtonStackView.isHidden = true
      revenueDetailsView.isHidden = false
    }
        // Do any additional setup after loading the view.
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
