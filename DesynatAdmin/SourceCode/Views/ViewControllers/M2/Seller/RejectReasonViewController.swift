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
    
    // MARK: - IBOutlet's
    @IBOutlet weak var viewMain: CustomView!
    @IBOutlet weak var txtViewReason: IQTextView!
    @IBOutlet weak var btnCompleteProject: CustomButton!
    @IBOutlet weak var btnDocument: CustomButton!
    @IBOutlet weak var lblPlace: UILabel!
    @IBOutlet weak var buttonStackView: UIStackView!
    
    // MARK: - Property Decalaration
    private var viewModel : RejectReasonViewModel = RejectReasonViewModel()
    private(set) var callBack : ((String,SellerRejectionType) -> Void)?
    var needToShowButtonStackView: Bool = false
    
    // MARK: - View's LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpUi()
        buttonStackView.isHidden = !needToShowButtonStackView
    }
    
    // MARK: - Button's Action
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
    
    //MARK: Function's declaration
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
    
}
extension RejectReasonViewController : UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        self.lblPlace.isHidden = !textView.text.isEmpty
        
        self.viewModel.setReason(textView.text)
    }
}

