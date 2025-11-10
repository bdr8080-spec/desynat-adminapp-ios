//
//  RejectReasonViewController.swift
//  DesynatAdmin
//
//  Created by Meet Goti on 07/11/25.
//

import UIKit
import IQTextView

class RejectReasonViewController: UIViewController {
    @IBOutlet weak var viewMain: CustomView!
    @IBOutlet weak var txtViewReason: IQTextView!
    private var viewModel : RejectReasonViewModel = RejectReasonViewModel()
    private(set) var callBack : ((String) -> Void)?
    
    @IBOutlet weak var lblPlace: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setUpUi()
    }
    
    private func setUpUi() {
        self.viewMain.borderRadiusWithCornerMask(radius: 24,cornerMask: [.layerMinXMinYCorner,.layerMaxXMinYCorner])
        self.txtViewReason.delegate = self
        self.lblPlace.isUserInteractionEnabled = false
    }
    
    func setCallback(_ callBack:((String) -> Void)?)  {
        self.callBack = callBack
    }
    
    @IBAction func handleSubmit(_ sender: Any) {
        if (self.viewModel.reason.isEmpty) {
            self.showAlert(msg: "Please provide reason")
            return
        }
        self.txtViewReason.becomeFirstResponder()
        self.callBack?(self.viewModel.reason)
    }
    
    @IBAction func handleClose(_ sender: Any) {
        
        self.dismiss(animated: false)
    }

}
extension RejectReasonViewController : UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        self.lblPlace.isHidden = !textView.text.isEmpty
        
        self.viewModel.setReason(textView.text)
    }
}
