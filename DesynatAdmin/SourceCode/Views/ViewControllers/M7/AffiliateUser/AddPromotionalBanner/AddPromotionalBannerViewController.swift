//
//  AddPromotionalBannerViewController.swift
//  DesynatAdmin
//
//  Created by fluper_mac3 on 04/02/26.
//

import UIKit
import SDWebImage

class AddPromotionalBannerViewController: UIViewController {
    
    // MARK: - IBOutlet's
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var numberOfDaysView: CustomView!
    @IBOutlet weak var subCategoryView: UIView!
    @IBOutlet weak var categoryView: UIView!
    @IBOutlet weak var lblTotalDays: CustomLabelFont!
    @IBOutlet weak var subCategoryTF: UITextField!
    @IBOutlet weak var positionLabel: CustomLabelFont!
    @IBOutlet weak var mainImageView: CustomImageView!
    @IBOutlet weak var toTextField: UITextField!
    @IBOutlet weak var fromTextField: UITextField!
    @IBOutlet weak var selectCategoryCollectionview: UICollectionView! {
        didSet {
            selectCategoryCollectionview.registerCellFromNib(cellID: "DurationCollectionViewCell")
        }
    }
    @IBOutlet weak var countryLabel: CustomLabelFont!
    
    // MARK: - Property Decalaration
    private var activeTextField: UITextField?
    private lazy var viewModel = AddPromotionalBannerViewModel(hostVC: self)
    private var isImageChanged: Bool = false
    var isComingForEdit: Bool = false
    var giftsListData: GetPromotionalBannersList?
    var onCardUpdated: ((GetPromotionalBannersList) -> Void)?
    var forTypeList = ["Home Top".localiz(), "Home Bottom".localiz(), "Category".localiz()]
    var selectedPositionIndex: Int = 0 //type 1 mobile,2-web
    var pickedImage: UIImage?
    var pickedFileName: String = ""
    var isGifSelected: Bool = false
    var selectedImageUrl: String = ""
    let datePicker = UIDatePicker()
//    var countryId: Int = 0
    var pickedGifData: Data?
    var selectedForType: Int = 1
    func selectedAspectRatio() -> BannerAspectRatio {
        return selectedForType == 1 ? .mobile : .web
    }
    
