//
//  AddStoryViewController.swift
//  DesynatAdmin
//
//  Created by fluper on 07/01/26.
//

import UIKit

class AddStoryViewController: UIViewController {

  @IBOutlet weak var contentCollectionView: UICollectionView! {
    didSet {
      contentCollectionView.registerCellFromNib(cellID: "SelectVideoFromGalleryCollectionViewCell")
    }
  }
  override func viewDidLoad() {
        super.viewDidLoad()

    }
    
  @IBAction func backDidTapped(_ sender: Any) {
    self.navigationController?.popViewController(animated: true)
  }
  
  @IBAction func cameraDidTapped(_ sender: Any) {
    
  }
  
}

extension AddStoryViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 4
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectVideoFromGalleryCollectionViewCell", for: indexPath) as! SelectVideoFromGalleryCollectionViewCell
      return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let spacing: CGFloat = 10
    let totalSpacing = spacing * 2 // 3 cells per row → 2 spaces between
    let width = (collectionView.frame.width - totalSpacing) / 3
    return CGSize(width: width, height: 132)
  }
}
