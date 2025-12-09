//
//  AddPromocodeViewController.swift
//  DesynatAdmin
//
//  Created by fluper on 09/12/25.
//

import UIKit

class AddPromocodeViewController: UIViewController {

  var isComingForEdit: Bool = false
  
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
  @IBAction func backDidTapped(_ sender: Any) {
    self.navigationController?.popViewController(animated: true)
  }

}
