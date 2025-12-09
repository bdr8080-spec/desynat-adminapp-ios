//
//  PromocodeDetailsViewController.swift
//  DesynatAdmin
//
//  Created by fluper on 09/12/25.
//

import UIKit

class PromocodeDetailsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
  @IBAction func backDidTapped(_ sender: Any) {
    self.navigationController?.popViewController(animated: true)
  }
  
  @IBAction func deleteDidTapepd(_ sender: Any) {
    
  }
  
  @IBAction func editDidTapped(_ sender: Any) {
    let nextVC = AddPromocodeViewController.instantiate(fromAppStoryboard: .ShippingPromocode)
    nextVC.isComingForEdit = true
    self.navigationController?.pushViewController(nextVC, animated: true)
  }
  
}
