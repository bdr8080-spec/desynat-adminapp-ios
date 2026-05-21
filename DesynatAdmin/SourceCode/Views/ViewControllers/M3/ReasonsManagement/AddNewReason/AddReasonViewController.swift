//
//  AddReasonViewController.swift
//  DesynatAdmin
//
//  Created by fluper on 20/11/25.
//

import UIKit

class AddReasonViewController: UIViewController {
    
    // MARK: - IBOutlet's
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var arabicReasonTF: ArabicTextField!
    @IBOutlet weak var englishReasonTF: UITextField!
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: - Property Decalaration
    var isComingForEdit: Bool = false
    var reasonId: Int? = 0
    var type: Int? = 1
    private lazy var viewModel = AddReasonViewModel(hostVC: self)
    var onUpdate: (() -> Void)?
    var reasonForEdit: ReasonsListModel?
    
    // MARK: - View's LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        englishReasonTF.delegate = self
        arabicReasonTF.delegate = self
        if isComingForEdit {
            titleLabel.text = "Edit Reason".localiz()
            getReasonDetails()     // ⬅️ Add this
        } else {
            titleLabel.text = "Add New Reason".localiz()
        }
        
        headerView.layer.cornerRadius = 24
        headerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        headerView.clipsToBounds = true
    }
    
    // MARK: - Button's Action
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
    
    //MARK: Function's declaration
    func getReasonDetails() {
        DispatchQueue.main.async {
            self.englishReasonTF.text = self.reasonForEdit?.reasonEnglish ?? ""
            self.arabicReasonTF.text = self.reasonForEdit?.reasonArabic ?? ""
            self.type = self.reasonForEdit?.type
        }
    }
    
    
}

//MARK: UITextFieldDelegate Methods
extension AddReasonViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        var validation: StringValidation?
        
        if string.isEmpty { return true }
        
        if textField == englishReasonTF {
            if currentText.hasPrefix(" ") {
                return false
            }
            validation = StringValidation(string: currentText, characterCount: 200, validation: .firstName)
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
                    CommonUtils.showToast(message: "Please switch to Arabic keyboard".localiz())
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
