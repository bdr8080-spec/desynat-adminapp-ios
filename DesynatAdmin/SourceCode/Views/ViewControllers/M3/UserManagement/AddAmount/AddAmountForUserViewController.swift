//
//  AddAmountForUserViewController.swift
//  DesynatAdmin
//
//  Created by fluper on 21/11/25.
//

import UIKit

class AddAmountForUserViewController: UIViewController {

  @IBOutlet weak var headerView: UIView!
  @IBOutlet weak var amountTextFiled: UITextField!
  
  private lazy var viewModel = AddAmountViewModel(hostVC: self)
  var userId: Int? = 0
  var onAmountAdded: (() -> Void)?

  override func viewDidLoad() {
    super.viewDidLoad()
    headerView.layer.cornerRadius = 24
    headerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    headerView.clipsToBounds = true
    amountTextFiled.delegate = self
  }
  
  
  @IBAction func dismissDidTapped(_ sender: Any) {
    self.dismiss(animated: true)
  }
  
  @IBAction func applyDidTapped(_ sender: Any) {
    if viewModel.validFields() {
        viewModel.addAmountAPI()
    }
  }

}

extension AddAmountForUserViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        
        // Current text in the field
        let currentText = textField.text ?? ""
        
        // Compute the updated text
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        // 1️⃣ Limit to 7 characters
        if updatedText.count > 7 {
            return false
        }
        
        // 2️⃣ Prevent starting with "0"
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
