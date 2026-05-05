//
//  CMSTermsConditionViewController.swift
//  DesynatAdmin
//
//  Created by fluper_mac3 on 13/03/26.
//

import UIKit
import WebKit

class CMSTermsConditionViewController: UIViewController {
    
    // MARK: - IBOutlet's
    @IBOutlet weak var englishContentWebView: WKWebView!
    @IBOutlet weak var arabicContentWebView: WKWebView!
    @IBOutlet weak var englishWebViewHeight: NSLayoutConstraint!
    @IBOutlet weak var arabicWebViewHeight: NSLayoutConstraint!
    @IBOutlet weak var cmsOptionView: CustomView!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var sellerLabel: UILabel!
    @IBOutlet weak var deliveryBoyLabel: UILabel!
    @IBOutlet weak var deliveryBoyButton: CustomButton!
    @IBOutlet weak var sellerButton: CustomButton!
    @IBOutlet weak var userButton: CustomButton!
    @IBOutlet weak var cmsTableView: UITableView! {
        didSet {
            cmsTableView.registerCellFromNib(cellID: "CMSTableViewCell")
        }
    }
    @IBOutlet weak var cmsTF: BindableTextField!
    @IBOutlet weak var englishEditButton: UIButton!
    @IBOutlet weak var araicEditButton: UIButton!
    
    // MARK: - Property Decalaration
    private var cmsArray: [CmsArray] = [.termsAndCondition, .returnPolicy, .aboutUs, .cancellationPolicy, .exchangePolicy, .faqs, .contactUs]
    var isCMSListHidden: Bool = false
    var selectedUserType = 1
    private lazy var viewModel = CMSTermsConditionViewModel(hostVC: self)
    private var selectedCms: CmsArray = .termsAndCondition {
        didSet {
            cmsTF.text = selectedCms.rawValue
            cmsTableView.reloadData()
        }
    }
    private var filteredCmsArray: [CmsArray] {
        return cmsArray.filter { $0 != selectedCms }
    }
    var hasActionPermission: Bool = false
    
