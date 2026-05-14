//
//  BrandDetailsViewController.swift
//  DesynatAdmin
//
//  Created by Rakhi Kumari on 31/10/25.
//

import UIKit

class BrandDetailsViewController: UIViewController {
    
    // MARK: - IBOutlet's
    @IBOutlet weak var statusImageView: UIImageView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var brandNameLabel: UILabel!
    @IBOutlet weak var brandImageView: CustomImageView!
    @IBOutlet weak var statusToggleButton: UIButton!
    @IBOutlet weak var buttonsStackView: UIStackView!
    
    // MARK: - Property Decalaration
    var brandData: GetBrandDataList?
    private lazy var viewModel = BrandDetailsViewModel(hostVC: self)
    var hasActionPermission: Bool = false
    
    // MARK: - View's LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        bindData()
        buttonsStackView.isHidden = !hasActionPermission
        statusToggleButton.isHidden = !hasActionPermission
    }
    
    // MARK: - Button's Action
    @IBAction func backDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func editDidTapped(_ sender: Any) {
        let vc = AddNewBrandViewController.instantiate(fromAppStoryboard: .SideMenu)
        vc.isComingForEdit = true
        vc.brandData = brandData
        vc.onBrandUpdated = { [weak self] updatedData in
            guard let self = self else { return }
            self.brandData = updatedData
            self.bindData()
        }
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    @IBAction func uploadImageDidTapped(_ sender: Any) {
    }
    
    @IBAction func statusDidTapped(_ sender: Any) {
        guard let brand = brandData else { return }
        viewModel.upadteBrandStatus(param: ["brand_id": brand.id ?? 0])
    }
    
    @IBAction func deleteDidTapped(_ sender: Any) {
        guard let brand = brandData else { return }
        self.showConfirmationAlert(msg: "Are you sure you want to delete this brand?".localiz()){ [weak self] in
            guard let self = self else { return }
            self.viewModel.deleteBrand(param: ["brand_id": brand.id ?? 0])
        }
    }
    
    //MARK: Function's declaration
    func bindData() {
        brandNameLabel.text = AppLanguageManager.shared.currentLanguage == .ar ? brandData?.nameArabic : brandData?.nameEnglish
        if let imageUrlString = brandData?.image,
           let url = URL(string: imageUrlString) {
            brandImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"))
        } else {
            brandImageView.image = UIImage(named: "placeholder")
        }
        
        if brandData?.status == 1 {
            statusLabel.text = "Active".localiz()
            statusImageView.image = UIImage(named: "toggleOn")
        } else {
            statusLabel.text = "Inactive".localiz()
            statusImageView.image = UIImage(named: "toggleOff")
        }
        
    }
}
