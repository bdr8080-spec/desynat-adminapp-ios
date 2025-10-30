//
//  HomeViewController.swift
//  DesynatUser
//
//  Created by Rakhi Kumari on 23/10/25.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var revenueDetailsView: UIView!
    @IBOutlet weak var totalRevenueIImageView: UIImageView!
    @IBOutlet weak var durationCollectionView: UICollectionView! {
        didSet {
            durationCollectionView.registerCellFromNib(cellID: "DurationCollectionViewCell")
        }
    }
    
    private var durationArray = ["Today", "Week", "Month", "Year"]
    private var durationSelectedIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uiSetup()
    }
    
    private func uiSetup() {
        totalRevenueIImageView.layer.cornerRadius = 16
        totalRevenueIImageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        totalRevenueIImageView.clipsToBounds = true
        revenueDetailsView.layer.cornerRadius = 16
        revenueDetailsView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        revenueDetailsView.clipsToBounds = true

    }
    
//    override func viewWillLayoutSubviews() {
//        super.viewWillLayoutSubviews()
//        DispatchQueue.main.async {
//            self.updateCollectionsHeight()
//        }
//    }
    
    
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return durationArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DurationCollectionViewCell", for: indexPath) as! DurationCollectionViewCell
        cell.titleLabel.text = durationArray[indexPath.row]
        if durationSelectedIndex == indexPath.row {
            cell.selectedImageView.image = UIImage(named: "radioSelected")
        } else {
            cell.selectedImageView.image = UIImage(named: "radioUnselected")
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        durationSelectedIndex = indexPath.row
        durationCollectionView.reloadData()
    }
    
    
    
}

