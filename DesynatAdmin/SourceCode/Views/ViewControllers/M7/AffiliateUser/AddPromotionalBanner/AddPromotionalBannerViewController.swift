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
    
    // MARK: - Property Decalaration
    let datePicker = UIDatePicker()
    private var activeTextField: UITextField?
    var selectedImageUrl: String = ""
    private lazy var viewModel = AddPromotionalBannerViewModel(hostVC: self)
    var isComingForEdit: Bool = false
    var giftsListData: GetPromotionalBannersList?
    var onCardUpdated: ((GetPromotionalBannersList) -> Void)?
    var forTypeList = ["Home Top", "Home Bottom", "Category"]
    var selectedPositionIndex: Int = 0 //type 1 mobile,2-web
    var pickedImage: UIImage?
    var pickedFileName: String = ""
    var isGifSelected: Bool = false
    private var isImageChanged: Bool = false
    
    // MARK: - View's LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        numberOfDaysView.isHidden = true
        categoryView.isHidden = true
        subCategoryView.isHidden = true
        setUpTextFields()
        viewModel.getAllCategory()
        if isComingForEdit {
            bindData()
            titleLabel.text = "Edit Promotional Banner"
        } else {
            titleLabel.text = "Add Promotional Banner"
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
        if isComingForEdit {
            viewModel.editAdvertisementApi()
        } else {
            viewModel.addAdvertisementApi()
        }
    }
    
    @IBAction func uploadImageDidTapped(_ sender: UIButton) {
        ImagePickerManager.shared.pickFromGalleryOnly(self) { [weak self]
            image, gifData, isGif, fileName, url in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.mainImageView.image = image
                self.pickedImage = image
            }
            guard let compressedImage = image?.jpegData(compressionQuality: 0.25),
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
    
    @IBAction func backDidTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func subCategoryDidTapped(_ sender: UIButton) {
        guard let _ = viewModel.selectedCategoriesId else {
            showAlert(msg: "Please select the category first")
            return
        }
        
        //If no subcategories available
        guard !viewModel.subcategoriesList.isEmpty else {
            showAlert(msg: "No subcategories available")
            return
        }
        
        let subCategoryNames = self.viewModel.subcategoriesList.map { $0.nameEnglish ?? "" }
        
        kSharedAppDelegate.dropDown(dataSource: subCategoryNames, anchorView: sender) { index, item in
            let selectedsubCategory = self.viewModel.subcategoriesList[index]
            self.subCategoryTF.text = selectedsubCategory.nameEnglish ?? ""
            self.viewModel.selectedSubCategoriesId = selectedsubCategory.id
        }
    }
    
    //MARK: Function's declaration
    private func updateCategoryVisibility() {
        let isCategorySelected = (selectedPositionIndex == 3) // Category
        
        categoryView.isHidden = !isCategorySelected
        subCategoryView.isHidden = !isCategorySelected
    }
    
    func calculateTotalDays() {
        guard
            let fromText = fromTextField.text, !fromText.isEmpty,
            let toText = toTextField.text, !toText.isEmpty
        else {
            lblTotalDays.text = "days"
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
            lblTotalDays.text = "days"
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
                self.subCategoryTF.text = subCategory.nameEnglish
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

extension AddPromotionalBannerViewController {
    private func setUpTextFields() {
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .date
        datePicker.minimumDate = Date()
        datePicker.backgroundColor = .white
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneDatePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker))
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
                lblTotalDays.text = "days"
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
        let alert = UIAlertController(title: "Invalid Date",
                                      message: "To Date cannot be earlier than From Date.",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
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
        viewModel.selectedSubCategoriesId = -1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = selectCategoryCollectionview.frame.width / 3
        return CGSize(width: width, height: 25)
    }
    
}
