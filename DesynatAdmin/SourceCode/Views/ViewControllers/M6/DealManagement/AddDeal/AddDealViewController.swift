//
//  AddDealViewController.swift
//  DesynatAdmin
//
//  Created by fluper on 07/01/26.
//

import UIKit
import SDWebImage
import DropDown

class AddDealViewController: UIViewController {
    
    // MARK: - IBOutlet's
    @IBOutlet weak var toTF: UITextField!
    @IBOutlet weak var fromTf: UITextField!
    @IBOutlet weak var discountTF: UITextField!
    @IBOutlet weak var subCategoryTF: UITextField!
    @IBOutlet weak var fullNameInArabicTF: UITextField!
    @IBOutlet weak var fullNameTF: UITextField!
    @IBOutlet weak var mainImageView: CustomImageView!
    @IBOutlet weak var buttonTitleLabel: UILabel!
    @IBOutlet weak var pageTitleLabel: UILabel!
    @IBOutlet weak var selectCategoryCollectionview: UICollectionView! {
        didSet {
            selectCategoryCollectionview.registerCellFromNib(cellID: "DurationCollectionViewCell")
        }
    }
    
    // MARK: - Property Decalaration
    var comingforEdit: Bool = false
    private lazy var viewModel = AddDealViewModel(hostVC: self)
    var selectedImageUrl: String = ""
    let datePicker = UIDatePicker()
    private var activeTextField: UITextField?
    var dealData: DealListManagementList?
    var selectedIndexes = Set<Int>()
    var selectedIds: [String] = []
    var subCategoryNames: [String] {
        return ["Select All".localiz()] + viewModel.subcategoriesList.map {
            $0.nameEnglish ?? ""
        }
    }
    private var subCategoryDropdown: MultiSelectDropdownView?
    
    // MARK: - View's LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.getAllCategory()
        initialSetUp()
    }
    
    // MARK: - Button's Action
    @IBAction func backDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func uplaodImageDidTapped(_ sender: Any) {
        ImagePickerManager().pickImage(self) { [weak self] image, fileName, url in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.mainImageView.image = image
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
    
    @IBAction func selecteSubCategoryDidTapped(_ sender: UIButton) {
        let dropdown = MultiSelectDropdownView(
            items: subCategoryNames,
            selectedIndexes: selectedIndexes
        )
        dropdown.frame = view.bounds   // REQUIRED
        
        dropdown.onSelectionChanged = { [weak self] indexes in
            self?.selectedIndexes = indexes
            self?.updateSelection()
        }
        
        dropdown.onClose = { [weak self] in
            self?.subCategoryDropdown = nil
        }
        
        subCategoryDropdown = dropdown
        view.addSubview(dropdown)
    }
    
    @IBAction func submitDidTapped(_ sender: Any) {
        if viewModel.validFields() {
            if comingforEdit {
                viewModel.editCardApi()
            } else {
                viewModel.addCardApi()
            }
        }
    }
    
    //MARK: Function's declaration
    private func updateSelection() {
        
        let validIndexes = selectedIndexes
            .filter { $0 > 0 }
            .sorted()
        
        let items = validIndexes.compactMap { index -> GetSubCategoryDataList? in
            let arrayIndex = index - 1
            guard viewModel.subcategoriesList.indices.contains(arrayIndex) else {
                return nil
            }
            return viewModel.subcategoriesList[arrayIndex]
        }
        
        let names = items.compactMap { $0.nameEnglish }
        selectedIds = items.compactMap { $0.id.map(String.init) }
        
        subCategoryTF.text = names.joined(separator: ", ")
        
        print(selectedIds)
        print(names)
    }
    
    
    private func initialSetUp() {
        setUpTextFields()
        fullNameTF.delegate = self
        fullNameInArabicTF.delegate = self
        discountTF.delegate = self
        if comingforEdit {
            pageTitleLabel.text = "Edit".localiz()
            buttonTitleLabel.text = "Save Changes".localiz()
            bindData()
        } else {
            pageTitleLabel.text = "Add Deal".localiz()
            buttonTitleLabel.text = "Submit".localiz()
        }
    }
    
    func setupPreselectedSubcategories() {
        guard let selectedSubIds = dealData?.subCategoryID else { return }
        
        var indexes = Set<Int>()
        
        for (index, item) in viewModel.subcategoriesList.enumerated() {
            if let id = item.id,
               selectedSubIds.contains(String(id)) {
                // +1 because index 0 is "Select All"
                indexes.insert(index + 1)
            }
        }
        
        // NEW: if all real items selected, select "Select All"
        let allItemIndexes = Set(1...(viewModel.subcategoriesList.count))
        if allItemIndexes == indexes {
            indexes.insert(0)
        }
        
        selectedIndexes = indexes
        updateSelection()
    }
    
    
    
    func bindData() {
        fullNameTF.text = dealData?.nameEnglish
        fullNameInArabicTF.text = dealData?.nameArabic
        if let imageUrlString = dealData?.image,
           let url = URL(string: imageUrlString) {
            mainImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            mainImageView.sd_imageIndicator?.startAnimatingIndicator()
            mainImageView.sd_setImage(with: url, placeholderImage: UIImage(named: ""))
            selectedImageUrl = imageUrlString
        }
        viewModel.selectedCategoriesId = dealData?.categoryID
        selectedIds = dealData?.subCategoryID ?? [""]
        selectCategoryCollectionview.reloadData()
        viewModel.getSubCategoriesListApi()
        subCategoryTF.text = dealData?.subCategoryDetails?.compactMap({ $0.nameEnglish }).joined(separator: ", ")
        
        discountTF.text = dealData?.discount
        fromTf.text = convertDateFormat(dealData?.from ?? "")
        toTF.text = convertDateFormat(dealData?.to ?? "")
    }
    
    func convertDateFormat(
        _ dateString: String,
        from inputFormat: String = "yyyy-MM-dd",
        to outputFormat: String = "dd/MM/yyyy"
    ) -> String? {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = inputFormat
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        guard let date = inputFormatter.date(from: dateString) else {
            return nil
        }
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = outputFormat
        outputFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        return outputFormatter.string(from: date)
    }
}

// MARK: - COLLECTION VIEW METHODS
extension AddDealViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.categoryListData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DurationCollectionViewCell", for: indexPath) as! DurationCollectionViewCell
        let data = viewModel.categoryListData[indexPath.row]
        cell.titleLabel.text = data.name
        if viewModel.selectedCategoriesId == data.id {
            cell.selectedImageView.image = UIImage(named: "durationSelected")
        } else {
            cell.selectedImageView.image = UIImage(named: "durationUnselected")
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.selectedCategoriesId = viewModel.categoryListData[indexPath.row].id
        selectCategoryCollectionview.reloadData()
        subCategoryTF.text = ""
        viewModel.getSubCategoriesListApi()
        selectedIds = []
        selectedIndexes = []
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = selectCategoryCollectionview.frame.width / 3
        return CGSize(width: width, height: 25)
    }
    
}

