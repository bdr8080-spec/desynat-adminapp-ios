//
//  OrdersManagementListViewController.swift
//  DesynatAdmin
//
//  Created by fluper on 16/12/25.
//

import UIKit

class OrdersManagementListViewController: UIViewController {

  @IBOutlet weak var collectionViewMainView: CustomView!
  @IBOutlet weak var categorriesCollectionView: UICollectionView! {
    didSet {
      categorriesCollectionView.registerCellFromNib(cellID: "OrdersManagementCategoryCollectionViewCell")
    }
  }
  @IBOutlet weak var ordersTableView: UITableView! {
    didSet {
      ordersTableView.registerCellFromNib(cellID: "OrderMangementTableViewCell")
    }
  }
  
  private var orderCategoriesList = ["Active", "Return & Exchange", "Completed", "Cancelled"]
  private var selecetedCategoryId: Int = 0
  
  override func viewDidLoad() {
        super.viewDidLoad()
    }

  @IBAction func backDidTapped(_ sender: Any) {
    self.navigationController?.popViewController(animated: true)
  }
  
}

extension OrdersManagementListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return orderCategoriesList.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OrdersManagementCategoryCollectionViewCell", for: indexPath) as! OrdersManagementCategoryCollectionViewCell
    cell.configure(title: orderCategoriesList[indexPath.row])
    // Selection UI
        if selecetedCategoryId == indexPath.row {
            cell.mainImageView.isHidden = false
            cell.titleLabel.textColor = .white
        } else {
            cell.mainImageView.isHidden = true
            cell.titleLabel.textColor = .black
        }

        // ---- Corner Radius Logic ----
        let lastIndex = orderCategoriesList.count - 1

        cell.mainImageView.layer.cornerRadius = 5
        cell.mainImageView.clipsToBounds = true

        if indexPath.row == 0 {
            cell.mainImageView.layer.maskedCorners = [
                .layerMinXMinYCorner,
                .layerMinXMaxYCorner
            ]
        } else if indexPath.row == lastIndex {
            cell.mainImageView.layer.maskedCorners = [
                .layerMaxXMinYCorner,
                .layerMaxXMaxYCorner
            ]
        } else {
            cell.mainImageView.layer.cornerRadius = 0
            cell.mainImageView.layer.maskedCorners = []
        }

    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {

      let text = orderCategoriesList[indexPath.item]
      let font = UIFont.systemFont(ofSize: 14, weight: .medium)

      let textWidth = text.size(withAttributes: [.font: font]).width
      let padding: CGFloat = 24 // left + right padding

      return CGSize(width: textWidth + padding, height: 40)
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    selecetedCategoryId = indexPath.row
    categorriesCollectionView.reloadData()
  }
  
}

extension OrdersManagementListViewController: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 4//viewModel.bannersListData.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "OrderMangementTableViewCell", for: indexPath) as! OrderMangementTableViewCell
    if indexPath.row == 1 {
      cell.assignDriverView.isHidden = false
      cell.assignDriverStackView.isHidden = false
    } else {
      cell.assignDriverView.isHidden = true
      cell.assignDriverStackView.isHidden = true
    }
    cell.assignDriverTapped = { [weak self] in
      guard let self else { return }
      let nextVC = DriversListViewController.instantiate(fromAppStoryboard: .AffiliatedBannerOrder)
      self.navigationController?.present(nextVC, animated: true)
    }
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let nextVC = OrderManagementDetailsViewController.instantiate(fromAppStoryboard: .AffiliatedBannerOrder)
    self.navigationController?.pushViewController(nextVC, animated: true)
  }
  
}

