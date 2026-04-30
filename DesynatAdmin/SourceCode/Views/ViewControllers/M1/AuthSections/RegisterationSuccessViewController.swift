//
//  RegisterationSuccessViewController.swift
//  DesynatUser
//
//  Created by Rakhi Kumari on 23/10/25.
//

import UIKit

class RegisterationSuccessViewController: UIViewController {
    
    // MARK: - IBOutlet's
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    // MARK: - Property Decalaration
    var comingReason: ComingReasonAtRegisterationSuccess = .passwordUpdated
    private var titleString: String = ""
    var callBackDismiss: (()->())?
    
    // MARK: - View's LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
            self.dismiss(animated: true) {
                self.callBackDismiss?()
            }
        }
        if titleString.isEmpty {
            initialSetup()
            descriptionLabel.text = titleString.localiz()
        } else {
            descriptionLabel.text = titleString.localiz()
        }
    }
    
    //MARK: Function's declaration
    func initialSetup() {
        mainImageView.image = UIImage(named: "done")
        switch comingReason {
        case .passwordUpdated:
            self.titleString = "Password Reset\nsuccessfully!"
        case .accountCreated:
            self.titleString = "Thank you for signning up\nwith DESYNAT"
        case .LiveRequestIsDone:
            self.titleString = "Request accepted\nsuccessfully!"
            mainImageView.image = UIImage(named: "darkGreenCompletion")
        case .AffiliateUserManagement:
            self.titleString = "Affiliate user approved\nsuccessfully!"
            mainImageView.image = UIImage(named: "darkGreenCompletion")
        case .ceredentailSentSuccessfully:
            self.titleString = "Credential sent\nsuccessfully!"
            mainImageView.image = UIImage(named: "darkGreenCompletion")
        }
    }
    
    func setTitle(_ string:String)  {
        self.titleString = string
    }
}

enum ComingReasonAtRegisterationSuccess {
    case passwordUpdated
    case accountCreated
    case LiveRequestIsDone
    case AffiliateUserManagement
    case ceredentailSentSuccessfully
}