//MARK: UITextFieldDelegate Methods
extension AddDealViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        //    let updatedText = currentText.replacingCharacters(in: range, with: string)
        var validation: StringValidation?
        
        if string.isEmpty { return true }
        
        if textField == fullNameTF {
            if currentText.hasPrefix(" ") {
                return false
            }
            validation = StringValidation(string: currentText, characterCount: 30, validation: .firstName)
        }
        
        if textField == discountTF {
            
            // Allow delete
            if string.isEmpty { return true }
            
            // Allow digits and decimal point only
            let allowedCharacters = CharacterSet(charactersIn: "0123456789.")
            if string.rangeOfCharacter(from: allowedCharacters.inverted) != nil {
                return false
            }
            
            // Allow only one decimal point
            let components = currentText.components(separatedBy: ".")
            if components.count > 2 {
                return false
            }
            
            // Prevent starting with "."
            if currentText.hasPrefix(".") {
                return false
            }
            
            // Limit to max 2 decimal places
            if components.count == 2 {
                let decimalPart = components[1]
                if decimalPart.count > 2 {
                    return false
                }
            }
            
            // Validate range 0–100
            if let value = Double(currentText) {
                return value >= 0 && value <= 100
            }
            
            return false
        }
        
        
        
        if textField == fullNameInArabicTF {
            
            // Allowed Arabic Unicode ranges + spaces
            let allowedSet = CharacterSet(charactersIn: "\u{0600}"..."\u{06FF}")
                .union(CharacterSet(charactersIn: "\u{0750}"..."\u{077F}"))
                .union(CharacterSet(charactersIn: "\u{08A0}"..."\u{08FF}"))
                .union(CharacterSet.whitespaces)
            
            // Check every character (handles paste)
            for scalar in string.unicodeScalars {
                if !allowedSet.contains(scalar) {
                    CommonUtils.showToast(message: "Please switch to Arabic keyboard".localiz())
                    return false
                }
            }
            
            return true
        }
        
        if let data = validation {
            return data.validate()
        } else {
            return true
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        if textField == toTF {
            if let fromText = fromTf.text,
               let fromDate = formatter.date(from: fromText) {
                datePicker.minimumDate = fromDate
            } else {
                datePicker.minimumDate = nil
            }
        }
        if textField == fromTf {
            datePicker.minimumDate = Date()
        }
    }
}

extension AddDealViewController {
    private func setUpTextFields() {
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .date
        //datePicker.minimumDate = nil
        datePicker.backgroundColor = .white
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done".localiz(), style: .done, target: self, action: #selector(doneDatePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel".localiz(), style: .plain, target: self, action: #selector(cancelDatePicker))
        toolbar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        
        fromTf.inputView = datePicker
        fromTf.inputAccessoryView = toolbar
        toTF.inputView = datePicker
        toTF.inputAccessoryView = toolbar
        
        fromTf.delegate = self
        toTF.delegate = self
    }
    
    @objc private func doneDatePicker() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        
        if activeTextField == fromTf {
            fromTf.text = formatter.string(from: datePicker.date)
            if let toText = toTF.text,
               let toDate = formatter.date(from: toText),
               toDate < datePicker.date {
                toTF.text = ""
            }
        }
        
        else if activeTextField == toTF {
            if let fromText = fromTf.text,
               let fromDate = formatter.date(from: fromText),
               datePicker.date < fromDate {
                showValidationAlert()
                return
            }
            toTF.text = formatter.string(from: datePicker.date)
        }
        view.endEditing(true)
    }
    
    private func showValidationAlert() {
        let alert = UIAlertController(title: "Invalid Date".localiz(),
                                      message: "To Date cannot be earlier than From Date.".localiz(),
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK".localiz(), style: .default))
        self.present(alert, animated: true)
    }
    
    @objc private func cancelDatePicker() {
        view.endEditing(true)
    }
}

