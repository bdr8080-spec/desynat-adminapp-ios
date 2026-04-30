//
//  AddTimeSlotViewController.swift
//  DesynatAdmin
//
//  Created by fluper on 06/01/26.
//

import UIKit

class AddTimeSlotViewController: UIViewController {
    
    // MARK: - IBOutlet's
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var fromHHLabel: UILabel!
    @IBOutlet weak var fromMMLabel: UILabel!
    @IBOutlet weak var fromAMLabel: UILabel!
    @IBOutlet weak var toHHLabel: UILabel!
    @IBOutlet weak var toMMLabel: UILabel!
    @IBOutlet weak var toAMLabel: UILabel!
    
    // MARK: - Property Decalaration
    var countryId: Int = 0
    var selectedDate: String = "" // e.g., "2026-01-05"
    var selectedFromDate: String = ""
    var selectedToDate: String = ""
    var isComingForEdit: Bool = false
    
    // MARK: - Picker properties
    private let pickerView = UIPickerView()
    private var activePickerType: PickerType?
    private var activeTimeType: TimeType?
    
    private var fromHour = "HH"
    private var fromMinute = "MM"
    private var fromAmPm = "AM"
    
    private var toHour = "HH"
    private var toMinute = "MM"
    private var toAmPm = "AM"
    
    private let hours = Array(1...12).map { String(format: "%02d", $0) }
    private let minutes = Array(0...59).map { String(format: "%02d", $0) }
    private let amPm = ["AM", "PM"]
    
    // Hidden textField to show picker
    private let hiddenTextField = UITextField(frame: .zero)
    var onChangesDone: (() -> Void)?
    private lazy var viewModel = AddTimeSlotViewModel(hostVC: self)
    var slectedTimeSlot: LiveRequestListDataModel?
    
