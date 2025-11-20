//
//  AddReasonViewController.swift
//  DesynatAdmin
//
//  Created by fluper on 20/11/25.
//

import UIKit

class AddReasonViewController: UIViewController {
  
  @IBOutlet weak var arabicReasonTF: UITextField!
  @IBOutlet weak var englishReasonTF: UITextField!
  @IBOutlet weak var titleLabel: UILabel!
  
  var isComingForEdit: Bool = false
  private lazy var viewModel = AddReasonViewModel(hostVC: self)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    if isComingForEdit {
      titleLabel.text = "Edit Reason"
    } else {
      titleLabel.text = "Add New Reason"
    }
  }
  
  @IBAction func submitDidTapped(_ sender: Any) {
    if viewModel.validFields() {
        if isComingForEdit {
            viewModel.editReasonApi()
        } else {
            viewModel.addReasonApi()
        }
    }
  }
  
  @IBAction func dismissDidTapped(_ sender: Any) {
    self.dismiss(animated: true)
  }
  
}

extension AddReasonViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        var validation: StringValidation?
        
        if string.isEmpty { return true }
        
        if textField == englishReasonTF {
            if currentText.hasPrefix(" ") {
                return false
            }
            validation = StringValidation(string: currentText, characterCount: 30, validation: .firstName)
        }
        
        if textField == arabicReasonTF {
            
            // Allowed Arabic Unicode ranges + spaces
            let allowedSet = CharacterSet(charactersIn: "\u{0600}"..."\u{06FF}")
                .union(CharacterSet(charactersIn: "\u{0750}"..."\u{077F}"))
                .union(CharacterSet(charactersIn: "\u{08A0}"..."\u{08FF}"))
                .union(CharacterSet.whitespaces)
            
            // Check every character (handles paste)
            for scalar in string.unicodeScalars {
                if !allowedSet.contains(scalar) {
                    CommonUtils.showToast(message: "Please switch to Arabic keyboard")
                    return false
                }
            }
            
            return true
        }
        
        if let data = validation {
            return data.validate()
        } else {
            return true
        }
    }
}
