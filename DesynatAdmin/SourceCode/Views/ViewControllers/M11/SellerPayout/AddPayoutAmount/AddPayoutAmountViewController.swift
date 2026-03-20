//
//  AddPayoutAmountViewController.swift
//  DesynatAdmin
//
//  Created by fluper_mac3 on 19/03/26.
//

import UIKit

class AddPayoutAmountViewController: UIViewController {

    @IBOutlet weak var transactionIdTF: UITextField!
    @IBOutlet weak var amountToBeSendTF: UITextField!
    @IBOutlet weak var headerView: UIView!
    
    var onSubmit: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        handleUISetup()
        transactionIdTF.delegate = self
        amountToBeSendTF.delegate = self
    }
    
    @IBAction func dismissDidTapepd(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func submitDidTapped(_ sender: Any) {
        onSubmit?()
        self.dismiss(animated: true)
    }
    
    //MARK: Function's declaration
    private func handleUISetup() {
        headerView.layer.cornerRadius = 24
        headerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        headerView.clipsToBounds = true
    }
}

//MARK: UITextFieldDelegate Methods
extension AddPayoutAmountViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        var validation: StringValidation?
        
        if string.isEmpty { return true }
        
        if textField == transactionIdTF || textField == amountToBeSendTF {
            // Prevent starting with space
            if currentText.hasPrefix(" ") {
                return false
            }
            
            // Only limit length
            return currentText.count <= 500
        }
        
        if let data = validation {
            return data.validate()
        } else {
            return true
        }
    }
}
