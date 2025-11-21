//
//  AddAmountForUserViewController.swift
//  DesynatAdmin
//
//  Created by fluper on 21/11/25.
//

import UIKit

class AddAmountForUserViewController: UIViewController {

  @IBOutlet weak var headerView: UIView!
  @IBOutlet weak var amountTextFiled: UITextField!
  
  private lazy var viewModel = AddAmountViewModel(hostVC: self)
  var userId: Int? = 0
  var onAmountAdded: (() -> Void)?

  override func viewDidLoad() {
    super.viewDidLoad()
    headerView.layer.cornerRadius = 24
    headerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    headerView.clipsToBounds = true
  }
  
  
  @IBAction func dismissDidTapped(_ sender: Any) {
    self.dismiss(animated: true)
  }
  
  @IBAction func applyDidTapped(_ sender: Any) {
    if viewModel.validFields() {
        viewModel.addAmountAPI()
    }
  }

}
