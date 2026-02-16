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
    var originalTaxValue: Double = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        handleUISetup()
        taxTF.delegate = self
        if let taxString = taxAmount,
           let taxValue = Double(taxString) {
            taxTF.text = formatTax(taxValue)
            originalTaxValue = taxValue
        }
    }
    
    @IBAction func saveChangesDidTapped(_ sender: Any) {
        guard let text = taxTF.text, !text.isEmpty else {
            CommonUtils.showToast(message: "Please set charges")
            return
        }
        
        guard let newValue = Double(text) else {
            CommonUtils.showToast(message: "Invalid tax value")
            return
        }
        
        if newValue == originalTaxValue {
            CommonUtils.showToast(message: "No changes found")
            return
        }
        
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        formatter.numberStyle = .decimal
        let formattedValue = formatter.string(from: NSNumber(value: newValue)) ?? "\(newValue)"
        
        let params: [String: Any] = [
            "country_id": countryID ?? "",
            "tax": formattedValue]
        
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
    
    private func formatTax(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: value)) ?? "0"
    }
    
}

extension SetTaxViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if string == " " { return false }
        
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        var updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        let allowedCharacters = CharacterSet(charactersIn: "0123456789.")
        if string.rangeOfCharacter(from: allowedCharacters.inverted) != nil {
            return false
        }
        
        let decimalCount = updatedText.components(separatedBy: ".").count - 1
        if decimalCount > 1 { return false }
        
        if let dotIndex = updatedText.firstIndex(of: ".") {
            let decimalPart = updatedText[updatedText.index(after: dotIndex)...]
            if decimalPart.count > 2 {
                return false
            }
        }
        
        if updatedText.count > 1, updatedText.hasPrefix("0"), !updatedText.hasPrefix("0.") {
            updatedText.removeFirst()
            textField.text = updatedText
            return false
        }
        
        if let value = Double(updatedText), value > 100 {
            return false
        }
        
        return true
    }
    
}
