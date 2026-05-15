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
    @IBOutlet weak var userProfileImageView: CustomImageView!
    @IBOutlet weak var countryCodeTF: UITextField!
    @IBOutlet weak var fullNameInEnglishTF: UITextField!
    @IBOutlet weak var fullNameInArabicTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var mobileTF: UITextField!
    @IBOutlet weak var selcetdCountryLabel: CustomLabelFont!
    @IBOutlet weak var changeImageButton: CustomButton!
    
    // MARK: - Variable
//    var selectedRoleIndex: Int = -1
    private var selectedAccessModule: Int?
    private lazy var viewModel = AddNewStaffViewModel(hostVC: self)
    var selectedImageUrl: String = ""
    var countryCode: String = "+965"
    var countryID: Int = -1
    var comingReason: comingFrom = .addNewStaff
//    let roles = ["Manager", "Officer", "Sales employee"]
    var selectedRow: Int?
    var moduleSelctedData: [ModulSelctedData] = []
    var staffDetails: StaffDetails?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fullNameInEnglishTF.delegate = self
        fullNameInArabicTF.delegate = self
        initialSetup()
        viewModel.getAllCountry()
        viewModel.getAllAdminModulesRequest() {
            self.accessModuleTableView.reloadData()
            self.configData()
        }
        changeImageButton.setTitle("Change Image".localiz(), for: .normal)
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
    
    @IBAction func chosseCountrydidTapped(_ sender: UIButton) {
        let countryNames = viewModel.countryListData.map { country -> String in
            let name = AppLanguageManager.shared.currentLanguage == .en ? country.name ?? "": country.nameAr ?? ""
            let dialCode = country.dialCode ?? ""
            let flag = country.flag ?? "🇰🇼"
            return "\(flag)  \(name) (\(dialCode))"
        }
        kSharedAppDelegate.dropDown(dataSource: countryNames, anchorView: sender) { index, item in
            let selectedCountry = self.viewModel.countryListData[index]
            if AppLanguageManager.shared.currentLanguage == .en {
                self.selcetdCountryLabel.text = selectedCountry.name
            }else {
                self.selcetdCountryLabel.text = selectedCountry.nameAr
            }
            self.countryID = selectedCountry.id ?? 1
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
        self.showConfirmationAlert(msg: "Are you sure you want to cancel this changes?".localiz()){ [weak self] in
            guard let self = self else { return }
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    // MARK: - Function
    func initialSetup() {
        switch comingReason {
        case .addNewStaff:
            titleLbl.text = "Add New Staff".localiz()
            addNewStaffView.isHidden = false
            editStaffView.isHidden = true
            addBtnLbl.text = "ADD".localiz()
        case .editStaff:
            titleLbl.text = "Edit".localiz()
            editStaffView.isHidden = false
            addNewStaffView.isHidden = true
            addBtnLbl.text = "Save changes".localiz()
        }
    }
    
    func configData() {
        guard let data = staffDetails else { return }

        // MARK: Profile
        if let imageUrlString = data.profilePic,
           let url = URL(string: imageUrlString) {
            selectedImageUrl = imageUrlString
            userProfileImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            userProfileImageView.sd_imageIndicator?.startAnimatingIndicator()
            userProfileImageView.sd_setImage(with: url, placeholderImage: .userProfile)
        } else {
            userProfileImageView.image = .userProfile
        }

        // MARK: Basic Data
        fullNameInEnglishTF.text = data.fullName
        fullNameInArabicTF.text = data.fullNameInArabic
        emailTF.text = data.email
        mobileTF.text = data.mobile

        countryID = Int(data.countryID ?? "1") ?? 1
        countryCode = data.countryCode ?? "+965"
        countryCodeTF.text = data.countryCode ?? "+965"
        selcetdCountryLabel.text = AppLanguageManager.shared.currentLanguage == .ar ? data.countryInfo?.nameAr : data.countryInfo?.name
        passwordTxtField.text = data.unhashedPassword
        confirmPasswortTxtField.text = data.unhashedPassword

        // MARK: Selected Modules Only
        moduleSelctedData.removeAll()

        if let permissions = staffDetails?.permissionDetails {
            for permission in permissions {
                guard let moduleId = permission.moduleID ?? permission.moduleDetails?.id else { continue }
                
                // Only add if this module exists in the current adminModulesListData
                if viewModel.adminModulesListData.contains(where: { $0.id == moduleId }) {
                    let obj = ModulSelctedData(
                        moduleId: moduleId,
                        viewSelcted: permission.canView ?? 0,
                        actionIsSelected: permission.canAction ?? 0
                    )
                    moduleSelctedData.append(obj)
                }
            }
        }

        accessModuleTableView.reloadData()

        DispatchQueue.main.async {
            self.tableViewHeightConstraint.constant = self.accessModuleTableView.contentSize.height
        }
    }
    
}


extension AddNewStaffViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.adminModulesListData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AccessModuleTableViewCell", for: indexPath) as! AccessModuleTableViewCell
        
        let module = viewModel.adminModulesListData[indexPath.row]
        let moduleId = module.id ?? 0
        
        cell.titleView.text = AppLanguageManager.shared.currentLanguage == .ar ? module.displayNameAr : module.displayName ?? ""
        cell.moduleId = moduleId
        
        // Reset defaults
        cell.viewSelected = false
        cell.actionSelected = false
        cell.isRowSelected = false
        cell.radioimageView.image = .radioUnselected
        
        // Check if this module is pre-selected
        if let selectedData = moduleSelctedData.first(where: { $0.moduleId == moduleId }) {
            cell.isRowSelected = true
            cell.viewSelected = selectedData.viewSelcted == 1
            cell.actionSelected = selectedData.actionIsSelected == 1
            cell.radioimageView.image = .radioSelected
        }
        
        cell.selectionUpdated = { [weak self] moduleId, view, action in
            self?.updateSelection(moduleId: moduleId, viewSelected: view, actionSelected: action)
        }
        
        cell.collectionView.reloadData()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row < viewModel.adminModulesListData.count else { return }
        
        let module = viewModel.adminModulesListData[indexPath.row]
        let moduleId = module.id ?? 0
        
        if let index = moduleSelctedData.firstIndex(where: { $0.moduleId == moduleId }) {
            moduleSelctedData.remove(at: index)
        } else {
            let obj = ModulSelctedData(moduleId: moduleId, viewSelcted: 1, actionIsSelected: 0)
            moduleSelctedData.append(obj)
        }
        
        tableView.reloadRows(at: [indexPath], with: .none)
    }
    
    func updateSelection(moduleId: Int, viewSelected: Bool, actionSelected: Bool) {
        if let index = moduleSelctedData.firstIndex(where: { $0.moduleId == moduleId }) {
            if viewSelected == false && actionSelected == false {
                moduleSelctedData.remove(at: index)
            } else {
                moduleSelctedData[index].viewSelcted = viewSelected ? 1 : 0
                moduleSelctedData[index].actionIsSelected = actionSelected ? 1 : 0
            }
        } else {
            if viewSelected || actionSelected {
                let obj = ModulSelctedData(moduleId: moduleId,viewSelcted: viewSelected ? 1 : 0,actionIsSelected: actionSelected ? 1 : 0)
                moduleSelctedData.append(obj)
            }
        }
        let indexPath = IndexPath(row: moduleId - 1, section: 0)
        accessModuleTableView.reloadRows(at: [indexPath], with: .none)
    }
}

extension AddNewStaffViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        var validation: StringValidation?
        if string.isEmpty { return true }
        if textField == fullNameInEnglishTF {
            if !isAllowedEnglish(currentText) {
                CommonUtils.showToast(message: "Please switch to English keyboard".localiz())
                return false
            }
        }
        if textField == fullNameInArabicTF {
            if !isAllowedArabic(currentText) {
                CommonUtils.showToast(message: "Please switch to Arabic keyboard".localiz())
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
