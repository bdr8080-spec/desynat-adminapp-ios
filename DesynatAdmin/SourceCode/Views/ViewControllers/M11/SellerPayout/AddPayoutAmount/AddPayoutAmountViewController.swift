//
//  AddPayoutAmountViewController.swift
//  DesynatAdmin
//
//  Created by fluper_mac3 on 19/03/26.
//

import UIKit

class AddPayoutAmountViewController: UIViewController {

    @IBOutlet weak var headerView: UIView!
    var onSubmit: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        handleUISetup()
    }
    
    @IBAction func dismissDidTapepd(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func submitDidTapped(_ sender: Any) {
        onSubmit?()
        self.dismiss(animated: true)
    }
    
    //MARK: Function's declaration
    private func handleUISetup() {
        headerView.layer.cornerRadius = 24
        headerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        headerView.clipsToBounds = true
    }
}
