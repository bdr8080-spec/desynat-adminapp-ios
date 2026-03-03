//
//  BannersMangementFilterViewController.swift
//  DesynatAdmin
//
//  Created by fluper on 16/12/25.
//

import UIKit
import DropDown

class BannersMangementFilterViewController: UIViewController {
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var toTextField: UITextField!
    @IBOutlet weak var fromTextField: UITextField!
    @IBOutlet weak var countryLabel: CustomLabelFont!
    
    private var viewModel : BannersMangementFilterViewModel = BannersMangementFilterViewModel()
    private var isCountryExpanded : Bool = false
    private var callBackFromApplyFilter : ((FilterInfo) -> Void)?
    private var lastEditedTextField : UITextField?
    private let datePicker = UIDatePicker()
    
    private var context: FilterContext?
    private var callBack: ((FilterInfo) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        handleUISetup()
        viewModel.getAllCountry { [weak self] in
            self?.setData()
            self?.countryLabel.text = self?.viewModel.filterInfo.country?.name
        }
    }
    
    func configure(
        context: FilterContext,
        filter: FilterInfo,
        callBack: @escaping (FilterInfo) -> Void
    ) {
        self.context = context
        self.viewModel.setFilter(filter)
        self.callBack = callBack
    }
    
    
    func setIntitial(_ filterInfo:FilterInfo,callBack:@escaping((FilterInfo) -> Void))  {
        self.viewModel.setFilter(filterInfo)
        self.callBackFromApplyFilter = callBack
    }
    
    func setData() {
        let filterInfo = viewModel.filterInfo
        if let startDate = filterInfo.startDate {
            self.fromTextField.text = CommonUtils.getDateString(from: startDate,format: "dd/MM/yyyy")
        }
        if let endDate = filterInfo.endDate {
            self.toTextField.text = CommonUtils.getDateString(from: endDate,format: "dd/MM/yyyy")
        }
    }
    
    @IBAction func dismissDidTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func clearDidTapped(_ sender: Any) {
        viewModel.clearFilter()
        callBack?(viewModel.filterInfo)
        dismiss(animated: true)
    }
    
    @IBAction func applyDidTapped(_ sender: Any) {
        callBack?(viewModel.filterInfo)
        dismiss(animated: true)
    }
    
    
    @IBAction func countryDidTapped(_ sender: UIButton) {
        let countryNames = viewModel.countryListData.map { country -> String in
            let name = country.name ?? ""
            let dialCode = country.dialCode ?? ""
            let flag = country.flag ?? "🇰🇼"
            return "\(flag)  \(name) (\(dialCode))"
        }
        
        // Create a DropDown object
        let dropDown = DropDown()
        dropDown.dataSource = countryNames
        
        // Use the view controller's view as anchor
        dropDown.anchorView = self.view // This centers it on the screen
        dropDown.direction = .any
        dropDown.bottomOffset = CGPoint(x: 50, y: (self.view.frame.height / 2) - 50) // adjust to roughly center vertically
        dropDown.width = 250 // optional, adjust width
        dropDown.selectionAction = { index, item in
            let selectedCountry = self.viewModel.countryListData[index]
            self.viewModel.setCountry(selectedCountry)
            self.countryLabel.text = selectedCountry.name
        }
        
        // Show the dropdown
        dropDown.show()
    }
    
    private func handleUISetup() {
        headerView.layer.cornerRadius = 24
        headerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        headerView.clipsToBounds = true
        setUpTextFields()
    }
}

extension BannersMangementFilterViewController {
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
        
        fromTextField.addTarget(self, action: #selector(handleTextFieldBiginEditing(_:)), for: .editingDidBegin)
        toTextField.addTarget(self, action: #selector(handleTextFieldBiginEditing(_:)), for: .editingDidBegin)
    }
    
    
    @objc func handleTextFieldBiginEditing(_ sender:UITextField) {
        if sender == self.fromTextField {
            if let startDate = self.viewModel.filterInfo.startDate {
                self.datePicker.date = startDate
            } else {
                self.datePicker.date = Date()
            }
            if let endDate = self.viewModel.filterInfo.endDate {
                self.datePicker.maximumDate = endDate
            } else {
                self.datePicker.maximumDate = nil
            }
            self.datePicker.minimumDate = nil
        } else if sender == self.toTextField {
            if let endDate = self.viewModel.filterInfo.endDate {
                self.datePicker.date = endDate
            } else {
                self.datePicker.date = Date()
            }
            
            if let startDate = self.viewModel.filterInfo.startDate {
                self.datePicker.minimumDate = startDate
            } else {
                self.datePicker.minimumDate = nil
            }
            self.datePicker.maximumDate = nil
        }
        lastEditedTextField = sender
    }
    
    @objc private func doneDatePicker() {
        lastEditedTextField?.text = CommonUtils.getDateString(from: datePicker.date,format: "dd/MM/yyyy")
        if lastEditedTextField == self.fromTextField {
            self.viewModel.setStartDate(datePicker.date)
        } else if lastEditedTextField == self.toTextField {
            self.viewModel.setEndDate(datePicker.date)
        }
        view.endEditing(true)
    }
    
    @objc private func cancelDatePicker() {
        view.endEditing(true)
    }
}
