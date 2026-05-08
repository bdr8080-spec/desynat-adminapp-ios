//
//  GiftCardDetailsViewController.swift
//  DesynatAdmin
//
//  Created by fluper on 09/12/25.
//

import UIKit

class GiftCardDetailsViewController: UIViewController {
    
    // MARK: - IBOutlet's
    @IBOutlet weak var statusImageView: UIImageView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var cardNameLabel: UILabel!
    @IBOutlet weak var cardImageView: CustomImageView!
    @IBOutlet weak var btnstatus: UIButton!
    @IBOutlet weak var bottomstackView: UIStackView!
    
    // MARK: - Property Decalaration
    var giftsListData: GiftCardsList?
    private lazy var viewModel = GiftCardDetailsViewModel(hostVC: self)
    var hasActionPermission: Bool = false
    
    // MARK: - View's LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        bindData()
        btnstatus.isUserInteractionEnabled = hasActionPermission
        bottomstackView.isHidden = !hasActionPermission
    }
    
    // MARK: - Button's Action
    @IBAction func backDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func editDidTapped(_ sender: Any) {
        let vc = AddNewCardViewController.instantiate(fromAppStoryboard: .ShippingPromocode)
        vc.isComingForEdit = true
        vc.giftsListData = giftsListData
        vc.onCardUpdated = { [weak self] updatedData in
            guard let self = self else { return }
            self.giftsListData = updatedData
            self.bindData()
        }
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    @IBAction func statusDidTapped(_ sender: Any) {
        guard let card = giftsListData else { return }
        viewModel.upadteCardStatus(param: ["giftCard_id": card.id ?? 0])
    }
    
    @IBAction func deleteDidTapped(_ sender: Any) {
        guard let gift = giftsListData else { return }
        self.showConfirmationAlert(msg: "Are you sure you want to delete this gift card category?".localiz()){ [weak self] in
            guard let self = self else { return }
            self.viewModel.deleteCard(param: ["giftCard_id": gift.id ?? 0])
        }
    }
    
    //MARK: Function's declaration
    func bindData() {
        if AppLanguageManager.shared.currentLanguage == .en {
            cardNameLabel.text = giftsListData?.nameEnglish
        }else {
            cardNameLabel.text = giftsListData?.nameArabic
        }
        if let imageUrlString = giftsListData?.image,
           let url = URL(string: imageUrlString) {
            cardImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"))
        } else {
            cardImageView.image = UIImage(named: "placeholder")
        }
        
        if giftsListData?.status == 1 {
            statusLabel.text = "Active".localiz()
            statusImageView.image = UIImage(named: "toggleOn")
        } else {
            statusLabel.text = "Inactive".localiz()
            statusImageView.image = UIImage(named: "toggleOff")
        }
        
    }
}
