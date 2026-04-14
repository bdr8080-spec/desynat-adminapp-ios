//
//  AddPromocodeViewController.swift
//  DesynatAdmin
//
//  Created by fluper on 09/12/25.
//

import UIKit

class AddPromocodeViewController: UIViewController {
    
    // MARK: - IBOutlet's
    @IBOutlet weak var promocodeEnglishTF: UITextField!
    @IBOutlet weak var countryTF: UITextField!
    @IBOutlet weak var promocodeArabicTF: UITextField!
    @IBOutlet weak var descriptionEnglishTF: UITextField!
    @IBOutlet weak var descriptionArabicTF: UITextField!
    @IBOutlet weak var fristOrderImageView: UIImageView!
    @IBOutlet weak var everyOrderImageView: UIImageView!
    @IBOutlet weak var discountF: UITextField!
    @IBOutlet weak var minimumOrderTF: UITextField!
    @IBOutlet weak var upToDiscountTF: UITextField!
    @IBOutlet weak var startDateTF: UITextField!
    @IBOutlet weak var endDateTF: UITextField!
    
    // MARK: - Property Decalaration
    var isComingForEdit: Bool = false
    private lazy var viewModel = AddPromocodeViewModel(hostVC: self)
    var countryCode: Int? = 0
    let datePicker = UIDatePicker()
    private var activeTextField: UITextField?
    var selectedOrderType: Int = 1 // 1 = First Order, 2 = Every Order
    var promocodeDetails: PromocodeList?
    
    // MARK: - View's LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.getAllCountry()
        let textFields = [promocodeEnglishTF, promocodeArabicTF, descriptionEnglishTF, descriptionArabicTF, discountF, minimumOrderTF, upToDiscountTF]
        setUpTextFields()
        textFields.forEach { $0?.delegate = self }
        confidData()
    }
    
    // MARK: - Button's Action
    @IBAction func backDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func countryDidTapped(_ sender: UIButton) {
        let countryNames = viewModel.countryListData.map { country -> String in
            let name = country.name ?? ""
            //      let dialCode = country.dialCode ?? ""
            let flag = country.flag ?? "🇰🇼"
            return "\(flag)  \(name)"// (\(dialCode))"
        }
        
        kSharedAppDelegate.dropDown(dataSource: countryNames, anchorView: sender) { index, item in
            let selectedCountry = self.viewModel.countryListData[index]
            self.countryTF.text = selectedCountry.name
            self.countryCode = selectedCountry.id ?? 0
        }
    }
    
    @IBAction func firstOrderDidTapped(_ sender: Any) {
        selectedOrderType = 1
        fristOrderImageView.image = UIImage(named: "radioSelected")
        everyOrderImageView.image = UIImage(named: "radioUnselected")
    }
    
    @IBAction func everyOrderDidTapped(_ sender: Any) {
        selectedOrderType = 2
        everyOrderImageView.image = UIImage(named: "radioSelected")
        fristOrderImageView.image = UIImage(named: "radioUnselected")
    }
    
    @IBAction func submitDidTapped(_ sender: Any) {
        let requiredFields: [(UITextField, String)] = [
            (countryTF, "Please select Country"),
            (promocodeEnglishTF, "Please enter Promocode name in English"),
            (promocodeArabicTF, "Please enter Promocode name in Arabic"),
            (descriptionEnglishTF, "Please enter Description in English"),
            (descriptionArabicTF, "Please enter Description in Arabic"),
            (discountF, "Please enter Discount %"),
            (minimumOrderTF, "Please enter Minimum Order Value"),
            (upToDiscountTF, "Please enter Upto Discount"),
            (startDateTF, "Please select Start Date"),
            (endDateTF, "Please select End Date"),
        ]
        
        for (tf, message) in requiredFields {
            let text = tf.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            if text.isEmpty {
                //        showToast(msg: message)
                showAlert(msg: message)
                tf.becomeFirstResponder()
                return
            }
        }
        if isComingForEdit {
            viewModel.editPromocode()
        } else {
            viewModel.addPromocode()
        }
    }
    
    //MARK: Function's declaration
    func confidData() {
        countryTF.text = promocodeDetails?.countryInfo?.name
        countryCode = promocodeDetails?.countryID
        promocodeEnglishTF.text = promocodeDetails?.nameEnglish
        promocodeArabicTF.text = promocodeDetails?.nameArabic
        descriptionEnglishTF.text = promocodeDetails?.descriptionEnglish
        descriptionArabicTF.text = promocodeDetails?.descriptionArabic
        let applicableFor = promocodeDetails?.applicableFor
        if applicableFor == 2 {
            selectedOrderType = 2
            everyOrderImageView.image = UIImage(named: "radioSelected")
            fristOrderImageView.image = UIImage(named: "radioUnselected")
        } else {
            selectedOrderType = 1
            fristOrderImageView.image = UIImage(named: "radioSelected")
            everyOrderImageView.image = UIImage(named: "radioUnselected")
        }
        discountF.text = promocodeDetails?.discountPercent
        minimumOrderTF.text = promocodeDetails?.minOrderValue
        upToDiscountTF.text = promocodeDetails?.uptoDiscount
        startDateTF.text = convertDate(promocodeDetails?.startDate ?? "")
        endDateTF.text = convertDate(promocodeDetails?.endDate ?? "")
    }
    
    func convertDate(_ input: String) -> String? {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "dd/MM/yyyy"
        outputFormatter.locale = Locale(identifier: "en_US_POSIX")
        if let date = inputFormatter.date(from: input) {
            return outputFormatter.string(from: date)
        }
        return nil
    }
}

