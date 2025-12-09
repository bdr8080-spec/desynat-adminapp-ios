//
//  BannerPerDayListViewController.swift
//  DesynatAdmin
//
//  Created by fluper on 09/12/25.
//

import UIKit

class BannerPerDayListViewController: UIViewController {

  @IBOutlet weak var noDataFoundLabel: UILabel!
  @IBOutlet weak var topButton: CustomButton!
  @IBOutlet weak var topLabel: UILabel!
  @IBOutlet weak var bottomButton: CustomButton!
  @IBOutlet weak var bottomLabel: UILabel!
  @IBOutlet weak var subCatgeoryButton: CustomButton!
  @IBOutlet weak var subCategoryLabel: UILabel!
  @IBOutlet weak var bannersTableView: UITableView! {
    didSet {
      bannersTableView.registerCellFromNib(cellID: "BannerPerDayListTableViewCell")
    }
  }
  
  var type: Int = 1 //1-top,2-bottom,3-sub category
  private lazy var viewModel = BannerPerDayListViewModel(hostVC: self)
  
  override func viewDidLoad() {
        super.viewDidLoad()
    
    }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    viewModel.getAllBannersPerDay()
  }

  @IBAction func topDidTapped(_ sender: Any) {
    topButton.setImage(UIImage(named: "btnGradient"), for: .normal)
    topLabel.textColor = UIColor.white
    bottomButton.setImage(UIImage(named: ""), for: .normal)
    bottomLabel.textColor = UIColor.black
    subCatgeoryButton.setImage(UIImage(named: ""), for: .normal)
    subCategoryLabel.textColor = UIColor.black
    type = 1
    viewModel.getAllBannersPerDay()
  }
  
  @IBAction func bottomDidTapped(_ sender: Any) {
    topButton.setImage(UIImage(named: ""), for: .normal)
    topLabel.textColor = UIColor.black
    bottomButton.setImage(UIImage(named: "btnGradient"), for: .normal)
    bottomLabel.textColor = UIColor.white
    subCatgeoryButton.setImage(UIImage(named: ""), for: .normal)
    subCategoryLabel.textColor = UIColor.black
    type = 2
    viewModel.getAllBannersPerDay()
  }
  
  @IBAction func subCategoryDidTapped(_ sender: Any) {
    topButton.setImage(UIImage(named: ""), for: .normal)
    topLabel.textColor = UIColor.black
    bottomButton.setImage(UIImage(named: ""), for: .normal)
    bottomLabel.textColor = UIColor.black
    subCatgeoryButton.setImage(UIImage(named: "btnGradient"), for: .normal)
    subCategoryLabel.textColor = UIColor.white
    type = 3
    viewModel.getAllBannersPerDay()
  }
  
  @IBAction func backDidTapped(_ sender: Any) {
    self.navigationController?.popViewController(animated: true)
  }
  
}


extension BannerPerDayListViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.bannersListData.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "BannerPerDayListTableViewCell", for: indexPath) as! BannerPerDayListTableViewCell
    let data = viewModel.bannersListData[indexPath.row]
    cell.configData(data: data)
    cell.onEditTap = { [weak self] in
      guard let self else { return }
      let nextVC = AddPricePerDayViewController.instantiate(fromAppStoryboard: .ShippingPromocode)
      nextVC.bannerDetails = data
      nextVC.onChangesAreDone = {
        self.viewModel.getAllBannersPerDay()
      }
      self.navigationController?.present(nextVC, animated: true)
    }
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
   
  }
  
}
