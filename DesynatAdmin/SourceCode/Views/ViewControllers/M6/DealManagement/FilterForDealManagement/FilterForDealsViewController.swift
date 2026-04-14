//
//  FilterForDealsViewController.swift
//  DesynatAdmin
//
//  Created by fluper on 07/01/26.
//

import UIKit
import DropDown

class FilterForDealsViewController: UIViewController {
    
    // MARK: - IBOutlet's
    @IBOutlet weak var titleLabel: CustomLabelFont!
    @IBOutlet weak var headerView: UIView!
    
    // MARK: - Property Decalaration
    private var brandList: [GetBrandDataList] = []
    var selectedFilter = ProductFilterModelOnBrand()
    var onApplyFilter: ((ProductFilterModelOnBrand) -> Void)?
    var onClearFilter: (() -> Void)?
    var sleectedBrand: String? = ""
    
    // MARK: - View's LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        handleUISetup()
        getAllBrands()
        if let brandName = selectedFilter.brandName {
            titleLabel.text = brandName
        }
    }
    
    // MARK: - Button's Action
    @IBAction func dismissDidTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func brandDidTapped(_ sender: UIButton) {
        let brandListName = brandList.map { brands -> String in
            let name = brands.nameEnglish ?? ""
            return name
        }
        
        // Create a DropDown object
        let dropDown = DropDown()
        dropDown.dataSource = brandListName
        
        // Use the view controller's view as anchor
        dropDown.anchorView = self.view // This centers it on the screen
        dropDown.direction = .any
        dropDown.bottomOffset = CGPoint(x: 50, y: (self.view.frame.height / 2) - 50) // adjust to roughly center vertically
        dropDown.width = 250 // optional, adjust width
        dropDown.selectionAction = { index, item in
            let selectedCountry = self.brandList[index]
            self.sleectedBrand = selectedCountry.nameEnglish
            self.titleLabel.text = selectedCountry.nameEnglish
        }
        // Show the dropdown
        dropDown.show()
    }
    
    @IBAction func submitdidTapped(_ sender: Any) {
        var filter = ProductFilterModelOnBrand()
        
        if let brand = sleectedBrand, !brand.isEmpty {
            filter.brandName = brand
        }
        
        onApplyFilter?(filter)
        dismiss(animated: true)
    }
    
    @IBAction func clearDidTapped(_ sender: Any) {
        sleectedBrand = nil
        titleLabel.text = "Select Brand"
        onClearFilter?()
        dismiss(animated: true)
    }
    
    //MARK: Function's declaration
    private func handleUISetup() {
        headerView.layer.cornerRadius = 24
        headerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        headerView.clipsToBounds = true
    }
    
    func getAllBrands() {
        WebService.shared.getAllBrandsListForFilter() { [weak self] response in
            guard let self = self else { return }
            self.brandList = response.data ?? []
        }
    }
    
}

struct DealFilterModel {
    var brandId: Int?
    var brandName: String?
}