//MARK: UITextFieldDelegate Methods
extension AddPromocodeViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        
        let newText = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        if newText.hasPrefix(" ") { return false }
        if textField == discountF || textField == minimumOrderTF || textField == upToDiscountTF {
            if !CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: string)) {
                return false
            }
            if newText.count == 1 && newText == "0" {
                return false
            }
            if textField != discountF && newText.count > 7 {
                return false
            }
            if textField == discountF {
                if let value = Int(newText), value > 100 {
                    return false
                }
            }
            return true
        }
        if textField == promocodeEnglishTF {
            let validation = StringValidation(string: newText, characterCount: 30, validation: .firstName)
            return validation.validate()
        }
        if textField == promocodeArabicTF || textField == descriptionArabicTF {
            let allowedSet = CharacterSet(charactersIn: "\u{0600}"..."\u{06FF}")
                .union(CharacterSet(charactersIn: "\u{0750}"..."\u{077F}"))
                .union(CharacterSet(charactersIn: "\u{08A0}"..."\u{08FF}"))
                .union(.whitespaces)
            for scalar in string.unicodeScalars {
                if !allowedSet.contains(scalar) {
                    CommonUtils.showToast(message: "Please switch to Arabic keyboard")
                    return false
                }
            }
            return true
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        if textField == endDateTF {
            if let fromText = startDateTF.text,
               let fromDate = formatter.date(from: fromText) {
                datePicker.minimumDate = fromDate
            } else {
                datePicker.minimumDate = nil
            }
        }
        if textField == startDateTF {
            datePicker.minimumDate = nil
        }
    }
}

extension AddPromocodeViewController {
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
        
        startDateTF.inputView = datePicker
        startDateTF.inputAccessoryView = toolbar
        endDateTF.inputView = datePicker
        endDateTF.inputAccessoryView = toolbar
        
        startDateTF.delegate = self
        endDateTF.delegate = self
    }
    
    @objc private func doneDatePicker() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        
        if activeTextField == startDateTF {
            startDateTF.text = formatter.string(from: datePicker.date)
            if let toText = endDateTF.text,
               let toDate = formatter.date(from: toText),
               toDate < datePicker.date {
                endDateTF.text = ""
            }
        }
        
        else if activeTextField == endDateTF {
            if let fromText = startDateTF.text,
               let fromDate = formatter.date(from: fromText),
               datePicker.date < fromDate {
                showValidationAlert()
                return
            }
            endDateTF.text = formatter.string(from: datePicker.date)
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


