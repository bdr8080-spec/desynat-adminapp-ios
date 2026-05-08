//
//  AffiliatedUserFilterViewController.swift
//  DesynatAdmin
//
//  Created by fluper_mac3 on 29/01/26.
//

import UIKit

class AffiliatedUserFilterViewController: UIViewController {
    
    // MARK: - IBOutlet's
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var toTextField: UITextField!
    @IBOutlet weak var fromTextField: UITextField!
    @IBOutlet weak var countryLabel: CustomLabelFont!
    
    // MARK: - Property Decalaration
    let datePicker = UIDatePicker()
    private var activeTextField: UITextField?
    var countryName: String = ""
    var countryID: Int = -1
    private lazy var viewModel = AffiliatedUserFilterViewModel(hostVC: self)
    var selectedFilter = FullScreenBannerFilterModel()
    var onApplyFilter: ((FullScreenBannerFilterModel) -> Void)?
    var onClearFilter: (() -> Void)?
    var disbaleFutureDateSelection: Bool = false
    
    // MARK: - View's LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        handleUISetup()
        viewModel.getAllCountry { [weak self] in
            self?.applyPreselectedData()
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
            filter.countryID = countryID
        }
        
        if let fromDate = fromTextField.text, !fromDate.isEmpty {
            filter.fromDate = fromDate
        }
        
        if let toDate = toTextField.text, !toDate.isEmpty {
            filter.toDate = toDate
        }
        onApplyFilter?(filter)
        dismiss(animated: true)
    }
    
    @IBAction func countryDidTapped(_ sender: UIButton) {
        let countryNames = viewModel.countryListData.map { country -> String in
            let name = AppLanguageManager.shared.currentLanguage == .en ? country.name : country.nameAr ?? ""
            let dialCode = country.dialCode ?? ""
            let flag = country.flag ?? "🇰🇼"
            return "\(flag)  \(name) (\(dialCode))"
        }
        
        kSharedAppDelegate.dropDown(dataSource: countryNames, anchorView: sender) { index, item in
            let selectedCountry = self.viewModel.countryListData[index]
            if AppLanguageManager.shared.currentLanguage == .en {
                self.countryLabel.text = selectedCountry.name
                self.countryName = selectedCountry.name ?? ""
            }else {
                self.countryName = selectedCountry.nameAr ?? ""
                self.countryLabel.text = selectedCountry.nameAr
            }
//            self.countryLabel.text = selectedCountry.name
//            self.countryName = selectedCountry.name ?? ""
            self.countryID = selectedCountry.id ?? -1
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
           let selectedCountry = viewModel.countryListData.first(where: { AppLanguageManager.shared.currentLanguage == .en ? $0.name == id : $0.nameAr == id }) {
            if AppLanguageManager.shared.currentLanguage == .en {
                self.countryLabel.text = selectedCountry.name ?? ""
            }else {
                self.countryLabel.text = selectedCountry.nameAr
            }
//            countryLabel.text = selectedCountry.name
            countryName = id
            countryID = selectedCountry.id ?? -1
        }
        
        // Preselect date fields
        fromTextField.text = selectedFilter.fromDate
        toTextField.text = selectedFilter.toDate
    }
    
}

extension AffiliatedUserFilterViewController {
    
    private func setUpTextFields() {
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .date
        datePicker.backgroundColor = .white
        if AppLanguageManager.shared.currentLanguage == .ar {
            datePicker.locale = Locale(identifier: "ar")
            datePicker.semanticContentAttribute = .forceRightToLeft
        } else {
            datePicker.locale = Locale(identifier: "en")
            datePicker.semanticContentAttribute = .forceLeftToRight
        }
        // 🔥 Key Change: Respect the disableFutureDateSelection flag
        if disbaleFutureDateSelection {
            datePicker.maximumDate = Date()   // Disable future dates
        } else {
            datePicker.maximumDate = nil      // Allow future dates
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
extension AffiliatedUserFilterViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        
        // Apply future date restriction
        if disbaleFutureDateSelection {
            datePicker.maximumDate = Date()
        } else {
            datePicker.maximumDate = nil
        }
        
        // From Date: No minimum date
        if textField == fromTextField {
            datePicker.minimumDate = nil
        }
        
        // To Date: Minimum date = From Date (if set)
        if textField == toTextField {
            if let fromText = fromTextField.text,
               let fromDate = formatter.date(from: fromText) {
                datePicker.minimumDate = fromDate
            } else {
                datePicker.minimumDate = nil
            }
        }
    }
}
