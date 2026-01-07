//
//  DealsManagementListViewController.swift
//  DesynatAdmin
//
//  Created by fluper on 07/01/26.
//

import UIKit

class DealsManagementListViewController: UIViewController {

  @IBOutlet weak var previousButton: UIButton!
  @IBOutlet weak var nextButton: UIButton!
  @IBOutlet weak var pageCountLabel: UILabel!
  @IBOutlet weak var activeButtonOutlet: CustomButton!
  @IBOutlet weak var expiredButtonOutlet: CustomButton!
  @IBOutlet weak var expiredLabel: UILabel!
  @IBOutlet weak var activeLabel: UILabel!
  @IBOutlet weak var noDataFoundLabel: UILabel!
  @IBOutlet weak var dealsTableview: UITableView! {
    didSet {
      dealsTableview.registerCellFromNib(cellID: "DealsManagementListTableViewCell")
    }
  }
  
//  var type: DealsManagementTab = .active
  var type: Int = 1
  private lazy var viewModel = DealsManagementListViewModel(hostVC: self)
  
  override func viewDidLoad() {
        super.viewDidLoad()

    }
    

  @IBAction func backDidTapped(_ sender: Any) {
    self.navigationController?.popViewController(animated: true)
  }
  
  @IBAction func activedidTapped(_ sender: Any) {
    activeButtonOutlet.setImage(UIImage(named: "btnGradient"), for: .normal)
    activeLabel.textColor = UIColor.white
    expiredButtonOutlet.setImage(UIImage(named: ""), for: .normal)
    expiredLabel.textColor = UIColor.black
    type = 1
//    txtFieldSearch.text = ""
//    viewModel.changeTab(.approved)
  }
  
  @IBAction func expiredDidTapped(_ sender: Any) {
    activeButtonOutlet.setImage(UIImage(named: ""), for: .normal)
    activeLabel.textColor = UIColor.black
    expiredButtonOutlet.setImage(UIImage(named: "btnGradient"), for: .normal)
    expiredLabel.textColor = UIColor.white
    type = 2
  }
  
  @IBAction func serchDidTapped(_ sender: Any) {
  }
  
  @IBAction func plusDidTapped(_ sender: Any) {
    let nextVC = AddDealViewController.instantiate(fromAppStoryboard: .LiveStoryDealManagement)
    self.navigationController?.pushViewController(nextVC, animated: true)
  }
  
  @IBAction func nextDidTapped(_ sender: Any) {
    viewModel.goToNextPage(type: type)
  }
  
  @IBAction func previousDidTapped(_ sender: Any) {
    viewModel.goToPreviousPage(type: type)
  }
  
  func updatePaginationButtonImages() {
    // Previous Button
    if viewModel.currentPage == 1 {
      previousButton.setImage(UIImage(named: "previousLeft"), for: .normal)
      previousButton.isUserInteractionEnabled = false
    } else {
      previousButton.setImage(UIImage(named: "darkpreviousimage"), for: .normal)
      previousButton.isUserInteractionEnabled = true
    }
    
    // Next Button
    if viewModel.currentPage >= viewModel.totalPages {
      nextButton.setImage(UIImage(named: "lightnextimage"), for: .normal)
      nextButton.isUserInteractionEnabled = false
    } else {
      nextButton.setImage(UIImage(named: "nextRight"), for: .normal)
      nextButton.isUserInteractionEnabled = true
    }
  }
  
}

extension DealsManagementListViewController: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 3//viewModel.reasonListData.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "DealsManagementListTableViewCell", for: indexPath) as! DealsManagementListTableViewCell
//    let data = viewModel.reasonListData[indexPath.row]
//    cell.delegate = self
//    cell.configData(data: data)
//    cell.onStatusToggle = { [weak self] in
//      guard let self = self else { return }
//      self.toggleReasonStatus(at: indexPath)
//    }
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let nextVC = DealDetailsViewController.instantiate(fromAppStoryboard: .LiveStoryDealManagement)
    nextVC.type = type
    self.navigationController?.pushViewController(nextVC, animated: true)
  }
  
}
//
//enum DealsManagementTab {
//  case active
//  case expired
//}
