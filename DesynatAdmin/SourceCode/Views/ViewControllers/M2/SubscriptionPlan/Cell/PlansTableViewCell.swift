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

    private var gradientIndex: Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //self.setUpUi()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let index = gradientIndex {
            applyGradientForIndex(index)
        }
    }

    private func setUpUi() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.viewPlanTitleBack.applyGradient(colours: [.init(hexString: "#5E5E5E"),.init(hexString: "#1A1A1A"),.init(hexString: "#1A1A1A")],gradientDirection: .leftToRight,cornerRadius: 16,corners: [.layerMinXMaxYCorner,.layerMaxXMaxYCorner])
        }
    }
    
    func applyGradientForIndex(_ index: Int) {
        self.gradientIndex = index // keep it for layout pass
        
        let gradients: [[UIColor]] = [
            [UIColor(hexString: "#DFBF8F"), UIColor(hexString: "#6E4527")],
            [UIColor(hexString: "#2E8B57"), UIColor(hexString: "#006400")],
            [UIColor(hexString: "#1E90FF"), UIColor(hexString: "#00008B")],
            [UIColor(hexString: "#FF6347"), UIColor(hexString: "#8B0000")],
            [UIColor(hexString: "#8A2BE2"), UIColor(hexString: "#4B0082")],
            [UIColor(hexString: "#FF69B4"), UIColor(hexString: "#C71585")],
            [UIColor(hexString: "#FFD700"), UIColor(hexString: "#FFA500")]
        ]
        
        let colorSet = gradients[index % gradients.count]
        
        DispatchQueue.main.async {
            self.viewPlanTitleBack.layer.sublayers?.removeAll(where: { $0 is CAGradientLayer })
            self.viewPlanTitleBack.applyGradient(
                colours: colorSet,
                gradientDirection: .leftToRight,
                cornerRadius: 16,
                corners: [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            )
        }
    }

    
    func setData(_ data:PlanInfo) {
        self.lblPlanName.text = data.planNameEnglish
        self.lblPrice.text = "KD \(data.price.clean)"
        self.lblDuration.text = "for \(data.duration.clean) \(data.durationType.title)"
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
    }
    
    func getView(_ title:NSAttributedString) -> SubscriptionFeatureInfoView {
        let view : SubscriptionFeatureInfoView = SubscriptionFeatureInfoView.fromNib()
        view.setTitle(title)
        return view
    }
    
}
