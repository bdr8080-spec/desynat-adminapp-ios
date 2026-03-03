//
//  AddEditShippingChargesViewController.swift
//  DesynatAdmin
//
//  Created by fluper on 09/12/25.
//

import UIKit

class AddEditShippingChargesViewController: UIViewController {
    
    @IBOutlet weak var toTF: UITextField!
    @IBOutlet weak var fromTF: UITextField!
    @IBOutlet weak var delieryChargeTF: UITextField!
    @IBOutlet weak var addChargesLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var headerView: UIView!
    
    var commingReason: ComingReasonAtAddEditShipping = .add
    var shippingInfo: ShippingChargesList?
    private lazy var viewModel = AddEditShippingChargesViewModel(hostVC: self)
    var changesAreDone: (() -> Void)?
    var countryId: Int? = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        handleUISetup()
        setupTextFieldDelegates()
    }
    
    @IBAction func dismissDidTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    
    @IBAction func saveChangesDidTapped(_ sender: Any) {
        guard validateFields() else { return }
        switch commingReason {
        case .add:
            let param: [String: Any] = ["country_id": countryId ?? 0,
                                        "range_from": fromTF.text?.trimmed() ?? "",
                                        "range_to": toTF.text?.trimmed() ?? "",
                                        "shipping_fee": delieryChargeTF.text?.trimmed() ?? ""]
            viewModel.addShippingInfo(param: param)
        case .edit:
            let param: [String: Any] = ["shipping_charge_id": shippingInfo?.id ?? 0,
                                        "range_from": fromTF.text?.trimmed() ?? "",
                                        "range_to": toTF.text?.trimmed() ?? "",
                                        "shipping_fee": delieryChargeTF.text?.trimmed() ?? ""]
            viewModel.editShippingInfo(param: param)
        }
        
    }
    
    private func setupTextFieldDelegates() {
        fromTF.delegate = self
        toTF.delegate = self
        delieryChargeTF.delegate = self
    }
    
    private func initialSetup() {
        switch commingReason {
        case .add:
            titleLabel.text = "Add Delivery Charge"
            addChargesLabel.text = "Add Charges"
        case .edit:
            titleLabel.text = "Edit"
            addChargesLabel.text = "Save Changes"
            
            fromTF.text = shippingInfo?.rangeFrom?.roundedIntString
            toTF.text = shippingInfo?.rangeTo?.roundedIntString
            delieryChargeTF.text = shippingInfo?.shippingFee?.roundedIntString
        }
    }
    
    private func handleUISetup() {
        headerView.layer.cornerRadius = 24
        headerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        headerView.clipsToBounds = true
    }
    
    private func validateFields() -> Bool {
        guard let fromText = fromTF.text, !fromText.isEmpty else {
            showAlert(msg: "Please Enter Range")
            return false
        }
        guard let toText = toTF.text, !toText.isEmpty else {
            showAlert(msg: "Please Enter Range")
            return false
        }
        guard let deliveryText = delieryChargeTF.text, !deliveryText.isEmpty else {
            showAlert(msg: "Please enter Delivery Charge")
            return false
        }
        guard let fromValue = Double(fromText) else {
            showAlert(msg: "From value must be a number")
            return false
        }
        
        guard let toValue = Double(toText) else {
            showAlert(msg: "To value must be a number")
            return false
        }
        
        guard toValue > fromValue else {
            showAlert(msg: "To value should be greater than From value")
            return false
        }
        
        guard let deliveryValue = Double(deliveryText) else {
            showAlert(msg: "Delivery Charge must be a number")
            return false
        }
        
        return true
    }
    
    
}


extension AddEditShippingChargesViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        // Prevent spaces
        if string.contains(" ") { return false }
        
        // Allow only digits
        if !CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: string)) {
            return false
        }
        
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        var updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        // Remove leading zero if next character is digit (for delieryChargeTF)
        if textField == delieryChargeTF {
            if updatedText.count > 1, updatedText.hasPrefix("0") {
                updatedText.removeFirst()
                textField.text = updatedText
                return false
            }
        }
        
        // Limit length for fromTF, toTF, and delieryChargeTF
        if textField == fromTF || textField == toTF || textField == delieryChargeTF {
            if updatedText.count > 7 { return false }
        }
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == toTF {
            guard let fromText = fromTF.text, let toText = toTF.text,
                  let fromValue = Int(fromText), let toValue = Int(toText) else { return }
            
            if toValue <= fromValue {
                CommonUtils.showToast(message: "To value should be greater than From value")
                //toTF.text = ""
            }
        }
        if textField == fromTF {
            if let fromText = fromTF.text, let toText = toTF.text,
               let fromValue = Int(fromText), let toValue = Int(toText),
               fromValue >= toValue {
                //toTF.text = ""
            }
        }
    }
}


enum ComingReasonAtAddEditShipping {
    case add
    case edit
}

