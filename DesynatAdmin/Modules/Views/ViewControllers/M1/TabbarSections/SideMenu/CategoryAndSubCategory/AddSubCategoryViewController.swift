//
//  AddSubCategoryViewController.swift
//  DesynatAdmin
//
//  Created by Rakhi Kumari on 31/10/25.
//

import UIKit

class AddSubCategoryViewController: UIViewController {

    @IBOutlet weak var subCategoryArabicTextField: UITextField!
    @IBOutlet weak var mainImageView: CustomImageView!
    @IBOutlet weak var subCategoryTextField: UITextField!
    
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
