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
    
    // MARK: - Property Decalaration
    private var cmsArray: [CmsArray] = [.returnPolicy, .aboutUs, .cancellationPolicy, .exchangePolicy, .faqs, .contactUs]
    var isCMSListHidden: Bool = false
    var selectedUserType = 1
    private lazy var viewModel = CMSTermsConditionViewModel(hostVC: self)
    
    // MARK: - View's LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        englishContentWebView.scrollView.isScrollEnabled = false
        arabicContentWebView.scrollView.isScrollEnabled = false
        englishContentWebView.navigationDelegate = self
        arabicContentWebView.navigationDelegate = self
        viewModel.getTermsAndConditionRequest()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cmsOptionView.isHidden = true
        isCMSListHidden = false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        englishWebViewHeight.constant = englishContentWebView.scrollView.contentSize.height
        arabicWebViewHeight.constant = arabicContentWebView.scrollView.contentSize.height
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
        viewModel.getTermsAndConditionRequest()
    }
    
    @IBAction func sellerDidTapped(_ sender: Any) {
        userButton.setImage(UIImage(named: ""), for: .normal)
        userLabel.textColor = .black
        sellerButton.setImage(.btnGradient, for: .normal)
        sellerLabel.textColor = .white
        deliveryBoyLabel.textColor = .black
        deliveryBoyButton.setImage(UIImage(named: ""), for: .normal)
        selectedUserType = 2
        viewModel.getTermsAndConditionRequest()
    }
    
    @IBAction func deliveryboyDidTapped(_ sender: Any) {
        userButton.setImage(UIImage(named: ""), for: .normal)
        userLabel.textColor = .black
        sellerButton.setImage(UIImage(named: ""), for: .normal)
        sellerLabel.textColor = .black
        deliveryBoyLabel.textColor = .white
        deliveryBoyButton.setImage(.btnGradient, for: .normal)
        selectedUserType = 3
        viewModel.getTermsAndConditionRequest()
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
    
    //MARK: Function's declaration
    
}

//MARK: WKNavigation Delegate functions
extension CMSTermsConditionViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        webView.evaluateJavaScript("document.body.scrollHeight") { [weak self] height, _ in
            
            guard let self = self else { return }
            
            if let height = height as? CGFloat {
                
                let fixedHeight = height + 20
                
                if webView == self.englishContentWebView {
                    self.englishWebViewHeight.constant = fixedHeight
                } else {
                    self.arabicWebViewHeight.constant = fixedHeight
                }
            }
        }
    }
}

// MARK: - TABLE VIEW METHODS
extension CMSTermsConditionViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cmsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CMSTableViewCell", for: indexPath) as! CMSTableViewCell
        cell.titleLabel.text = cmsArray[indexPath.row].rawValue
        if indexPath.row == cmsArray.count - 1 {
            cell.separatorLabel.isHidden = true
        } else {
            cell.separatorLabel.isHidden = false
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cmsType = cmsArray[indexPath.row]
        switch cmsType {
        case .returnPolicy:
            let nextVC = CMSDetailsViewController.instantiate(fromAppStoryboard: .NotificationCMS)
            nextVC.selectedUserType = selectedUserType
            nextVC.cmsType = cmsType
            self.navigationController?.pushViewController(nextVC, animated: true)
        case .faqs:
            let nextVC = FAQViewController.instantiate(fromAppStoryboard: .NotificationCMS)
            nextVC.selectedUserType = selectedUserType
            self.navigationController?.pushViewController(nextVC, animated: true)
        case .contactUs:
            let nextVC = ContactUsViewController.instantiate(fromAppStoryboard: .NotificationCMS)
            nextVC.selectedUserType = selectedUserType
            self.navigationController?.pushViewController(nextVC, animated: true)
        default:
            let nextVC = CMSDetailsViewController.instantiate(fromAppStoryboard: .NotificationCMS)
            nextVC.selectedUserType = selectedUserType
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
    }
}

enum CmsArray: String {
    case returnPolicy = "Return Policy"
    case aboutUs = "About Us"
    case cancellationPolicy = "Cancellation Policy"
    case exchangePolicy = "Exchange Policy"
    case faqs = "FAQs"
    case contactUs = "Contact Us"
}
