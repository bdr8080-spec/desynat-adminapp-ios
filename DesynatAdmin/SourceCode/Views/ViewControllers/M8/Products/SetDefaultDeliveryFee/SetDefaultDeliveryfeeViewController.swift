//
//  SetDefaultDeliveryfeeViewController.swift
//  DesynatAdmin
//
//  Created by fluper_mac3 on 16/02/26.
//

import UIKit

class SetDefaultDeliveryfeeViewController: UIViewController {
    
    // MARK: - IBOutlet's
    @IBOutlet weak var taxTF: UITextField!
    @IBOutlet weak var headerView: UIView!
    
    // MARK: - Property Decalaration
    private lazy var viewModel = SetDefaultDeliveryfeeViewModel(hostVC: self)
    var countryID: Int? = 0
    var taxAmount: String?
    var taxDefaultAmountSet: ((_ amount: String) -> Void)?
    var originalTaxValue: Double = 0.0
    
    // MARK: - View's LifeCycle Methods
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
    
    // MARK: - Button's Action
    @IBAction func saveChangesDidTapped(_ sender: Any) {
        handleDefaultTaxUpdate()
        
    }
    
    @IBAction func dismissDidTapepd(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    //MARK: Function's declaration
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
    
    private func handleDefaultTaxUpdate() {
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
            "id": countryID ?? "",
            "shipping_fee": formattedValue]
        viewModel.addDefaultShippingFees(param: params)
    }
    
}

//MARK: UITextFieldDelegate Methods
extension SetDefaultDeliveryfeeViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        
        if string == " " { return false }
        
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        
        var updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        let allowedCharacters = CharacterSet(charactersIn: "0123456789.")
        if string.rangeOfCharacter(from: allowedCharacters.inverted) != nil {
            return false
        }
        if updatedText.components(separatedBy: ".").count > 2 {
            return false
        }
        if let dotIndex = updatedText.firstIndex(of: ".") {
            let decimalPart = updatedText[updatedText.index(after: dotIndex)...]
            if decimalPart.count > 2 {
                return false
            }
        }
        
        if updatedText.count > 1 {
            
            if updatedText.hasPrefix("0") && !updatedText.hasPrefix("0.") {
                
                while updatedText.count > 1 && updatedText.hasPrefix("0") && !updatedText.hasPrefix("0.") {
                    updatedText.removeFirst()
                }
                
                textField.text = updatedText
                return false
            }
        }
        
        let components = updatedText.components(separatedBy: ".")
        if let integerPart = components.first {
            if integerPart.count > 7 {
                return false
            }
        }
        return true
    }
}
