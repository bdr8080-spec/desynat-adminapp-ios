//
//  FilterForDealsViewController.swift
//  DesynatAdmin
//
//  Created by fluper on 07/01/26.
//

import UIKit

class FilterForDealsViewController: UIViewController {
  
  @IBOutlet weak var headerView: UIView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    handleUISetup()
  }
  
  @IBAction func dismissDidTapped(_ sender: Any) {
    self.dismiss(animated: true)
  }
  
  private func handleUISetup() {
    headerView.layer.cornerRadius = 24
    headerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    headerView.clipsToBounds = true
  }
  
}
