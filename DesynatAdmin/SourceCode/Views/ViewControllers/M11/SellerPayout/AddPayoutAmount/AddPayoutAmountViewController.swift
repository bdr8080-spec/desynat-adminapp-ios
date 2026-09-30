//
//  AddPayoutAmountViewController.swift
//  DesynatAdmin
//
//  Created by fluper_mac3 on 19/03/26.
//

import UIKit

import UIKit

class AddPayoutAmountViewController: UIViewController {

    @IBOutlet weak var transactionIdTF: UITextField!
    @IBOutlet weak var amountToBeSendTF: UITextField!
    @IBOutlet weak var headerView: UIView!

    private lazy var viewModel = AddPayoutAmountViewModel(hostVC: self)
    var onSubmit: ((Double) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        handleUISetup()
        amountToBeSendTF.delegate = self
    }

    @IBAction func dismissDidTapepd(_ sender: Any) {
        self.dismiss(animated: true)
    }

    @IBAction func submitDidTapped(_ sender: Any) {
        guard let amountText = amountToBeSendTF.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !amountText.isEmpty else {
            showAlert(msg: "Please enter amount".localiz())
            return
        }
        
        guard amountText.count <= 7 else {
            showAlert(msg: "Amount cannot exceed 7 digits".localiz())
            return
        }
        
        guard let amount = Double(amountText), amount > 0 else {
            showAlert(msg: "Please enter a valid amount".localiz())
            return
        }
        
        self.onSubmit?(amount)
        self.dismiss(animated: true)
    }

    private func handleUISetup() {
        headerView.layer.cornerRadius = 24
        headerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        headerView.clipsToBounds = true
    }
}

// MARK: UITextFieldDelegate Methods

extension AddPayoutAmountViewController: UITextFieldDelegate {

    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {

        let currentText = (textField.text ?? "") as NSString
        let updatedText = currentText.replacingCharacters(in: range, with: string)

        if updatedText.hasPrefix(" ") {
            return false
        }
        if textField == amountToBeSendTF {
            // Allow backspace
            if string.isEmpty {
                return true
            }
            // Only allow digits
            if !string.allSatisfy({ $0.isNumber }) {
                return false
            }
            // Maximum 7 digits
            if updatedText.count > 7 {
                return false
            }
            // Prevent 0 as the amount
            if updatedText == "0" {
                return false
            }
            return true
        }
        return true
    }
}
