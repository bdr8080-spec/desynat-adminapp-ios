//
//  AddPricePerDayViewController.swift
//  DesynatAdmin
//
//  Created by fluper on 09/12/25.
//

import UIKit

class AddPricePerDayViewController: UIViewController {
    
    // MARK: - IBOutlet's
    @IBOutlet weak var amountTF: UITextField!
    @IBOutlet weak var headerView: UIView!
    
    // MARK: - Property Decalaration
    var bannerDetails: BannersPerDayListDataModel?
    private lazy var viewModel = AddPricePerDayViewModel(hostVC: self)
    var onChangesAreDone: (() -> Void)?
    
    // MARK: - View's LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        handleUISetup()
        amountTF.delegate = self
        amountTF.text = bannerDetails?.perDayPrice
    }
    
    // MARK: - Button's Action
    @IBAction func saveChangesDidTapped(_ sender: Any) {
        guard let text = amountTF.text, !text.isEmpty else {
            showAlert(msg: "Please enter price".localiz())
            return
        }
        viewModel.addPricePerDay()
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
    
}

//MARK: UITextFieldDelegate Methods
extension AddPricePerDayViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.contains(" ") {
            return false
        }
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        if updatedText.count == 1 && updatedText == "0" {
            return false
        }
        if updatedText.count > 7 {
            return false
        }
        
        return true
    }
    
}
