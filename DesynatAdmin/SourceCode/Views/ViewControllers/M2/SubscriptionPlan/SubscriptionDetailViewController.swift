//
//  SubscriptionDetailViewController.swift
//  DesynatAdmin
//
//  Created by Meet Goti on 10/11/25.
//

import UIKit

class SubscriptionDetailViewController: UIViewController {
    @IBOutlet weak var lblDuration: CustomLabelFont!
    
    @IBOutlet weak var btnSwitch: CustomButton!
    @IBOutlet weak var btnActive: CustomButton!
    @IBOutlet weak var stackFeature: UIStackView!
    @IBOutlet weak var viewMain: CustomView!
    @IBOutlet weak var viewPlanTitleBack: CustomView!
    @IBOutlet weak var lblPrice: CustomLabelFont!
    @IBOutlet weak var lblPlanName: CustomLabelFont!
    private var viewModel : SubscriptionDetailViewModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewMain.isHidden = true
        self.setUpUi()
    }
    
    func setVM(_ vm:SubscriptionDetailViewModel)  {
        self.viewModel = vm
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.setData()
    }
    private func setUpUi() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.viewPlanTitleBack.applyGradient(colours: [.init(hexString: "#5E5E5E"),.init(hexString: "#1A1A1A"),.init(hexString: "#1A1A1A")],gradientDirection: .leftToRight,cornerRadius: 16,corners: [.layerMinXMaxYCorner,.layerMaxXMaxYCorner])
        }
    }
    
    func setData() {
        self.viewModel?.getDetail {
            self.viewMain.isHidden = false
            if let data = self.viewModel?.data {
                self.lblPlanName.text = data.planNameEnglish
                self.lblPrice.text = "KD \(data.price.clean)"
                self.lblDuration.text = "for \(data.duration.clean) \(data.durationType.title)"
                self.stackFeature.arrangedSubviews.forEach({$0.removeFromSuperview()})
                
                if (data.noOfVideos > 0) {
                    self.stackFeature.addArrangedSubview(self.getView("Number of Videos (Reels): \(data.noOfVideos)".makeAttributedString(attribute: [.font:UIFont(name: "Poppins-SemiBold", size: 14) ?? .systemFont(ofSize: 12,weight: .semibold)], for: "\(data.noOfVideos)")))
                }
                if (data.noOfProducts > 0) {
                    self.stackFeature.addArrangedSubview(self.getView("Number of Products: \(data.noOfProducts)".makeAttributedString(attribute: [.font:UIFont(name: "Poppins-SemiBold", size: 14) ?? .systemFont(ofSize: 12,weight: .semibold)], for: "\(data.noOfProducts)")))
                }
                if (data.noOfHighlights > 0) {
                    self.stackFeature.addArrangedSubview(self.getView("Number of Highlights: \(data.noOfHighlights)".makeAttributedString(attribute: [.font:UIFont(name: "Poppins-SemiBold", size: 14) ?? .systemFont(ofSize: 12,weight: .semibold)], for: "\(data.noOfHighlights)")))
                }
                if (data.isStoryOpen) {
                    let storyStatus = data.isStoryOpen ? "Open" : "Close"
                    self.stackFeature.addArrangedSubview(self.getView("Stories: \(storyStatus)".makeAttributedString(attribute: [.font:UIFont(name: "Poppins-SemiBold", size: 14) ?? .systemFont(ofSize: 12,weight: .semibold)], for: "\(storyStatus)")))
                }
                if (data.noOfEmployee > 0) {
                    self.stackFeature.addArrangedSubview(self.getView("\(data.noOfEmployee) Store Employees ".makeAttributedString(attribute: [.font:UIFont(name: "Poppins-SemiBold", size: 14) ?? .systemFont(ofSize: 12,weight: .semibold)], for: "")))
                }
                if (data.comission > 0) {
                    self.stackFeature.addArrangedSubview(self.getView("Commission: \(data.comission.clean)%".makeAttributedString(attribute: [.font:UIFont(name: "Poppins-SemiBold", size: 14) ?? .systemFont(ofSize: 12,weight: .semibold)], for: "\(data.comission.clean)")))
                }
                self.refreshStatus()
            }
        }
    }
    func refreshStatus() {
        let isActive = self.viewModel?.data.isActive ?? false
        self.btnActive.setTitle(isActive ? "Active" : "InActive", for: .normal)
        self.btnActive.setTitleColor(.init(hexString: isActive ? "#1A900D" : "#6E4527"), for: .normal)
        self.btnSwitch.setImage(isActive ? .toggleOn : .toggleOff, for: .normal)
    }
    @IBAction func handleSwitch(_ sender: Any) {
        self.viewModel?.setActive(!(self.viewModel?.data.isActive ?? false)) {
            self.refreshStatus()
        }
    }
    
    @IBAction func handleBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func handleDelete(_ sender: Any) {
        self.showConfirmationAlert(msg: "Are you sure you want\nto delete the plan?") {
            self.viewModel?.deletePlan {
                let vc = RegisterationSuccessViewController.instantiate(fromAppStoryboard: .Main)
                vc.setTitle("Subscription plan deleted\nsuccessfully!")
                vc.callBackDismiss = {
                    self.navigationController?.popViewController(animated: true)
                }
                self.presentVC(vc,modalPresentationStyle: .overCurrentContext)
            }
        }
    }
    
    @IBAction func handleEdit(_ sender: Any) {
        let vc = AddPlanViewController.viewFromNIB
        if let data = self.viewModel?.data {
            vc.setIntial(data)
        }
        self.navigate(to: vc)
    }
    
    func getView(_ title:NSAttributedString) -> SubscriptionFeatureInfoView {
        let view : SubscriptionFeatureInfoView = SubscriptionFeatureInfoView.fromNib()
        view.setTitle(title)
        return view
    }
}
