//
//  RejectReasonViewController.swift
//  DesynatAdmin
//
//  Created by Meet Goti on 07/11/25.
//

import UIKit
import IQTextView

enum SellerRejectionType {
  case completeProject,documents
  var paramterValue:String {
    switch self {
    case .completeProject:
      "complete"
    case .documents:
      "document"
    }
  }
}

class RejectReasonViewController: UIViewController {
  @IBOutlet weak var viewMain: CustomView!
  @IBOutlet weak var txtViewReason: IQTextView!
  @IBOutlet weak var btnCompleteProject: CustomButton!
  @IBOutlet weak var btnDocument: CustomButton!
  @IBOutlet weak var lblPlace: UILabel!
  
  private var viewModel : RejectReasonViewModel = RejectReasonViewModel()
  private(set) var callBack : ((String,SellerRejectionType) -> Void)?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.setUpUi()
  }
  
  private func setUpUi() {
    self.viewMain.borderRadiusWithCornerMask(radius: 24,cornerMask: [.layerMinXMinYCorner,.layerMaxXMinYCorner])
    self.txtViewReason.delegate = self
    self.lblPlace.isUserInteractionEnabled = false
    self.switchType(to: .completeProject)
    self.btnDocument.semanticContentAttribute = .forceLeftToRight
    self.btnCompleteProject.semanticContentAttribute = .forceLeftToRight
  }
  
  func setCallback(_ callBack:((String,SellerRejectionType) -> Void)?)  {
    self.callBack = callBack
  }
  func switchType(to type:SellerRejectionType) {
    self.viewModel.setRejectTyp(type)
    self.btnDocument.setImage(type == .documents ? .radioSelected : .radioUnselected, for: .normal)
    self.btnCompleteProject.setImage(type == .completeProject ? .radioSelected : .radioUnselected, for: .normal)
  }
  
  @IBAction func handleSubmit(_ sender: Any) {
    if (self.viewModel.reason.isEmpty) {
      self.showAlert(msg: "Please enter reason")
      return
    }
    self.txtViewReason.becomeFirstResponder()
    self.callBack?(self.viewModel.reason,self.viewModel.rejectType)
  }
  
  @IBAction func handleClose(_ sender: Any) {
    self.dismiss(animated: false)
  }
  
  @IBAction func handleCompleteProject(_ sender: Any) {
    self.switchType(to: .completeProject)
    
  }
  
  @IBAction func handleDocumentReject(_ sender: Any) {
    self.switchType(to: .documents)
  }
  
}
extension RejectReasonViewController : UITextViewDelegate {
  func textViewDidChange(_ textView: UITextView) {
    self.lblPlace.isHidden = !textView.text.isEmpty
    
    self.viewModel.setReason(textView.text)
  }
}
