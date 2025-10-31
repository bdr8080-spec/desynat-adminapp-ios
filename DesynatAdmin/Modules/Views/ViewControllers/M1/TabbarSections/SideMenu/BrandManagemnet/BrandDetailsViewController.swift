//
//  BrandDetailsViewController.swift
//  DesynatAdmin
//
//  Created by Rakhi Kumari on 31/10/25.
//

import UIKit

class BrandDetailsViewController: UIViewController {

    @IBOutlet weak var brandNameLabel: UILabel!
    @IBOutlet weak var brandImageView: CustomImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func backDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func editDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func uploadImageDidTapped(_ sender: Any) {
    }
    
    @IBAction func statusDidTapped(_ sender: Any) {
    }
    
    
    @IBAction func deleteDidTapped(_ sender: Any) {
    }
}
