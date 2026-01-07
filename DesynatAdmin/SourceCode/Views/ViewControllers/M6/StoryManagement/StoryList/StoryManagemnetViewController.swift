//
//  StoryManagemnetViewController.swift
//  DesynatAdmin
//
//  Created by fluper on 07/01/26.
//

import UIKit

class StoryManagemnetViewController: UIViewController {

  @IBOutlet weak var storyCollectionView: UICollectionView! {
    didSet {
      storyCollectionView.registerCellFromNib(cellID: "StoryManagemnetCollectionViewCell")
      storyCollectionView.registerCellFromNib(cellID: "StoryUploadCollectionViewCell")
    }
  }
  
    override func viewDidLoad() {
        super.viewDidLoad()
//      if let layout = storyCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
//              layout.estimatedItemSize = .zero   // 🔥 IMPORTANT
//              layout.minimumInteritemSpacing = 10
//              layout.minimumLineSpacing = 10
//          }
    }
    

  @IBAction func backDidTapped(_ sender: Any) {
    self.navigationController?.popViewController(animated: true)
  }


}

extension StoryManagemnetViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 4
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    if indexPath.row == 0 {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StoryUploadCollectionViewCell", for: indexPath) as! StoryUploadCollectionViewCell
      return cell
    } else {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StoryManagemnetCollectionViewCell", for: indexPath) as! StoryManagemnetCollectionViewCell
      return cell
    }
    
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    if indexPath.row == 0 {
      let nextVC = AddStoryViewController.instantiate(fromAppStoryboard: .LiveStoryDealManagement)
      self.navigationController?.pushViewController(nextVC, animated: true)
    }
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    let width = (storyCollectionView.frame.width - 20) / 2
    let height: CGFloat = 220
    return CGSize(width: width, height: height)
  }
  
}