    // MARK: - View's LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
//        viewModel.getAllCountry()
        numberOfDaysView.isHidden = true
        categoryView.isHidden = true
        subCategoryView.isHidden = true
        setUpTextFields()
        viewModel.getAllCategory()
        if isComingForEdit {
            bindData()
            titleLabel.text = "Edit Promotional Banner".localiz()
        } else {
            titleLabel.text = "Add Promotional Banner".localiz()
        }
    }
    
    // MARK: - Button's Action
    @IBAction func positionDropDownDidTapped(_ sender: UIButton) {
        kSharedAppDelegate.dropDown(dataSource: forTypeList, anchorView: sender) { index, item in
            self.positionLabel.text = item
            self.selectedPositionIndex = index + 1
            self.updateCategoryVisibility()
        }
    }
    
    @IBAction func submitDidTapped(_ sender: UIButton) {
        guard viewModel.validFields() else { return }
        uploadBannerThenSubmit()
        
    }
    
    @IBAction func uploadImageDidTapped(_ sender: UIButton) {
        ImagePickerManager.shared.pickFromGalleryOnly(self) { [weak self]
            image, gifData, isGif, fileName, url in
            
            guard let self = self else { return }
            
            self.isImageChanged = true   // VERY IMPORTANT
            self.isGifSelected = isGif
            self.pickedFileName = fileName
            
            if isGif, let gifData = gifData {
                self.pickedGifData = gifData
                self.pickedImage = nil
                if let url = url {
                    self.mainImageView.sd_setImage(with: url)
                }
            } else if let image = image {
                self.pickedGifData = nil
                self.pickedImage = self.processCameraImage(image)
                self.mainImageView.image = self.pickedImage
            }
        }
    }
    
    private func uploadBannerThenSubmit() {
        // Edit flow WITHOUT image change
        if isComingForEdit, !isImageChanged {
            submitFinalApi()
            return
        }
        
        // GIF upload
        if isGifSelected, let gifData = pickedGifData {
            viewModel.uploadFullScreenBanner(
                file: gifData,
                isImage: false,
                isGif: true,
            ) { [weak self] url in
                self?.selectedImageUrl = url
                self?.submitFinalApi()
            }
            return
        }
        
        // Image upload
        if let image = pickedImage {
            viewModel.uploadFullScreenBanner(
                file: image,
                isImage: true,
            ) { [weak self] url in
                self?.selectedImageUrl = url
                self?.submitFinalApi()
            }
            return
        }
        
        // Add flow safety
        showAlert(msg: "Please select image".localiz())
    }
    
    @IBAction func backDidTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func subCategoryDidTapped(_ sender: UIButton) {
        guard let _ = viewModel.selectedCategoriesId else {
            showAlert(msg: "Please select the category first".localiz())
            return
        }
        
        //If no subcategories available
        guard !viewModel.subcategoriesList.isEmpty else {
            showAlert(msg: "No subcategories available".localiz())
            return
        }
        
        let subCategoryNames = self.viewModel.subcategoriesList.map {
            AppLanguageManager.shared.currentLanguage == .ar
            ? ($0.nameArabic ?? "")
            : ($0.nameEnglish ?? "")
        }
        
        kSharedAppDelegate.dropDown(dataSource: subCategoryNames, anchorView: sender) { index, item in
            let selectedsubCategory = self.viewModel.subcategoriesList[index]
//            self.subCategoryTF.text = selectedsubCategory.nameEnglish ?? ""
            self.subCategoryTF.text =
                AppLanguageManager.shared.currentLanguage == .ar
                ? (selectedsubCategory.nameArabic ?? "")
                : (selectedsubCategory.nameEnglish ?? "")
            self.viewModel.selectedSubCategoriesId = selectedsubCategory.id
        }
    }
    
    @IBAction func selectCountryDidTapped(_ sender: UIButton) {
//        let countryNames = viewModel.countryListData.map { country -> String in
//            let name = country.name ?? ""
//            let dialCode = country.dialCode ?? ""
//            let flag = country.flag1 ?? "🇰🇼"
//            return "\(flag)  \(name) (\(dialCode))"
//        }
//        
//        kSharedAppDelegate.dropDown(dataSource: countryNames, anchorView: sender) { index, item in
//            let selectedCountry = self.viewModel.countryListData[index]
//            self.countryLabel.text = selectedCountry.name
//            self.countryId = selectedCountry.id ?? 0
//        }
    }
    
    //MARK: Function's declaration
    private func updateCategoryVisibility() {
        let isCategorySelected = (selectedPositionIndex == 3) // Category
        
        categoryView.isHidden = !isCategorySelected
        subCategoryView.isHidden = !isCategorySelected
    }
    
    private func processCameraImage(_ image: UIImage) -> UIImage {
        
        let aspect = selectedAspectRatio()
        
        let targetSize: CGSize = (aspect == .mobile)
        ? CGSize(width: 1080, height: 1920)   // Mobile 9:16
        : CGSize(width: 1920, height: 1080)   // Web 16:9
        
        let croppedImage = image.cropToAspectRatio(aspect.value)
        return croppedImage.resize(to: targetSize)
    }
    
    func calculateTotalDays() {
        guard
            let fromText = fromTextField.text, !fromText.isEmpty,
            let toText = toTextField.text, !toText.isEmpty
        else {
            lblTotalDays.text = "days".localiz()
            numberOfDaysView.isHidden = true
            return
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        
        guard
            let startDate = formatter.date(from: fromText),
            let endDate = formatter.date(from: toText),
            startDate <= endDate
        else {
            lblTotalDays.text = "days".localiz()
            numberOfDaysView.isHidden = true
            return
        }
        
        let days = Calendar.current.dateComponents([.day], from: startDate, to: endDate).day ?? 0
        let totalDays = days + 1
        
        lblTotalDays.text = "\(totalDays)"
        numberOfDaysView.isHidden = false
    }
    
    
    private func submitFinalApi() {
        if isComingForEdit {
            viewModel.editAdvertisementApi()
        } else {
            viewModel.addAdvertisementApi()
        }
    }
    
    func bindData() {
        // Image
        if let imageUrlString = giftsListData?.uploadBanner,
           let url = URL(string: imageUrlString) {
            selectedImageUrl = imageUrlString
            mainImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            mainImageView.sd_setImage(with: url)
        }
        
        // Dates
        fromTextField.text = convertDateFormat(giftsListData?.startDate ?? "")
        toTextField.text = convertDateFormat(giftsListData?.endDate ?? "")
        calculateTotalDays()
        
        // Position
        selectedPositionIndex = Int(giftsListData?.bannerPosition ?? "1") ?? 1
        positionLabel.text = forTypeList[selectedPositionIndex - 1]
        updateCategoryVisibility()
        countryLabel.text = giftsListData?.countryInfo?.name
//        countryId = giftsListData?.countryInfo?.id ?? 0
        // Category specific logic
        if selectedPositionIndex == 3 {
            populateCategoryAndSubCategory()
        }
    }
    
    private func populateCategoryAndSubCategory() {
        guard let category = giftsListData?.categoryDetails else { return }
        
        // Select category
        viewModel.selectedCategoriesId = category.id
        selectCategoryCollectionview.reloadData()
        
        // Fetch subcategories
        viewModel.getSubCategoriesListApi() { [weak self] in
            guard let self = self else { return }
            
            // Select subcategory
            if let subCategoryId = self.giftsListData?.subcategoryDetails?.id,
               let index = self.viewModel.subcategoriesList.firstIndex(where: { $0.id == subCategoryId }) {
                
                let subCategory = self.viewModel.subcategoriesList[index]
                self.subCategoryTF.text = AppLanguageManager.shared.currentLanguage == .ar ? subCategory.nameArabic : subCategory.nameEnglish
                self.viewModel.selectedSubCategoriesId = subCategoryId
            }
        }
    }
    
    
    func convertDateFormat(
        _ dateString: String,
        from inputFormat: String = "yyyy-MM-dd",
        to outputFormat: String = "dd/MM/yyyy"
    ) -> String? {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = inputFormat
//        inputFormatter.locale = Locale(identifier: "en_US_POSIX")
        if AppLanguageManager.shared.currentLanguage == .ar {
            inputFormatter.locale = Locale(identifier: "ar")
           } else {
               inputFormatter.locale = Locale(identifier: "en_US")
           }
        guard let date = inputFormatter.date(from: dateString) else {
            return nil
        }
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = outputFormat
//        outputFormatter.locale = Locale(identifier: "en_US_POSIX")
        if AppLanguageManager.shared.currentLanguage == .ar {
            outputFormatter.locale = Locale(identifier: "ar")
           } else {
               outputFormatter.locale = Locale(identifier: "en_US")
           }
        return outputFormatter.string(from: date)
    }
    
}

