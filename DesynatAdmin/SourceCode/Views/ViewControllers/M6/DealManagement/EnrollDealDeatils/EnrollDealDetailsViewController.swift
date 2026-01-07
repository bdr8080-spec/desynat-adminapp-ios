//
//  EnrollDealDetailsViewController.swift
//  DesynatAdmin
//
//  Created by fluper on 07/01/26.
//

import UIKit

class EnrollDealDetailsViewController: UIViewController {

  @IBOutlet weak var productCollectionView: UICollectionView! {
    didSet {
      productCollectionView.registerCellFromNib(cellID: "DealDetailsCollectionViewCell")
    }
  }
  var type: Int = 0
  
  override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
  @IBAction func backDidTapped(_ sender: Any) {
    self.navigationController?.popViewController(animated: true)
  }
  
  @IBAction func filterDidTapped(_ sender: Any) {
    let nextVC = FilterForDealsViewController.instantiate(fromAppStoryboard: .LiveStoryDealManagement)
    self.navigationController?.present(nextVC, animated: true)
  }
}

extension EnrollDealDetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 4
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DealDetailsCollectionViewCell", for: indexPath) as! DealDetailsCollectionViewCell
    if type == 1 {
      cell.statusButtonOutlet.isHidden = false
    } else {
      cell.statusButtonOutlet.isHidden = true
    }
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let spacing: CGFloat = 10
    let totalSpacing = spacing * 2 // 3 cells per row → 2 spaces between
    let width = (collectionView.frame.width - totalSpacing) / 2
    return CGSize(width: width, height: 220)
  }
  
}
