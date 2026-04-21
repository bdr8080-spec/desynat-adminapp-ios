//
//  RefundManagementFilterViewController.swift
//  DesynatAdmin
//
//  Created by  shailendra singh on 30/03/26.
//

import UIKit

class RefundManagementFilterViewController: UIViewController {
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var toTextField: UITextField!
    @IBOutlet weak var fromTextField: UITextField!
    @IBOutlet weak var countryLabel: CustomLabelFont!
    @IBOutlet weak var statusLabel: CustomLabelFont!
    
    private var activeTextField: UITextField?
    private lazy var viewModel = RefundManagementFilterViewModel(hostVC: self)
    private var statusArray = ["Pending", "Rejected", "Completed"]
    var selectedFilter = PaymentFilterModel()
    var onApplyFilter: ((PaymentFilterModel) -> Void)?
    var onClearFilter: (() -> Void)?
    var countryId: Int = -1
    var countryName: String = ""
    let datePicker = UIDatePicker()
    var selectedStatus: Int?
    var disbaleFutureDateSelection: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        handleUISetup()
        statusLabel.text = "Select Status"
        viewModel.getAllCountryRequest { [weak self] in
            self?.applyPreselectedData()
        }
    }
    
    // MARK: - Navigation
    
    @IBAction func crossBtn(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func applyDidTapped(_ sender: Any) {
        var filter = PaymentFilterModel()
        
        if countryId != -1 {
            filter.countryId = countryId
            filter.countryName = countryName
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
    
    @IBAction func clearDidTapped(_ sender: Any) {
        selectedStatus = nil
        statusLabel.text = "Select Status"
        onClearFilter?()
        dismiss(animated: true)
    }
    
    @IBAction func countryDidTapped(_ sender: UIButton) {
        let countryNames = viewModel.allCountryListData.map {
            "\($0.flag1 ?? "🇰🇼") \($0.name ?? "") (\($0.dialCode ?? ""))"
        }
        kSharedAppDelegate.dropDown(dataSource: countryNames, anchorView: sender) { index, _ in
            let selectedCountry = self.viewModel.allCountryListData[index]
            self.countryLabel.text = selectedCountry.name
            self.countryId = selectedCountry.id ?? 0
            self.countryName = selectedCountry.name ?? ""
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
    
    private func applyPreselectedData() {
        // Preselect country
        if let id = selectedFilter.countryId {
            if let selectedCountry = viewModel.allCountryListData.first(where: { $0.id == id }) {
                countryLabel.text = selectedCountry.name
                countryId = id
                countryName = selectedCountry.name ?? ""
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
    
    private func handleUISetup() {
        headerView.layer.cornerRadius = 24
        headerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        headerView.clipsToBounds = true
        setUpTextFields()
    }
    
}

extension RefundManagementFilterViewController {
    
    private func setUpTextFields() {
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .date
        datePicker.backgroundColor = .white
        
        // 🔥 Key Change: Respect the disableFutureDateSelection flag
        if disbaleFutureDateSelection {
            datePicker.maximumDate = Date()   // Disable future dates
        } else {
            datePicker.maximumDate = nil      // Allow future dates
        }
        
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
extension RefundManagementFilterViewController: UITextFieldDelegate {
    
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
