//
//  FullScreenBannerFilterViewController.swift
//  DesynatAdmin
//
//  Created by fluper on 08/01/26.
//

import UIKit

class FullScreenBannerFilterViewController: UIViewController {
    
    // MARK: - IBOutlet's
    @IBOutlet weak var countryView: UIView!
    @IBOutlet weak var typeCollectionView: UICollectionView! {
        didSet {
            typeCollectionView.registerCellFromNib(cellID: "DurationCollectionViewCell")
        }
    }
    @IBOutlet weak var fullScreenBannerType: UIView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var toTextField: UITextField!
    @IBOutlet weak var fromTextField: UITextField!
    @IBOutlet weak var countryLabel: CustomLabelFont!
    
    // MARK: - Property Decalaration
    let datePicker = UIDatePicker()
    private var activeTextField: UITextField?
    var countryName: String = ""
    private lazy var viewModel = FullScreenBannerFilterViewModel(hostVC: self)
    var selectedFilter = FullScreenBannerFilterModel()
    var onApplyFilter: ((FullScreenBannerFilterModel) -> Void)?
    var onClearFilter: (() -> Void)?
    var bannerType: BannerMangementType = .fullScreen
    let typeForFullscreenBanner = ["Both", "App Banner", "Web Banner"]
    let typeForPromotionalScreenBanner = ["Home Top", "Home Bottom", "Category"]
    var selectedIndexOfType: Int? = -1
    
    // MARK: - View's LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        handleUISetup()
        viewModel.getAllCountry { [weak self] in
            self?.applyPreselectedData()
        }
        switch bannerType {
        case .fullScreen:
            countryView.isHidden = false
        case .promotional:
            countryView.isHidden = true
        }
    }
    
    // MARK: - Button's Action
    @IBAction func dismissDidTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func clearDidTapped(_ sender: Any) {
        onClearFilter?()
        dismiss(animated: true)
    }
    
    @IBAction func applyDidTapped(_ sender: Any) {
        var filter = FullScreenBannerFilterModel()
        if !countryName.isEmpty {
            filter.countryName = countryName
        }
        
        if let fromDate = fromTextField.text, !fromDate.isEmpty {
            filter.fromDate = fromDate
        }
        
        if let toDate = toTextField.text, !toDate.isEmpty {
            filter.toDate = toDate
        }
        
        switch bannerType {
        case .fullScreen:
            if let selectedIndexOfBanner = selectedIndexOfType, selectedIndexOfBanner != -1 {
                filter.bannerType = selectedIndexOfBanner
            }
        case .promotional:
            if let selectedIndexOfBanner = selectedIndexOfType, selectedIndexOfBanner != -1 {
                filter.bannerType = selectedIndexOfBanner
            }
        }
        
        onApplyFilter?(filter)
        dismiss(animated: true)
    }
    
    @IBAction func countryDidTapped(_ sender: UIButton) {
        let countryNames = viewModel.countryListData.map { country -> String in
            let name = country.name ?? ""
            let dialCode = country.dialCode ?? ""
            let flag = country.flag1 ?? "🇰🇼"
            return "\(flag)  \(name) (\(dialCode))"
        }
        
        kSharedAppDelegate.dropDown(dataSource: countryNames, anchorView: sender) { index, item in
            let selectedCountry = self.viewModel.countryListData[index]
            self.countryLabel.text = selectedCountry.name
            self.countryName = selectedCountry.name ?? ""
        }
    }
    
    //MARK: Function's declaration
    private func handleUISetup() {
        headerView.layer.cornerRadius = 24
        headerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        headerView.clipsToBounds = true
        setUpTextFields()
    }
    
    private func applyPreselectedData() {
        // Preselect country
        if let id = selectedFilter.countryName,
           let selectedCountry = viewModel.countryListData.first(where: { $0.name == id }) {
            
            countryLabel.text = selectedCountry.name
            countryName = id
        }
        
        // Preselect date fields
        fromTextField.text = selectedFilter.fromDate
        toTextField.text = selectedFilter.toDate
        selectedIndexOfType = selectedFilter.bannerType ?? -1
        typeCollectionView.reloadData()
    }
    
}

// MARK: - COLLECTION VIEW METHODS
extension FullScreenBannerFilterViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch bannerType {
        case .fullScreen:
            return typeForFullscreenBanner.count
        case .promotional:
            return typeForPromotionalScreenBanner.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DurationCollectionViewCell", for: indexPath) as! DurationCollectionViewCell
        switch bannerType {
        case .fullScreen:
            cell.titleLabel.text = typeForFullscreenBanner[indexPath.row].localiz()
        case .promotional:
            cell.titleLabel.text = typeForPromotionalScreenBanner[indexPath.row].localiz()
        }
        if selectedIndexOfType == indexPath.row {
            cell.selectedImageView.image = .radioSelected
        } else{
            cell.selectedImageView.image = .radioUnselected
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndexOfType = indexPath.row
        typeCollectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width / 3, height: 30)
    }
    
}

extension FullScreenBannerFilterViewController {
    private func setUpTextFields() {
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .date
        datePicker.minimumDate = nil
        datePicker.backgroundColor = .white
        
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
        
        if activeTextField == fromTextField {
            fromTextField.text = formatter.string(from: datePicker.date)
            if let toText = toTextField.text,
               let toDate = formatter.date(from: toText),
               toDate < datePicker.date {
                toTextField.text = ""
            }
        }
        
        else if activeTextField == toTextField {
            if let fromText = fromTextField.text,
               let fromDate = formatter.date(from: fromText),
               datePicker.date < fromDate {
                showValidationAlert()
                return
            }
            toTextField.text = formatter.string(from: datePicker.date)
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

//MARK: UITextFieldDelegate Methods
extension FullScreenBannerFilterViewController: UITextFieldDelegate {
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
            datePicker.minimumDate = nil
        }
    }
}
