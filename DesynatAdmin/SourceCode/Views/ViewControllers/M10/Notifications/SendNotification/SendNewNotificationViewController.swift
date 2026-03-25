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
    @IBOutlet weak var titleInEnglishTF: UITextField!
    @IBOutlet weak var titleInArabicTF: UITextField!
    @IBOutlet weak var decriptionInEnglishTF: UITextView!
    @IBOutlet weak var decriptionInArabicTF: UITextView!
    
    // MARK: - Property Decalaration
    private var sendToArray = ["Customer", "Seller", "Driver", "Affiliate User"]
    var selectedRoleIndex = 0
    var selecteUserId: [Int] = []
    var selecteDealerId: [Int] = []
    var selecteDriverId: [Int] = []
    var selecteAffilatedId: [Int] = []
    private lazy var viewModel = SendNewNotificationViewModel(hostVC: self)
    
    // MARK: - View's LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        [titleInEnglishTF, titleInArabicTF]
            .forEach { $0.delegate = self }
        [decriptionInEnglishTF, decriptionInArabicTF]
            .forEach { $0.delegate = self }
    }
    
    // MARK: - Button's Action
    
    @IBAction func backDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func submitDidTapped(_ sender: Any) {
        if viewModel.validFields() {
            viewModel.sendNotificationsRequest()
        }
    }
    
    @IBAction func selectCustomerDidTapped(_ sender: Any) {
        viewModel.getUsersForSelectedRole(roleIndex: selectedRoleIndex) { [weak self] users in
            guard let self = self else { return }
            
            let nextVC = SelectUsersForNotificationsViewController.instantiate(fromAppStoryboard: .NotificationCMS)
            
            // Pass data
            nextVC.usersList = users
            switch self.selectedRoleIndex {
                case 0:
                    nextVC.preselectedUserIds = Set(self.selecteUserId)
                case 1:
                    nextVC.preselectedUserIds = Set(self.selecteDealerId)
                case 2:
                    nextVC.preselectedUserIds = Set(self.selecteDriverId)
                default:
                    nextVC.preselectedUserIds = Set(self.selecteAffilatedId)
                }
            nextVC.onUserSelected = { selectedUsers in
                
                guard !selectedUsers.isEmpty else {
                    self.selectedUserNameTF.text = ""
                    return
                }
                
                // Show like: Name + count
                let firstName = selectedUsers.first?.name ?? ""
                let remainingCount = selectedUsers.count - 1
                
                if remainingCount > 0 {
                    self.selectedUserNameTF.text = "\(firstName) + \(remainingCount)"
                } else {
                    self.selectedUserNameTF.text = firstName
                }
                
                // Extract IDs
                let ids = selectedUsers.map { $0.id }
                
                switch self.selectedRoleIndex {
                case 0:
                    self.selecteUserId = ids
                case 1:
                    self.selecteDealerId = ids
                case 2:
                    self.selecteDriverId = ids
                default:
                    self.selecteAffilatedId = ids
                }
            }
            self.present(nextVC, animated: true)
        }
    }
    
    //MARK: Function's declaration
    
}

// MARK: - COLLECTION VIEW METHODS
extension SendNewNotificationViewController: UICollectionViewDelegate, UICollectionViewDataSource {//}, UICollectionViewDelegateFlowLayout {
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
        selecteUserId.removeAll()
        selecteDealerId.removeAll()
        selecteDriverId.removeAll()
        selecteAffilatedId.removeAll()
        selectedUserNameTF.text = ""
        sendToCollectionView.reloadData()
    }
    
}

//MARK: UITextFieldDelegate Methods
extension SendNewNotificationViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        var validation: StringValidation?
        
        if string.isEmpty { return true }
        
        if textField == titleInEnglishTF {
            if !isAllowedEnglish(currentText) {
                CommonUtils.showToast(message: "Please switch to English keyboard")
                return false
            }
        }
        
        if textField == titleInArabicTF {
            if !isAllowedArabic(currentText) {
                CommonUtils.showToast(message: "Please switch to Arabic keyboard")
                return false
            }
            
            return true
        }
        
        if let data = validation {
            return data.validate()
        } else {
            return true
        }
    }
    
    private func isAllowedEnglish(_ string: String) -> Bool {
        let allowedSet = CharacterSet(charactersIn:
            "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 .,?!'-()\"&@#$%^*+=:;/\\"
        ).union(.whitespacesAndNewlines)
        
        return string.unicodeScalars.allSatisfy { allowedSet.contains($0) || $0.properties.isEmoji }
    }

    private func isAllowedArabic(_ string: String) -> Bool {
        let allowedSet = CharacterSet(charactersIn: "\u{0600}"..."\u{06FF}")
            .union(CharacterSet(charactersIn: "\u{0750}"..."\u{077F}"))
            .union(CharacterSet(charactersIn: "\u{08A0}"..."\u{08FF}"))
            .union(CharacterSet(charactersIn: "\u{FB50}"..."\u{FDFF}"))
            .union(CharacterSet(charactersIn: "\u{FE70}"..."\u{FEFF}"))
            .union(.whitespacesAndNewlines)
        
        return string.unicodeScalars.allSatisfy { allowedSet.contains($0) || $0.properties.isEmoji }
    }
}

//MARK: UITextViewDelegate Methods
extension SendNewNotificationViewController: UITextViewDelegate {
    
    func textView(_ textView: UITextView,
                  shouldChangeTextIn range: NSRange,
                  replacementText text: String) -> Bool {
        
        let currentText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        var validation: StringValidation?
        
        // Allow backspace
        if text.isEmpty { return true }
        
        // MARK: - English Description
        if textView == decriptionInEnglishTF {
            decriptionInEnglishTF.placeholderTextView = ""
            if !isAllowedEnglish(currentText) {
                CommonUtils.showToast(message: "Please switch to English keyboard")
                return false
            }
        }
        
        // MARK: - Arabic Description
        if textView == decriptionInArabicTF {
            decriptionInArabicTF.placeholderTextView = ""
            if !isAllowedArabic(currentText) {
                CommonUtils.showToast(message: "Please switch to Arabic keyboard")
                return false
            }
            
            return true
        }
        
        if let data = validation {
            return data.validate()
        } else {
            return true
        }
    }
}

struct SelectableUser {
    let id: Int
    let name: String
}
