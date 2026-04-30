//
//  ApplyFilterViewController.swift
//  DesynatAdmin
//
//  Created by Meet Goti on 07/11/25.
//

import UIKit

class ApplyFilterViewController: UIViewController {
    
    // MARK: - IBOutlet's
    @IBOutlet weak var btnClear: CustomButton!
    @IBOutlet weak var viewCountryContainer: CustomView!
    @IBOutlet weak var lblSelectedCountry: CustomLabelFont!
    @IBOutlet weak var viewMain: CustomView!
    @IBOutlet weak var lnlFlag: CustomLabelFont!
    @IBOutlet weak var txtFieldFrom: UITextField!
    @IBOutlet weak var txtFieldTo: UITextField!
    @IBOutlet weak var tblCountry: TableViewDynamicHeight!
    
    // MARK: - Property Decalaration
    private var viewModel : FilterViewModel = FilterViewModel()
    private var isCountryExpanded : Bool = false
    private var callBackFromApplyFilter : ((FilterInfo) -> Void)?
    private var lastEditedTextField : UITextField?
    private let datePicker = UIDatePicker()
    
    // MARK: - View's LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpUi()
        self.setData()
    }
    
    // MARK: - Button's Action
    @IBAction func handleClose(_ sender: Any) {
        self.dismiss(animated: false)
    }
    
    @IBAction func handleCountrySelection(_ sender: Any) {
        isCountryExpanded = !isCountryExpanded
        self.refreshCountrySelection()
    }
    
    @IBAction func handleClearFilter(_ sender: Any) {
        self.callBackFromApplyFilter?(FilterInfo())
        self.dismiss(animated: false)
    }
    
    @IBAction func handleApplyFilter(_ sender: Any) {
        self.callBackFromApplyFilter?(viewModel.filterInfo)
        self.dismiss(animated: false)
    }
    
    //MARK: Function's declaration
    func setIntitial(_ filterInfo:FilterInfo,callBack:@escaping((FilterInfo) -> Void))  {
        self.viewModel.setFilter(filterInfo)
        self.callBackFromApplyFilter = callBack
    }
    
    private func setUpUi() {
        self.viewModel.setRefreshHandler(self)
        self.viewMain.borderRadiusWithCornerMask(radius: 24,cornerMask: [.layerMinXMinYCorner,.layerMaxXMinYCorner])
        self.btnClear.addGradientBorder(cornerRadius: 5,direction: .topToBottom,colors: [UIColor.init(hexString: "#DFBF8F"), UIColor.init(hexString: "#6E4527")])
        self.tblCountry.register(CountryTableViewCell.self)
        self.tblCountry.dataSource = self
        self.tblCountry.delegate = self
        self.tblCountry.separatorStyle = .none
        self.setUpTextFields()
    }
    
    func setData() {
        self.viewModel.getAllCountry {
            self.refreshCountrySelection()
        }
        let filterInfo = viewModel.filterInfo
        if let startDate = filterInfo.startDate {
            self.txtFieldFrom.text = CommonUtils.getDateString(from: startDate,format: "dd/MM/yyyy")
        }
        if let endDate = filterInfo.endDate {
            self.txtFieldTo.text = CommonUtils.getDateString(from: endDate,format: "dd/MM/yyyy")
        }
    }
    
    func refreshCountrySelection() {
        if let countryListData = viewModel.filterInfo.country {
            self.lblSelectedCountry.text = String.getString(countryListData.name)
            self.lnlFlag.text = String.getString(countryListData.flag)
        } else {
            self.lblSelectedCountry.text = ""
        }
        self.lnlFlag.isHidden = !self.isCountryExpanded
        self.viewCountryContainer.isHidden = !self.isCountryExpanded
    }
    
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
        
        txtFieldFrom.inputView = datePicker
        txtFieldFrom.inputAccessoryView = toolbar
        txtFieldTo.inputView = datePicker
        txtFieldTo.inputAccessoryView = toolbar
        
        txtFieldFrom.addTarget(self, action: #selector(handleTextFieldBiginEditing(_:)), for: .editingDidBegin)
        txtFieldTo.addTarget(self, action: #selector(handleTextFieldBiginEditing(_:)), for: .editingDidBegin)
    }
    
    
    @objc func handleTextFieldBiginEditing(_ sender:UITextField) {
        if sender == self.txtFieldFrom {
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
        } else if sender == self.txtFieldTo {
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
        if lastEditedTextField == self.txtFieldFrom {
            self.viewModel.setStartDate(datePicker.date)
        } else if lastEditedTextField == self.txtFieldTo {
            self.viewModel.setEndDate(datePicker.date)
        }
        view.endEditing(true)
    }
    
    @objc private func cancelDatePicker() {
        view.endEditing(true)
    }
    
}

// MARK: - TABLE VIEW METHODS
extension ApplyFilterViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.countryListData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CountryTableViewCell", for: indexPath) as! CountryTableViewCell
        let data = viewModel.countryListData[indexPath.row]
        cell.configData(data: data,isSelected: (Int.getInt(self.viewModel.filterInfo.country?.id) - 1) == indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (self.viewModel.countryListData.count > indexPath.row) {
            let data = viewModel.countryListData[indexPath.row]
            self.viewModel.setCountry(data)
            self.refreshCountrySelection()
        }
    }
    
}
extension ApplyFilterViewController:HandleTableRefresh {
    func refreshTable(for string: String) {
        self.tblCountry.reloadData()
    }
}
