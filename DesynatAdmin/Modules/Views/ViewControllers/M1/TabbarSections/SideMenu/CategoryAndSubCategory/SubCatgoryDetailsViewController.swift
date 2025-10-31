//
//  SubCatgoryDetailsViewController.swift
//  DesynatAdmin
//
//  Created by Rakhi Kumari on 31/10/25.
//

import UIKit

class SubCatgoryDetailsViewController: UIViewController {

    
    @IBOutlet weak var mainImageView: CustomImageView!
    @IBOutlet weak var subCatgeoryLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func backDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }

    @IBAction func editDidTapped(_ sender: Any) {
    }
    
    @IBAction func deleteDidTapped(_ sender: Any) {
    }
    
    @IBAction func activeStatusDidTapped(_ sender: Any) {
    }
    
    @IBAction func uploadImageDidTapped(_ sender: Any) {
    }
    
}
