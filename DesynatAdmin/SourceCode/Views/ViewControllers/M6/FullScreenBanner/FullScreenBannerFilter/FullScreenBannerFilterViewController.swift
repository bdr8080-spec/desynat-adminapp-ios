//
//  FullScreenBannerFilterViewController.swift
//  DesynatAdmin
//
//  Created by fluper on 08/01/26.
//

import UIKit

class FullScreenBannerFilterViewController: UIViewController {
  
  @IBOutlet weak var headerView: UIView!
  @IBOutlet weak var toTextField: UITextField!
  @IBOutlet weak var fromTextField: UITextField!
  @IBOutlet weak var countryLabel: CustomLabelFont!
  
  let datePicker = UIDatePicker()
  private var activeTextField: UITextField?
  var countryName: String = ""
  private lazy var viewModel = FullScreenBannerFilterViewModel(hostVC: self)
  var selectedFilter = FullScreenBannerFilterModel()
  var onApplyFilter: ((FullScreenBannerFilterModel) -> Void)?
  var onClearFilter: (() -> Void)?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    handleUISetup()
    viewModel.getAllCountry { [weak self] in
      self?.applyPreselectedData()
    }
  }
  
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
