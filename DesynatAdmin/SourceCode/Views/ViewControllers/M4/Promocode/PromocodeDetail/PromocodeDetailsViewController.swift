//
//  PromocodeDetailsViewController.swift
//  DesynatAdmin
//
//  Created by fluper on 09/12/25.
//

import UIKit

class PromocodeDetailsViewController: UIViewController {
    
    // MARK: - IBOutlet's
    @IBOutlet weak var percentageOffLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var statusToggleImageView: UIImageView!
    @IBOutlet weak var percentageOffDescriptionLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var termsAndConditionLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var applicableForLabel: UILabel!
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!
    @IBOutlet weak var statusToggleButton: UIButton!
    @IBOutlet weak var bottomstackView: UIStackView!
    
    // MARK: - Property Decalaration
    var promocodeDetails: PromocodeList?
    private lazy var viewModel = PromocodeDetailsViewModel(hostVC: self)
    var hasActionPermission: Bool = false
    
    // MARK: - View's LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configData()
        statusToggleButton.isUserInteractionEnabled = hasActionPermission
        bottomstackView.isHidden = !hasActionPermission
        bottomstackView.semanticContentAttribute = .forceLeftToRight
    }
    
    // MARK: - Button's Action
    @IBAction func backDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func deleteDidTapepd(_ sender: Any) {
        guard let gift = promocodeDetails else { return }
        self.showConfirmationAlert(msg: "Are you sure you want to delete this promocode?".localiz()){ [weak self] in
            guard let self = self else { return }
            self.viewModel.deletePromocode(param: ["promocode_id": gift.id ?? 0])
        }
    }
    
    @IBAction func editDidTapped(_ sender: Any) {
        let nextVC = AddPromocodeViewController.instantiate(fromAppStoryboard: .ShippingPromocode)
        nextVC.isComingForEdit = true
        nextVC.promocodeDetails = promocodeDetails
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @IBAction func toggleDidTapped(_ sender: Any) {
        guard let card = promocodeDetails else { return }
        viewModel.upadtePromocodeStatus(param: ["promocode_id": card.id ?? 0])
    }
    
    //MARK: Function's declaration
    func configData() {
        percentageOffLabel.text = "\("Flat".localiz()) \(promocodeDetails?.discountPercent ?? "")% \("OFF".localiz())" //promocodeDetails?.nameEnglish
        percentageOffDescriptionLabel.text = "\("Flat".localiz()) \(promocodeDetails?.discountPercent ?? "")% \("Off On minimum order".localiz()) \(promocodeDetails?.minOrderValue ?? "")"
        if AppLanguageManager.shared.currentLanguage == .en {
            descriptionLabel.text = promocodeDetails?.descriptionEnglish ?? ""
            termsAndConditionLabel.text = promocodeDetails?.descriptionEnglish ?? ""
        }else {
            descriptionLabel.text = promocodeDetails?.descriptionArabic ?? ""
            termsAndConditionLabel.text = promocodeDetails?.descriptionArabic ?? ""
        }
        if promocodeDetails?.status == 1 {
            statusLabel.text = "Active".localiz()
            statusToggleImageView.image = UIImage(named: "toggleOn")
        } else {
            statusLabel.text = "Inactive".localiz()
            statusToggleImageView.image = UIImage(named: "toggleOff")
        }
        if AppLanguageManager.shared.currentLanguage == .en {
            countryLabel.text = promocodeDetails?.countryInfo?.name
        }else {
            countryLabel.text = promocodeDetails?.countryInfo?.nameAr
        }
        let applicableFor = promocodeDetails?.applicableFor
        if applicableFor == 2 {
            applicableForLabel.text = "Every Order".localiz()
        } else {
            applicableForLabel.text = "First Order".localiz()
        }
        startDateLabel.text = convertDate(promocodeDetails?.startDate ?? "")
        endDateLabel.text = convertDate(promocodeDetails?.endDate ?? "")
    }
    
    func convertDate(_ input: String) -> String? {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
//        inputFormatter.locale = Locale(identifier: "en_US_POSIX")
        if AppLanguageManager.shared.currentLanguage == .ar {
            inputFormatter.locale = Locale(identifier: "ar")
           } else {
               inputFormatter.locale = Locale(identifier: "en_US")
           }
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "dd/MM/yyyy"
//        outputFormatter.locale = Locale(identifier: "en_US_POSIX")
        if AppLanguageManager.shared.currentLanguage == .ar {
            outputFormatter.locale = Locale(identifier: "ar")
           } else {
               outputFormatter.locale = Locale(identifier: "en_US")
           }
        if let date = inputFormatter.date(from: input) {
            return outputFormatter.string(from: date)
        }
        return nil
    }
    
}
