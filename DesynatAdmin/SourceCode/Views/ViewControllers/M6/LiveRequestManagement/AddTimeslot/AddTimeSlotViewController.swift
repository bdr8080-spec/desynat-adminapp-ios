//
//  AddTimeSlotViewController.swift
//  DesynatAdmin
//
//  Created by fluper on 06/01/26.
//

import UIKit

class AddTimeSlotViewController: UIViewController {
  
  @IBOutlet weak var headerView: UIView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    handleUISetup()
  }
  
  @IBAction func dismissDidTapped(_ sender: Any) {
    self.dismiss(animated: true)
  }
  
  
  @IBAction func fromHHDidTapped(_ sender: Any) {
    
  }
  
  @IBAction func fromMMAction(_ sender: Any) {
    
  }
  
  @IBAction func fromAMAction(_ sender: Any) {
    
  }
  
  @IBAction func toHHDidTapped(_ sender: Any) {
    
  }
  
  @IBAction func toMMDidTapped(_ sender: Any) {
    
  }
  
  @IBAction func toAmDidTapped(_ sender: Any) {
    
  }
  
  private func handleUISetup() {
    headerView.layer.cornerRadius = 24
    headerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    headerView.clipsToBounds = true
  }
}