extension AddPromotionalBannerViewController {
    private func setUpTextFields() {
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .date
        datePicker.minimumDate = Date()
        datePicker.backgroundColor = .white
        if AppLanguageManager.shared.currentLanguage == .ar {
            datePicker.locale = Locale(identifier: "ar")
            datePicker.semanticContentAttribute = .forceRightToLeft
        } else {
            datePicker.locale = Locale(identifier: "en")
            datePicker.semanticContentAttribute = .forceLeftToRight
        }
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done".localiz(), style: .done, target: self, action: #selector(doneDatePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel".localiz(), style: .plain, target: self, action: #selector(cancelDatePicker))
        toolbar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        
        fromTextField.inputView = datePicker
        fromTextField.inputAccessoryView = toolbar
        toTextField.inputView = datePicker
        toTextField.inputAccessoryView = toolbar
        
        fromTextField.delegate = self
        toTextField.delegate = self
    }
    
    @objc private func doneDatePicker() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        
        guard let activeTextField = activeTextField else { return }
        
        let selectedDate = datePicker.date
        activeTextField.text = formatter.string(from: selectedDate)
        view.endEditing(true)
        
        // Case: From date changed
        if activeTextField == fromTextField,
           let toText = toTextField.text,
           !toText.isEmpty,
           let toDate = formatter.date(from: toText) {
            
            // From > To → invalidate To
            if selectedDate > toDate {
                toTextField.text = ""
                lblTotalDays.text = "days".localiz()
                numberOfDaysView.isHidden = true
                // Force user to select To Date again
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    self.toTextField.becomeFirstResponder()
                }
                return
            }
        }
        
        // Calculate only when both dates are valid
        calculateTotalDays()
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

//MARK: UITextFieldDelegate Methods
extension AddPromotionalBannerViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        if textField == toTextField {
            if let fromText = fromTextField.text,
               let fromDate = formatter.date(from: fromText) {
                datePicker.minimumDate = fromDate
            } else {
                datePicker.minimumDate = nil
            }
        }
        if textField == fromTextField {
            datePicker.minimumDate = Date()
        }
    }
}

// MARK: - COLLECTION VIEW METHODS
extension AddPromotionalBannerViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.categoryListData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DurationCollectionViewCell", for: indexPath) as! DurationCollectionViewCell
        let data = viewModel.categoryListData[indexPath.row]
        cell.titleLabel.text = AppLanguageManager.shared.currentLanguage == .ar ? data.nameAr : data.name
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
        viewModel.selectedSubCategoriesId = -1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = selectCategoryCollectionview.frame.width / 3
        return CGSize(width: width, height: 25)
    }
    
}
