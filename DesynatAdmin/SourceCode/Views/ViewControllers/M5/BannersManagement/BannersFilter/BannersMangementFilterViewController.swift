//
//  BannersMangementFilterViewController.swift
//  DesynatAdmin
//
//  Created by fluper on 16/12/25.
//

import UIKit

class BannersMangementFilterViewController: UIViewController {

  @IBOutlet weak var headerView: UIView!
  @IBOutlet weak var toTextField: UITextField!
  @IBOutlet weak var fromTextField: UITextField!
  @IBOutlet weak var countryLabel: CustomLabelFont!
  
  private lazy var viewModel = BannersMangementFilterViewModel(hostVC: self)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    handleUISetup()
  }
  
  @IBAction func dismissDidTapped(_ sender: Any) {
    self.dismiss(animated: true)
  }
  
  @IBAction func clearDidTapped(_ sender: Any) {
    dismiss(animated: true)
  }
  
  @IBAction func applyDidTapped(_ sender: Any) {
    dismiss(animated: true)
  }
  
  @IBAction func countryDidTapped(_ sender: UIButton) {
    
  }
  
  private func handleUISetup() {
    headerView.layer.cornerRadius = 24
    headerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    headerView.clipsToBounds = true
  }
  

  
  
}

