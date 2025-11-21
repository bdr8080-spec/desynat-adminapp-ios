//
//  DriverDetailsViewController.swift
//  DesynatAdmin
//
//  Created by fluper on 21/11/25.
//

import UIKit

class DriverDetailsViewController: UIViewController {
  
  var userId: Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
  @IBAction func editDidTapped(_ sender: Any) {
    let vc = AddNewDriverViewController.instantiate(fromAppStoryboard: .ReasonManagement)
    vc.isComingForEdit = true
    vc.userId = userId
    self.navigationController?.present(vc, animated: false)
  }
  
  
  @IBAction func backDidTapped(_ sender: Any) {
    self.navigationController?.popViewController(animated: true)
  }
  
}
