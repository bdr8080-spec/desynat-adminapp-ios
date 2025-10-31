//
//  AddNewBrandViewController.swift
//  DesynatAdmin
//
//  Created by Rakhi Kumari on 31/10/25.
//

import UIKit

class AddNewBrandViewController: UIViewController {
    
    @IBOutlet weak var brandImageView: CustomImageView!
    @IBOutlet weak var brandNameArabicTextField: UITextField!
    @IBOutlet weak var brandNameEnglishTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func backDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func submitDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func uploadImageDidTapped(_ sender: Any) {
        
    }
    
    
    
}
