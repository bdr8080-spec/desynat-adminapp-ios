//
//  FullScreenBannerViewController.swift
//  DesynatAdmin
//
//  Created by fluper on 08/01/26.
//

import UIKit

class FullScreenBannerViewController: UIViewController {

  @IBOutlet weak var noDataFoundLabel: UILabel!
  @IBOutlet weak var previousButton: UIButton!
  @IBOutlet weak var nextButton: UIButton!
  @IBOutlet weak var pageCountLabel: UILabel!
  @IBOutlet weak var searchTextField: UITextField!
  @IBOutlet weak var bannerTableView: UITableView! {
      didSet {
        bannerTableView.registerCellFromNib(cellID: "FullScreenBannerTableViewCell")
      }
  }
  
  private lazy var viewModel = FullScreenBannerViewModel(hostVC: self)
  private var searchWorkItem: DispatchWorkItem?
  
  override func viewDidLoad() {
      super.viewDidLoad()
      searchTextField.delegate = self
      updatePaginationButtonImages()
  }
  
  override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      viewModel.currentPage = 1
      viewModel.getAllFullScreenBanners()
  }

  @IBAction func backDidTapped(_ sender: Any) {
      self.navigationController?.popViewController(animated: true)
  }
  
  @IBAction func plusDidTapped(_ sender: Any) {
      let vc = AddAdvertisementViewController.instantiate(fromAppStoryboard: .AffiliatedBannerOrder)
      vc.isComingForEdit = false
      self.navigationController?.pushViewController(vc, animated: false)
  }
  
  @IBAction func nextButtonAction(_ sender: Any) {
      viewModel.goToNextPage()
  }
  
  @IBAction func previousButtonAction(_ sender: Any) {
      viewModel.goToPreviousPage()
  }
  
  
  @IBAction func filterDidTapped(_ sender: Any) {
    let vc = FullScreenBannerFilterViewController.instantiate(fromAppStoryboard: .AffiliatedBannerOrder)
       vc.selectedFilter = viewModel.appliedFilter
       vc.onApplyFilter = { [weak self] filter in
           guard let self = self else { return }
           self.viewModel.appliedFilter = filter
           self.viewModel.currentPage = 1
           self.viewModel.getAllFullScreenBanners()
       }
       vc.onClearFilter = { [weak self] in
           guard let self = self else { return }
           self.viewModel.appliedFilter = FullScreenBannerFilterModel()
           self.viewModel.currentPage = 1
           self.viewModel.getAllFullScreenBanners()
       }
       self.navigationController?.present(vc, animated: true)
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

extension FullScreenBannerViewController: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return viewModel.brandListData.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: "FullScreenBannerTableViewCell", for: indexPath) as! FullScreenBannerTableViewCell
      let data = viewModel.brandListData[indexPath.row]
      cell.configData(data: data)
      return cell
  }
  
//  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//      return 178
//  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      let vc = FullScreenBanerDetailsViewController.instantiate(fromAppStoryboard: .AffiliatedBannerOrder)
    vc.bannerId = viewModel.brandListData[indexPath.row].id ?? 0
      self.navigationController?.pushViewController(vc, animated: false)
  }
  
}

extension FullScreenBannerViewController: UITextFieldDelegate {
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
      let currentText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
      
      // Cancel previous search work item
      searchWorkItem?.cancel()
      
      // Create new one
      let workItem = DispatchWorkItem { [weak self] in
          guard let self = self else { return }
          self.viewModel.searchText = currentText
          self.viewModel.currentPage = 1
          self.viewModel.getAllFullScreenBanners()
      }
      
      // Store and execute after delay
      searchWorkItem = workItem
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: workItem)
      
      return true
  }
}
