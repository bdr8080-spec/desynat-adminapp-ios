//
//  SendNewNotificationViewController.swift
//  DesynatAdmin
//
//  Created by fluper_mac3 on 13/03/26.
//

import UIKit

class SendNewNotificationViewController: UIViewController {
    
    // MARK: - IBOutlet's
    @IBOutlet weak var sendToCollectionView: UICollectionView! {
        didSet {
            sendToCollectionView.registerCellFromNib(cellID: "DurationCollectionViewCell")
        }
    }
    @IBOutlet weak var selectedUserNameTF: UITextField!
    
    // MARK: - Property Decalaration
    private var sendToArray = ["Customer", "Seller", "Driver", "All"]
    var selectedRoleIndex = 0
    
    // MARK: - View's LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    // MARK: - Button's Action
    
    @IBAction func backDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func submitDidTapped(_ sender: Any) {
        CommonUtils.showToast(message: "New Notification sent successfully")
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func selectCustomerDidTapped(_ sender: Any) {
        let nextVC = SelectUsersForNotificationsViewController.instantiate(fromAppStoryboard: .NotificationCMS)
        nextVC.onUserSelected = { selectedUserID in
            self.selectedUserNameTF.text = "user \(selectedUserID)"
        }
        self.navigationController?.present(nextVC, animated: true)
    }
    
    //MARK: Function's declaration
}

// MARK: - COLLECTION VIEW METHODS
extension SendNewNotificationViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sendToArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DurationCollectionViewCell", for: indexPath) as! DurationCollectionViewCell
        cell.titleLabel.text = sendToArray[indexPath.row]
        if selectedRoleIndex == indexPath.row {
            cell.selectedImageView.image = .radioSelected
        } else {
            cell.selectedImageView.image = .radioUnselected
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedRoleIndex = indexPath.row
        sendToCollectionView.reloadData()
    }
    
}
