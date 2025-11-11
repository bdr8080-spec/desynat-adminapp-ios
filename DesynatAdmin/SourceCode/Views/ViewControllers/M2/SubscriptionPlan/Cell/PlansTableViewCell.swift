//
//  PlansTableViewCell.swift
//  DesynatAdmin
//
//  Created by Meet Goti on 10/11/25.
//

import UIKit

class PlansTableViewCell: ResuableTableCell {
    @IBOutlet weak var lblDuration: CustomLabelFont!
    
    @IBOutlet weak var stackFeature: UIStackView!
    @IBOutlet weak var viewMain: CustomView!
    @IBOutlet weak var viewPlanTitleBack: CustomView!
    @IBOutlet weak var lblPrice: CustomLabelFont!
    @IBOutlet weak var lblPlanName: CustomLabelFont!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setUpUi()
    }
    private func setUpUi() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
//            self.viewMain.borderRadiusWithCornerMask(radius: 12,cornerMask: [.layerMinXMaxYCorner,.layerMaxXMaxYCorner])
            self.viewPlanTitleBack.applyGradient(colours: [.init(hexString: "#5E5E5E"),.init(hexString: "#1A1A1A"),.init(hexString: "#1A1A1A")],gradientDirection: .leftToRight,cornerRadius: 16,corners: [.layerMinXMaxYCorner,.layerMaxXMaxYCorner])
        }
    }
    
    func setData(_ data:PlanInfo) {
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
    }
    
    func getView(_ title:NSAttributedString) -> SubscriptionFeatureInfoView {
        let view : SubscriptionFeatureInfoView = SubscriptionFeatureInfoView.fromNib()
        view.setTitle(title)
        return view
    }
    
}
