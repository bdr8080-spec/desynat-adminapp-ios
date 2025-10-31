//
//  SubCategoryViewController.swift
//  DesynatAdmin
//
//  Created by Rakhi Kumari on 31/10/25.
//

import UIKit

class SubCategoryViewController: UIViewController {
    
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var subCategoryCollectionView: UICollectionView! {
        didSet {
            subCategoryCollectionView.registerCellFromNib(cellID: "SubCategoryCollectionViewCell")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func backDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
    
    
    @IBAction func plusDidTapped(_ sender: Any) {
        let vc = AddSubCategoryViewController.instantiate(fromAppStoryboard: .SideMenu)
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    @IBAction func nextButtonAction(_ sender: Any) {
        
    }
    
    
    @IBAction func previousButtonAction(_ sender: Any) {
    }
    
}

extension SubCategoryViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SubCategoryCollectionViewCell", for: indexPath) as! SubCategoryCollectionViewCell
            return cell
        }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spacing: CGFloat = 7
        let totalSpacing = spacing * 2 // 3 cells per row → 2 spaces between
        let width = (collectionView.frame.width - totalSpacing) / 2
        return CGSize(width: width, height: 215)
        }
    
    
}
