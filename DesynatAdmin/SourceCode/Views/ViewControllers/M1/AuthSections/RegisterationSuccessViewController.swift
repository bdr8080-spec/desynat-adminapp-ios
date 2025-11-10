//
//  RegisterationSuccessViewController.swift
//  DesynatUser
//
//  Created by Rakhi Kumari on 23/10/25.
//

import UIKit

class RegisterationSuccessViewController: UIViewController {

    @IBOutlet weak var descriptionLabel: UILabel!
    
    var comingReason: ComingReasonAtRegisterationSuccess = .passwordUpdated
    private var titleString: String = ""
    var callBackDismiss: (()->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
            self.dismiss(animated: true) {
                self.callBackDismiss?()
            }
        }
        if titleString.isEmpty {
            initialSetup()
            descriptionLabel.text = titleString
        } else {
            descriptionLabel.text = titleString
        }
    }
    
    func initialSetup() {
        switch comingReason {
        case .passwordUpdated:
            self.titleString = "Password Reset\nsuccessfully!"
        case .accountCreated:
            self.titleString = "Thank you for sinning up\nwith DESYNAT"
        }
    }
    func setTitle(_ string:String)  {
        self.titleString = string
    }
}

enum ComingReasonAtRegisterationSuccess {
    case passwordUpdated
    case accountCreated
}
