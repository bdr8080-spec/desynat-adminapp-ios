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
      let param: [String: Any] = ["country_id": shippingInfo?.countryID ?? 0,
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
      fromTF.text = shippingInfo?.rangeFrom
      toTF.text = shippingInfo?.rangeTo
      delieryChargeTF.text = shippingInfo?.shippingFee
    }
  }
  
  private func handleUISetup() {
    headerView.layer.cornerRadius = 24
    headerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    headerView.clipsToBounds = true
  }
  
  private func validateFields() -> Bool {
    guard let fromText = fromTF.text, !fromText.isEmpty,
          let toText = toTF.text, !toText.isEmpty,
          let deliveryText = delieryChargeTF.text, !deliveryText.isEmpty else {
      showAlert(msg: "All fields are required")
      return false
    }
    
    guard let fromValue = Double(fromText), let toValue = Double(toText), toValue > fromValue else {
      showAlert(msg: "To value should be greater than From value")
      return false
    }
    
    return true
  }
  
}

extension AddEditShippingChargesViewController: UITextFieldDelegate {
  
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    if string.contains(" ") { return false }
    if let currentText = textField.text, currentText.isEmpty, string == "0" { return false }
    if !CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: string)) { return false }
    if textField == fromTF || textField == toTF || textField == delieryChargeTF {
      let currentText = textField.text ?? ""
      guard let stringRange = Range(range, in: currentText) else { return false }
      let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
      if updatedText.count > 7 {
        return false
      }
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
