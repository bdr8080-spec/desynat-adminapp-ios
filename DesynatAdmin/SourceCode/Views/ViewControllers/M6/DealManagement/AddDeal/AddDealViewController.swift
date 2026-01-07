//
//  AddDealViewController.swift
//  DesynatAdmin
//
//  Created by fluper on 07/01/26.
//

import UIKit

class AddDealViewController: UIViewController {

  @IBOutlet weak var buttonTitleLabel: UILabel!
  @IBOutlet weak var pageTitleLabel: UILabel!
  @IBOutlet weak var selectCategoryCollectionview: UICollectionView! {
    didSet {
      selectCategoryCollectionview.registerCellFromNib(cellID: "DurationCollectionViewCell")
    }
  }
  private var categorySelectedIndex: Int = 0
  var comingforEdit: Bool = false
  
  override func viewDidLoad() {
        super.viewDidLoad()
    if comingforEdit {
      pageTitleLabel.text = "Edit"
      buttonTitleLabel.text = "Save Changes"
    } else {
      pageTitleLabel.text = "Add Deal"
      buttonTitleLabel.text = "Submit"
    }
    }

  @IBAction func backDidTapped(_ sender: Any) {
    self.navigationController?.popViewController(animated: true)
  }
  
  
}

extension AddDealViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3//durationArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DurationCollectionViewCell", for: indexPath) as! DurationCollectionViewCell
        //cell.titleLabel.text = durationArray[indexPath.row]
        if categorySelectedIndex == indexPath.row {
            cell.selectedImageView.image = UIImage(named: "durationSelected")
        } else {
            cell.selectedImageView.image = UIImage(named: "durationUnselected")
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      categorySelectedIndex = indexPath.row
      selectCategoryCollectionview.reloadData()
    }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let width = selectCategoryCollectionview.frame.width / 3
    return CGSize(width: width, height: 25)
  }
    
}