    // MARK: - View's LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        handleUISetup()
        setupPicker()
        updateLabels()
        if isComingForEdit {
            prefillTime(from: slectedTimeSlot?.from ?? "", to: slectedTimeSlot?.to ?? "")
        }
    }
    
    // MARK: - Button's Action
    @IBAction func dismissDidTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    // FROM Pickers
    @IBAction func fromHHDidTapped(_ sender: Any) {
        showPicker(type: .hour, timeType: .from)
    }
    
    @IBAction func fromMMAction(_ sender: Any) {
        showPicker(type: .minute, timeType: .from)
    }
    
    @IBAction func fromAMAction(_ sender: Any) {
        showPicker(type: .ampm, timeType: .from)
    }
    
    // TO Pickers
    @IBAction func toHHDidTapped(_ sender: Any) {
        showPicker(type: .hour, timeType: .to)
    }
    
    @IBAction func toMMDidTapped(_ sender: Any) {
        showPicker(type: .minute, timeType: .to)
    }
    
    @IBAction func toAmDidTapped(_ sender: Any) {
        showPicker(type: .ampm, timeType: .to)
    }
    
    @IBAction func submitButtonTapped(_ sender: Any) {
        // Check if From and To times are selected
        if fromHour.isEmpty || fromMinute.isEmpty || fromAmPm.isEmpty ||
            toHour.isEmpty || toMinute.isEmpty || toAmPm.isEmpty {
            showAlert(msg: "Please select both From and To times".localiz())
            return
        }
        
        // Convert times to Date for comparison
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        
        //Validate FROM time
        let fromTimeString = "\(fromHour):\(fromMinute) \(fromAmPm)"
        guard let fromDate = formatter.date(from: fromTimeString) else {
            showAlert(msg: "Please select From time".localiz())
            return
        }
        
        //Validate TO time
        let toTimeString = "\(toHour):\(toMinute) \(toAmPm)"
        guard let toDate = formatter.date(from: toTimeString) else {
            showAlert(msg: "Please select To time".localiz())
            return
        }
        
        // Check if From < To
        if fromDate >= toDate {
            showAlert(msg: "From time must be earlier than To time".localiz())
            return
        }
        
        let fromTime = "\(fromHour):\(fromMinute) \(fromAmPm)"
        let toTime = "\(toHour):\(toMinute) \(toAmPm)"
        
        var apiParams: [String: Any] = [
            "country_id": countryId,
            "date": selectedDate,
            "from": fromTime,
            "to": toTime]
        if isComingForEdit {
            apiParams["timeslot_id"] = slectedTimeSlot?.id ?? 0
            viewModel.editTimeSlotRequest(param: apiParams)
        } else {
            viewModel.addTimeSlotRequest(param: apiParams)
        }
    }
    
    //MARK: Function's declaration
    private func handleUISetup() {
        headerView.layer.cornerRadius = 24
        headerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        headerView.clipsToBounds = true
        view.addSubview(hiddenTextField)
    }
    
    func prefillTime(from: String, to: String) {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        
        if let fromDate = formatter.date(from: from) {
            let calendar = Calendar.current
            fromHour = String(format: "%02d", calendar.component(.hour, from: fromDate) % 12 == 0 ? 12 : calendar.component(.hour, from: fromDate) % 12)
            fromMinute = String(format: "%02d", calendar.component(.minute, from: fromDate))
            fromAmPm = calendar.component(.hour, from: fromDate) >= 12 ? "PM" : "AM"
        }
        
        if let toDate = formatter.date(from: to) {
            let calendar = Calendar.current
            toHour = String(format: "%02d", calendar.component(.hour, from: toDate) % 12 == 0 ? 12 : calendar.component(.hour, from: toDate) % 12)
            toMinute = String(format: "%02d", calendar.component(.minute, from: toDate))
            toAmPm = calendar.component(.hour, from: toDate) >= 12 ? "PM" : "AM"
        }
        
        updateLabels()
    }
    
    
    private func setupPicker() {
        pickerView.delegate = self
        pickerView.dataSource = self
        
        // Toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done".localiz(), style: .done, target: self, action: #selector(donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel".localiz(), style: .plain, target: self, action: #selector(cancelPicker))
        toolbar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        
        hiddenTextField.inputView = pickerView
        hiddenTextField.inputAccessoryView = toolbar
    }
    
    // MARK: - Picker Helpers
    private func showPicker(type: PickerType, timeType: TimeType) {
        activePickerType = type
        activeTimeType = timeType
        
        // Preselect current value
        switch (timeType, type) {
        case (.from, .hour): if let row = hours.firstIndex(of: fromHour) { pickerView.selectRow(row, inComponent: 0, animated: false) }
        case (.from, .minute): if let row = minutes.firstIndex(of: fromMinute) { pickerView.selectRow(row, inComponent: 0, animated: false) }
        case (.from, .ampm): if let row = amPm.firstIndex(of: fromAmPm) { pickerView.selectRow(row, inComponent: 0, animated: false) }
        case (.to, .hour): if let row = hours.firstIndex(of: toHour) { pickerView.selectRow(row, inComponent: 0, animated: false) }
        case (.to, .minute): if let row = minutes.firstIndex(of: toMinute) { pickerView.selectRow(row, inComponent: 0, animated: false) }
        case (.to, .ampm): if let row = amPm.firstIndex(of: toAmPm) { pickerView.selectRow(row, inComponent: 0, animated: false) }
        }
        
        // Force the picker to reload to prevent old nil state
        pickerView.reloadAllComponents()
        hiddenTextField.becomeFirstResponder()
    }
    
    
    @objc private func donePicker() {
        hiddenTextField.resignFirstResponder()
        updateLabels()
    }
    
    @objc private func cancelPicker() {
        hiddenTextField.resignFirstResponder()
    }
    
    private func updateLabels() {
        fromHHLabel.text = fromHour
        fromMMLabel.text = fromMinute
        fromAMLabel.text = fromAmPm
        
        toHHLabel.text = toHour
        toMMLabel.text = toMinute
        toAMLabel.text = toAmPm
    }
}

// MARK: - UIPickerViewDelegate & DataSource
extension AddTimeSlotViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int { 1 }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        guard let type = activePickerType else { return 0 } // Avoid crash
        switch type {
        case .hour: return hours.count
        case .minute: return minutes.count
        case .ampm: return amPm.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard let type = activePickerType else { return nil } // Avoid crash
        switch type {
        case .hour: return hours[row]
        case .minute: return minutes[row]
        case .ampm: return amPm[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard let timeType = activeTimeType, let type = activePickerType else { return } // Avoid crash
        switch (timeType, type) {
        case (.from, .hour): fromHour = hours[row]
        case (.from, .minute): fromMinute = minutes[row]
        case (.from, .ampm): fromAmPm = amPm[row]
        case (.to, .hour): toHour = hours[row]
        case (.to, .minute): toMinute = minutes[row]
        case (.to, .ampm): toAmPm = amPm[row]
        }
        
        // Update labels live
        updateLabels()
    }
    
}

enum PickerType {
    case hour
    case minute
    case ampm
}

enum TimeType {
    case from
    case to
}
