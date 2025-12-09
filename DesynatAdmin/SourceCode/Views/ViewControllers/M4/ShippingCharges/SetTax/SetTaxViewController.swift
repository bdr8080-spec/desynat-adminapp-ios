//
//  SetTaxViewController.swift
//  DesynatAdmin
//
//  Created by fluper on 09/12/25.
//

import UIKit

class SetTaxViewController: UIViewController {
  
  @IBOutlet weak var taxTF: UITextField!
  @IBOutlet weak var headerView: UIView!
  
  private lazy var viewModel = SetTaxViewModel(hostVC: self)
  var countryID: Int? = 0
  var taxAmount: String?
  var taxAmountSet: ((_ amount: String) -> Void)?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    handleUISetup()
    taxTF.delegate = self
    let tax = taxAmount?.isEmpty ?? false
    if !tax {
      taxTF.text = taxAmount
    }
  }
  
  @IBAction func saveChangesDidTapped(_ sender: Any) {
    guard let text = taxTF.text, !text.isEmpty else {
      CommonUtils.showToast(message: "Please set charges")
      return
    }
    //        guard let value = Int(text), value >= 0, value <= 100 else {
    //            CommonUtils.showToast(message: "Please enter a valid percentage (0–100)")
    //            return
    //        }
    let params: [String: Any] = [
      "country_id": countryID ?? "",
      "tax": text]
    viewModel.addShippingFees(param: params)
  }
  
  @IBAction func dismissDidTapepd(_ sender: Any) {
    self.dismiss(animated: true)
  }
  
  private func handleUISetup() {
    headerView.layer.cornerRadius = 24
    headerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    headerView.clipsToBounds = true
  }
  
}

extension SetTaxViewController: UITextFieldDelegate {
  
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
      
      if string == " " { return false }
      
      if string.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) != nil {
        return false
      }
      
      let currentText = textField.text ?? ""
      guard let stringRange = Range(range, in: currentText) else { return false }
      
      let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
      
      if updatedText.count == 1 && updatedText == "0" {
        return false
      }
      
      if let value = Int(updatedText), value > 100 {
        return false
      }
      
      return true
    }
  }

