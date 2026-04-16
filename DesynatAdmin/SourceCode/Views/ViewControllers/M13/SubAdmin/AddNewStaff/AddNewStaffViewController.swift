//
//  AddNewStaffViewController.swift
//  DesynatDealer
//
//  Created by  shailendra singh on 24/03/26.
//

import UIKit
import SDWebImage

class AddNewStaffViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var roleSelectionCollectionView: UICollectionView!{
        didSet{
            roleSelectionCollectionView.dataSource = self
            roleSelectionCollectionView.delegate = self
            roleSelectionCollectionView.registerCellFromNib(cellID: "RadioBtnCollectionViewCell")
        }
    }
    @IBOutlet weak var accessModuleTableView: TableViewDynamicHeight!{
        didSet{
            accessModuleTableView.registerCellFromNib(cellID: "AccessModuleTableViewCell")
        }
    }
    
    @IBOutlet weak var uploadNewProfileImageView: CustomImageView!
    @IBOutlet weak var addBtnLbl: UILabel!
    @IBOutlet weak var confirmPasswortTxtField: UITextField!
    @IBOutlet weak var passwordTxtField: UITextField!
    @IBOutlet weak var editStaffView: UIView!
    @IBOutlet weak var addNewStaffView: CustomView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var userProfileImageView: UIImageView!
    @IBOutlet weak var countryCodeTF: UITextField!
    @IBOutlet weak var fullNameInEnglishTF: UITextField!
    @IBOutlet weak var fullNameInArabicTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var mobileTF: UITextField!
    
    // MARK: - Variable
    var selectedRoleIndex: Int = -1
    private var selectedAccessModule: Int?
    private lazy var viewModel = AddNewStaffViewModel(hostVC: self)
    var selectedImageUrl: String = ""
    var countryCode: String = "+965"
    var comingReason: comingFrom?
    let roles = ["Manager", "Officer", "Sales employee"]
    var selectedRow: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fullNameInEnglishTF.delegate = self
        fullNameInArabicTF.delegate = self
        viewModel.getAllCountry() {
            self.initialSetup()
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        DispatchQueue.main.async {
            self.tableViewHeightConstraint.constant = self.accessModuleTableView.contentSize.height
        }
    }
    
    // MARK: - Navigation
    @IBAction func backbtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func passwordEyebtn(_ sender: UIButton) {
        sender.isSelected.toggle()
        passwordTxtField.isSecureTextEntry.toggle()
    }
    
    @IBAction func confirmPasswordEyebtn(_ sender: UIButton) {
        sender.isSelected.toggle()
        confirmPasswortTxtField.isSecureTextEntry.toggle()
    }
    
    @IBAction func changeImageProfileDidTapped(_ sender: Any) {
        ImagePickerManager().pickImage(self) { [weak self] image, fileName, url in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.userProfileImageView.image = image
            }
            guard let compressedImage = image.jpegData(compressionQuality: 0.25),
                  let finalImage = UIImage(data: compressedImage) else {
                return
            }
            self.viewModel.uploadDocument(file: finalImage, isImage: true) { [weak self] uploadedUrl in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.selectedImageUrl = uploadedUrl
                }
            }
        }
    }
    
    @IBAction func addNewImageProfileDidTapped(_ sender: Any) {
        ImagePickerManager().pickImage(self) { [weak self] image, fileName, url in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.uploadNewProfileImageView.image = image
            }
            guard let compressedImage = image.jpegData(compressionQuality: 0.25),
                  let finalImage = UIImage(data: compressedImage) else {
                return
            }
            self.viewModel.uploadDocument(file: finalImage, isImage: true) { [weak self] uploadedUrl in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.selectedImageUrl = uploadedUrl
                }
            }
        }
    }
    
    @IBAction func countryCodeDidTapped(_ sender: UIButton) {
        let countryNames = viewModel.countryListData.map { country -> String in
            let name = country.name ?? ""
            let dialCode = country.dialCode ?? ""
            let flag = country.flag ?? "🇰🇼"
            return "\(flag)  \(name) (\(dialCode))"
        }
        kSharedAppDelegate.dropDown(dataSource: countryNames, anchorView: sender) { index, item in
            let selectedCountry = self.viewModel.countryListData[index]
            self.countryCodeTF.text = selectedCountry.dialCode
            self.countryCode = selectedCountry.dialCode ?? "+965"
        }
    }
    
    @IBAction func addDidTapped(_ sender: Any) {
        if viewModel.validFields() {
            if comingReason == .editStaff {
                viewModel.editStaffDetails()
            } else {
                viewModel.addNewStaff()
            }
        }
    }
    
    @IBAction func clearDidTapped(_ sender: Any) {
        self.showConfirmationAlert(msg: "Are you sure you want to cancel this changes?"){ [weak self] in
            guard let self = self else { return }
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    // MARK: - Function
    func initialSetup() {
        switch comingReason {
        case .addNewStaff:
            titleLbl.text = "Add New Staff"
            addNewStaffView.isHidden = false
            editStaffView.isHidden = true
            addBtnLbl.text = "ADD"
        case .editStaff:
            titleLbl.text = "Edit"
            editStaffView.isHidden = false
            addNewStaffView.isHidden = true
            addBtnLbl.text = "Save changes"
            configData()
        case nil:
            return
        }
    }
    
    func configData() {
        let data = viewModel.userProfile
        if let imageUrlString = data?.profileImage,
           let url = URL(string: imageUrlString) {
            selectedImageUrl = imageUrlString
            userProfileImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            userProfileImageView.sd_imageIndicator?.startAnimatingIndicator()
            userProfileImageView.sd_setImage(with: url, placeholderImage: .userProfile)
        } else {
            userProfileImageView.image = .userProfile
        }
        
    }
    
}

extension AddNewStaffViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return roles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RadioBtnCollectionViewCell", for: indexPath) as! RadioBtnCollectionViewCell
        cell.titleLbl.text = roles[indexPath.row]
        let isSelected = selectedRoleIndex == indexPath.row
        cell.updateSelectionState(isSelected: isSelected)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let text = roles[indexPath.row]
        let font = UIFont(name: "Poppins-Medium", size: 14) ?? UIFont.systemFont(ofSize: 14)
        let width = (text as NSString).size(withAttributes: [.font: font]).width
        return CGSize(width: width + 16, height: 24)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedRoleIndex = indexPath.row
        roleSelectionCollectionView.reloadData()
        print("Selected role: \(roles[indexPath.row])")
    }
    
}
extension AddNewStaffViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AccessModuleTableViewCell") as! AccessModuleTableViewCell
        if selectedRow == indexPath.row {
            cell.selectedIndex = -1
            cell.isOuterRowSelected = true
            cell.radioimageView.image = .radioSelected
            cell.collectionView.reloadData()
        } else {
            cell.selectedIndex = -1
            cell.isOuterRowSelected = false
            cell.radioimageView.image = .radioUnselected
            cell.collectionView.reloadData()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        viewWillLayoutSubviews()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRow = indexPath.row
        tableView.reloadData()
    }
}

extension AddNewStaffViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        var validation: StringValidation?
        if string.isEmpty { return true }
        if textField == fullNameInEnglishTF {
            if !isAllowedEnglish(currentText) {
                CommonUtils.showToast(message: "Please switch to English keyboard")
                return false
            }
        }
        if textField == fullNameInArabicTF {
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

enum comingFrom {
    case addNewStaff, editStaff
}