    // MARK: - View's LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        userLabel.text = "User".localiz()
        englishContentWebView.scrollView.isScrollEnabled = false
        arabicContentWebView.scrollView.isScrollEnabled = false
        englishContentWebView.navigationDelegate = self
        arabicContentWebView.navigationDelegate = self
        selectedCms = .termsAndCondition
        viewModel.getTermsAndConditionRequest()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleOutsideTap))
        tapGesture.cancelsTouchesInView = false
        tapGesture.delegate = self
        self.view.addGestureRecognizer(tapGesture)
        englishEditButton.isHidden = !hasActionPermission
        araicEditButton.isHidden = !hasActionPermission
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        selectedCms = .termsAndCondition
        cmsOptionView.isHidden = true
        isCMSListHidden = false
    }
    
    // MARK: - Button's Action
    @IBAction func userDidTapped(_ sender: Any) {
        userButton.setImage(.btnGradient, for: .normal)
        userLabel.textColor = .white
        sellerButton.setImage(UIImage(named: ""), for: .normal)
        sellerLabel.textColor = .black
        deliveryBoyLabel.textColor = .black
        deliveryBoyButton.setImage(UIImage(named: ""), for: .normal)
        selectedUserType = 1
        callCMSApi()
    }
    
    @IBAction func sellerDidTapped(_ sender: Any) {
        userButton.setImage(UIImage(named: ""), for: .normal)
        userLabel.textColor = .black
        sellerButton.setImage(.btnGradient, for: .normal)
        sellerLabel.textColor = .white
        deliveryBoyLabel.textColor = .black
        deliveryBoyButton.setImage(UIImage(named: ""), for: .normal)
        selectedUserType = 2
        callCMSApi()
    }
    
    @IBAction func deliveryboyDidTapped(_ sender: Any) {
        userButton.setImage(UIImage(named: ""), for: .normal)
        userLabel.textColor = .black
        sellerButton.setImage(UIImage(named: ""), for: .normal)
        sellerLabel.textColor = .black
        deliveryBoyLabel.textColor = .white
        deliveryBoyButton.setImage(.btnGradient, for: .normal)
        selectedUserType = 3
        callCMSApi()
    }
    
    @IBAction func TermsAndCondition(_ sender: Any) {
        if isCMSListHidden {
            cmsOptionView.isHidden = true
        } else {
            cmsOptionView.isHidden = false
        }
        isCMSListHidden = !isCMSListHidden
    }
    
    @IBAction func backDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func englishEditDidTapped(_ sender: Any) {
        let nextVC = EditCMSReasonViewController.instantiate(fromAppStoryboard: .NotificationCMS)
        nextVC.selectedUserType = self.selectedUserType
        nextVC.comingForArabic = false
        nextVC.cmsType = self.selectedCms
        nextVC.changesAreDone = { [weak self] in
            self?.callCMSApi()
        }
        nextVC.termsAndConditonData = viewModel.termsAndConditonData
        self.navigationController?.present(nextVC, animated: true)
    }
    
    @IBAction func arabicEditDidTapped(_ sender: Any) {
        let nextVC = EditCMSReasonViewController.instantiate(fromAppStoryboard: .NotificationCMS)
        nextVC.selectedUserType = self.selectedUserType
        nextVC.comingForArabic = true
        nextVC.cmsType = self.selectedCms
        nextVC.changesAreDone = { [weak self] in
            self?.callCMSApi()
        }
        nextVC.termsAndConditonData = viewModel.termsAndConditonData
        self.navigationController?.present(nextVC, animated: true)
    }
    
    @IBAction func englishDidTapped(_ sender: Any) {
        let nextVC = CMSDetailsViewController.instantiate(fromAppStoryboard: .NotificationCMS)
        nextVC.selectedUserType = self.selectedUserType
        nextVC.comingForArabic = false
        nextVC.cmsType = self.selectedCms
        nextVC.termsAndConditonData = viewModel.termsAndConditonData
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @IBAction func arbicReadMoreDidTapped(_ sender: Any) {
        let nextVC = CMSDetailsViewController.instantiate(fromAppStoryboard: .NotificationCMS)
        nextVC.selectedUserType = self.selectedUserType
        nextVC.comingForArabic = true
        nextVC.cmsType = self.selectedCms
        nextVC.termsAndConditonData = viewModel.termsAndConditonData
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    //MARK: Function's declaration
    private func callCMSApi() {
        switch selectedCms {
        case .termsAndCondition:
            viewModel.getTermsAndConditionRequest()
        case .returnPolicy:
            viewModel.getReturnPolicyRequest()
        case .aboutUs:
            viewModel.getAboutUsRequest()
        case .cancellationPolicy:
            viewModel.getCancellationPolicyRequest()
        case .exchangePolicy:
            viewModel.getExchangePolicyRequest()
        default:
            viewModel.getTermsAndConditionRequest() // fallback
        }
    }
}

//MARK: WKNavigation Delegate functions
extension CMSTermsConditionViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            webView.evaluateJavaScript("document.body.scrollHeight") { [weak self] height, _ in
                guard let self = self else { return }
                
                if let height = height as? CGFloat {
                    let fixedHeight = height + 20
                    
                    if webView == self.englishContentWebView {
                        self.englishWebViewHeight.constant = 120
                    } else {
                        self.arabicWebViewHeight.constant = 120 //fixedHeight
                    }
                    
                    // 🔥 IMPORTANT: Force layout update
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
    
}

// MARK: - TABLE VIEW METHODS
extension CMSTermsConditionViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCmsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CMSTableViewCell", for: indexPath) as! CMSTableViewCell
        
        let item = filteredCmsArray[indexPath.row]
        cell.titleLabel.text = item.rawValue.localiz()
        cell.separatorLabel.isHidden = indexPath.row == filteredCmsArray.count - 1
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = filteredCmsArray[indexPath.row]
        selectedCms = selectedItem
        cmsOptionView.isHidden = true
        isCMSListHidden = false
        switch selectedItem {
        case .returnPolicy:
            viewModel.getReturnPolicyRequest()
        case .aboutUs:
            viewModel.getAboutUsRequest()
        case .cancellationPolicy:
            viewModel.getCancellationPolicyRequest()
        case .exchangePolicy:
            viewModel.getExchangePolicyRequest()
        case .termsAndCondition:
            viewModel.getTermsAndConditionRequest()
        case .faqs:
            let nextVC = FAQViewController.instantiate(fromAppStoryboard: .NotificationCMS)
            nextVC.selectedUserType = selectedUserType
            nextVC.hasActionPermission = hasActionPermission
            navigationController?.pushViewController(nextVC, animated: true)
        case .contactUs:
            let nextVC = ContactUsViewController.instantiate(fromAppStoryboard: .NotificationCMS)
            nextVC.hasActionPermission = hasActionPermission
            nextVC.selectedUserType = selectedUserType
            navigationController?.pushViewController(nextVC, animated: true)
        }
    }
}

extension CMSTermsConditionViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        
        let touchView = touch.view
        
        // If tapping inside dropdown → ignore
        if let view = touchView, view.isDescendant(of: cmsOptionView) {
            return false
        }
        
        // If tapping inside tableView → ignore (so selection works)
        if let view = touchView, view.isDescendant(of: cmsTableView) {
            return false
        }
        
        // Allow tap everywhere else (including webview)
        return true
    }
    
    @objc private func handleOutsideTap() {
        cmsOptionView.isHidden = true
        isCMSListHidden = false
    }
}

enum CmsArray: String {
    case termsAndCondition = "Terms & Condition"
    case returnPolicy = "Return Policy"
    case aboutUs = "About Us"
    case cancellationPolicy = "Cancellation Policy"
    case exchangePolicy = "Exchange Policy"
    case faqs = "FAQs"
    case contactUs = "Contact Us"
}
