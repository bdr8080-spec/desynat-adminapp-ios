////
////  PaymentFilterViewController.swift
////  DesynatAdmin
////
////  Created by  shailendra singh on 07/04/26.


import UIKit
class PaymentFilterViewController: UIViewController {
    
    // MARK: - IBOutlet's
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var toTextField: UITextField!
    @IBOutlet weak var fromTextField: UITextField!
    @IBOutlet weak var countryLabel: CustomLabelFont!
    @IBOutlet weak var statusLabel: CustomLabelFont!
    
    // MARK: - Property Decalaration
    private var activeTextField: UITextField?
    private lazy var viewModel = PaymentFilterViewModel(hostVC: self)
    private var statusArray = ["Pending", "Rejected", "Completed"]
    var selectedFilter = PaymentFilterModel()
    var onApplyFilter: ((PaymentFilterModel) -> Void)?
    var onClearFilter: (() -> Void)?
    var countryId: Int = -1
    let datePicker = UIDatePicker()
    var selectedStatus: Int?
    var selectedTab: PaymentTab = .orders
    
    // MARK: - View's LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        handleUISetup()
        switch selectedTab {
        case .orders, .giftCards:
            viewModel.getAllCountryRequest { [weak self] in
                self?.applyPreselectedData()
            }
            
        case .plans, .banners:
            viewModel.getCountryRequest { [weak self] in
                self?.applyPreselectedData()
            }
        }
    }
    
    // MARK: - Button's Action
    @IBAction func dismissDidTapped(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func clearDidTapped(_ sender: Any) {
        selectedStatus = nil
        statusLabel.text = "Select Status"
        onClearFilter?()
        dismiss(animated: true)
    }
    
    @IBAction func applyDidTapped(_ sender: Any) {
        var filter = PaymentFilterModel()
        
        if countryId != -1 {
            filter.countryId = countryId
        }
        
        if let fromDate = fromTextField.text, !fromDate.isEmpty {
            filter.fromDate = fromDate
        }
        
        if let toDate = toTextField.text, !toDate.isEmpty {
            filter.toDate = toDate
        }
        
        // ✅ Add this
        if let status = selectedStatus {
            filter.status = status
        }
        
        onApplyFilter?(filter)
        dismiss(animated: true)
    }
    
    @IBAction func countryDidTapped(_ sender: UIButton) {
        switch selectedTab {
            
        case .orders, .giftCards:
            let countryNames = viewModel.allCountryListData.map {
                "\($0.flag1 ?? "🇰🇼") \($0.name ?? "") (\($0.dialCode ?? ""))"
            }
            kSharedAppDelegate.dropDown(dataSource: countryNames, anchorView: sender) { index, _ in
                let selectedCountry = self.viewModel.allCountryListData[index]
                self.countryLabel.text = selectedCountry.name
                self.countryId = selectedCountry.id ?? 0
            }
            
        case .plans, .banners:
            let countryNames = viewModel.countryListData.map {
                "\($0.flag ?? "🇰🇼") \($0.name ?? "") (\($0.dialCode ?? ""))"
            }
            kSharedAppDelegate.dropDown(dataSource: countryNames, anchorView: sender) { index, _ in
                let selectedCountry = self.viewModel.countryListData[index]
                self.countryLabel.text = selectedCountry.name
                self.countryId = selectedCountry.id ?? 0
            }
        }
    }
    
    @IBAction func statusDidTapped(_ sender: UIButton) {
        kSharedAppDelegate.dropDown(dataSource: statusArray, anchorView: sender) { index, item in
            
            self.statusLabel.text = item
            
            // Map index → API value
            switch index {
            case 0: self.selectedStatus = 1   // Pending
            case 1: self.selectedStatus = 2   // Rejected
            case 2: self.selectedStatus = 3   // Completed
            default: self.selectedStatus = nil
            }
        }
    }
    
    // MARK: - Function's declaration
    private func handleUISetup() {
        headerView.layer.cornerRadius = 24
        headerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        headerView.clipsToBounds = true
        
        setUpTextFields()
    }
    
    private func applyPreselectedData() {
        // Preselect country
        if let id = selectedFilter.countryId {
            switch selectedTab {
            case .orders, .giftCards:
                if let selectedCountry = viewModel.allCountryListData.first(where: { $0.id == id }) {
                    countryLabel.text = selectedCountry.name
                    countryId = id
                }
            case .plans, .banners:
                if let selectedCountry = viewModel.countryListData.first(where: { $0.id == id }) {
                    countryLabel.text = selectedCountry.name
                    countryId = id
                }
            }
        }
        
        // Preselect date
        fromTextField.text = selectedFilter.fromDate
        toTextField.text = selectedFilter.toDate
        
        // ✅ Status restore
        if let status = selectedFilter.status {
            selectedStatus = status
            
            switch status {
            case 1: statusLabel.text = "Pending"
            case 2: statusLabel.text = "Rejected"
            case 3: statusLabel.text = "Completed"
            default: statusLabel.text = "Select Status"
            }
        }
    }
}
extension PaymentFilterViewController {
    
    private func setUpTextFields() {
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .date
        datePicker.minimumDate = nil
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
        let alert = UIAlertController(
            title: "Invalid Date",
            message: "To Date cannot be earlier than From Date.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    @objc private func cancelDatePicker() {
        view.endEditing(true)
    }
}
extension PaymentFilterViewController: UITextFieldDelegate {
    
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
