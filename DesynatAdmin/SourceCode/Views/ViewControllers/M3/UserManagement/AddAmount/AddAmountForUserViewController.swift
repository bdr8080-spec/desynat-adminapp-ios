//
//  AddAmountForUserViewController.swift
//  DesynatAdmin
//
//  Created by fluper on 21/11/25.
//

import UIKit

class AddAmountForUserViewController: UIViewController {
    
    // MARK: - IBOutlet's
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var amountTextFiled: UITextField!
    
    // MARK: - Property Decalaration
    private lazy var viewModel = AddAmountViewModel(hostVC: self)
    var userId: Int? = 0
    var onAmountAdded: (() -> Void)?
    
    // MARK: - View's LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        headerView.layer.cornerRadius = 24
        headerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        headerView.clipsToBounds = true
        amountTextFiled.delegate = self
    }
    
    // MARK: - Button's Action
    @IBAction func dismissDidTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func applyDidTapped(_ sender: Any) {
        if viewModel.validFields() {
            viewModel.addAmountAPI()
        }
    }
    
    //MARK: Function's declaration
}

//MARK: UITextFieldDelegate Methods
extension AddAmountForUserViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        
        // Current text in the field
        let currentText = textField.text ?? ""
        
        // Compute the updated text
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        // Limit to 7 characters
        if updatedText.count > 7 {
            return false
        }
        
        // Prevent starting with "0"
        if updatedText.count == 1 && updatedText == "0" {
            return false
        }
        
        // Allow only numbers
        let allowedCharacters = CharacterSet.decimalDigits
        if string.rangeOfCharacter(from: allowedCharacters.inverted) != nil {
            return false
        }
        
        return true
    }
}
