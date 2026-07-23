//
//  SubscriptionDetailViewController.swift
//  DesynatAdmin
//
//  Created by Meet Goti on 10/11/25.
//

import UIKit

class SubscriptionDetailViewController: UIViewController {
    
    // MARK: - IBOutlet's
    @IBOutlet weak var lblDuration: CustomLabelFont!
    @IBOutlet weak var btnSwitch: CustomButton!
    @IBOutlet weak var btnActive: CustomButton!
    @IBOutlet weak var stackFeature: UIStackView!
    @IBOutlet weak var viewMain: CustomView!
    @IBOutlet weak var viewPlanTitleBack: CustomView!
    @IBOutlet weak var lblPrice: CustomLabelFont!
    @IBOutlet weak var lblPlanName: CustomLabelFont!
    @IBOutlet weak var bottomStackView: UIView!
    
    // MARK: - Property Decalaration
    private var viewModel : SubscriptionDetailViewModel?
    var hasActionPermission: Bool = false
    
    // MARK: - View's LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewMain.isHidden = true
        self.setUpUi()
        btnSwitch.isUserInteractionEnabled = hasActionPermission
        bottomStackView.isHidden = !hasActionPermission
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.setData()
    }
    
    // MARK: - Button's Action
    @IBAction func handleSwitch(_ sender: Any) {
        self.viewModel?.setActive(!(self.viewModel?.data.isActive ?? false)) {
            self.refreshStatus()
        }
    }
    
    @IBAction func handleBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func handleDelete(_ sender: Any) {
        self.showConfirmationAlert(msg: "Are you sure you want\nto delete the plan?".localiz()) {
            self.viewModel?.deletePlan {
                let vc = RegisterationSuccessViewController.instantiate(fromAppStoryboard: .Main)
                vc.setTitle("Subscription plan deleted\nsuccessfully!".localiz())
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
    
    //MARK: Function's declaration
    func setVM(_ vm:SubscriptionDetailViewModel)  {
        self.viewModel = vm
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
                self.lblDuration.text = "\("for".localiz()) \(data.duration.clean) \(data.durationType.title)"
                self.stackFeature.arrangedSubviews.forEach({$0.removeFromSuperview()})
                let productText = data.productType ? "\(data.noOfProducts)" : "Unlimited".localiz()
                self.stackFeature.addArrangedSubview(
                    self.getView("\("Number of Products:".localiz()) \(productText)".makeAttributedString(
                            attribute: [
                                .font: UIFont(name: "Poppins-SemiBold", size: 14) ?? .systemFont(ofSize: 12, weight: .semibold)
                            ],
                            for: productText
                        )
                    )
                )
                if (data.noOfVideos > 0) {
                    self.stackFeature.addArrangedSubview(self.getView("\("Number of Videos (Reels):".localiz()) \(data.noOfVideos)".makeAttributedString(attribute: [.font:UIFont(name: "Poppins-SemiBold", size: 14) ?? .systemFont(ofSize: 12,weight: .semibold)], for: "\(data.noOfVideos)")))
                }
                
                if (data.noOfHighlights > 0) {
                    self.stackFeature.addArrangedSubview(self.getView("\("Number of Highlights:".localiz()) \(data.noOfHighlights)".makeAttributedString(attribute: [.font:UIFont(name: "Poppins-SemiBold", size: 14) ?? .systemFont(ofSize: 12,weight: .semibold)], for: "\(data.noOfHighlights)")))
                }

                let statusText = data.stories == 1 ? "Open".localiz() : "Close".localiz()
                self.stackFeature.addArrangedSubview(
                    self.getView("\("Stories:".localiz()) \(statusText)".makeAttributedString(
                            attribute: [
                                .font: UIFont(name: "Poppins-SemiBold", size: 14) ?? .systemFont(ofSize: 12, weight: .semibold)
                            ],
                            for: statusText
                        )
                    )
                )

                
                if (data.noOfEmployee > 0) {
                    self.stackFeature.addArrangedSubview(self.getView("\(data.noOfEmployee) \("Store Employees".localiz()) ".makeAttributedString(attribute: [.font:UIFont(name: "Poppins-SemiBold", size: 14) ?? .systemFont(ofSize: 12,weight: .semibold)], for: "")))
                }

                let commissionText: String

                if data.comission > 0 {
                    commissionText = "\(data.comission.clean)%"
                } else {
                    commissionText = "No".localiz()
                }

                self.stackFeature.addArrangedSubview(
                    self.getView("\("Commission:".localiz()) \(commissionText)".makeAttributedString(
                            attribute: [
                                .font: UIFont(name: "Poppins-SemiBold", size: 14) ?? .systemFont(ofSize: 12, weight: .semibold)
                            ],
                            for: commissionText
                        )
                    )
                )
                if (data.isFreeMonths) {
                    self.stackFeature.addArrangedSubview(self.getView("\("Number of Free Month:".localiz()) \(data.noOfFreeMonths)".makeAttributedString(attribute: [.font:UIFont(name: "Poppins-SemiBold", size: 14) ?? .systemFont(ofSize: 12,weight: .semibold)], for: "\(data.noOfFreeMonths)")))
                }
                let recommendedStoreText = data.showInRecommendedStore == true ? "Yes".localiz() : "No".localiz()
                self.stackFeature.addArrangedSubview(
                    self.getView(
                        "\("Show in Suggested Stores:".localiz()) \(recommendedStoreText)"
                            .makeAttributedString(
                                attribute: [
                                    .font: UIFont(name: "Poppins-SemiBold", size: 14) ?? .systemFont(ofSize: 12, weight: .semibold)
                                ],
                                for: recommendedStoreText
                            )
                    )
                )
                self.refreshStatus()
            }
        }
    }
    func refreshStatus() {
        let isActive = self.viewModel?.data.isActive ?? false
        self.btnActive.setTitle(isActive ? "Active".localiz() : "Inactive".localiz(), for: .normal)
        self.btnActive.setTitleColor(.init(hexString: isActive ? "#1A900D" : "#6E4527"), for: .normal)
        self.btnSwitch.setImage(isActive ? .toggleOn : .toggleOff, for: .normal)
    }
    
    func getView(_ title:NSAttributedString) -> SubscriptionFeatureInfoView {
        let view : SubscriptionFeatureInfoView = SubscriptionFeatureInfoView.fromNib()
        view.setTitle(title)
        return view
    }
}
