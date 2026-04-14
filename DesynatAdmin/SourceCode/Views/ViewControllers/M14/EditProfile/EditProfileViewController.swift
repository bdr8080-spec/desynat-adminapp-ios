//
//  EditProfileViewController.swift
//  DesynatAdmin
//
//  Created by  shailendra singh on 30/03/26.
//

import UIKit

class EditProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    // MARK: - Navigation
    @IBAction func backBtnTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func changePasswordTapped(_ sender: Any) {
        let vc =  ChangePassowrdViewController.instantiate(fromAppStoryboard: .NotificationCMS)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
