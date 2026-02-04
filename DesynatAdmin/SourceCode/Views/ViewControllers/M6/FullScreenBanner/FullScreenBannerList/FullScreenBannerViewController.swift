//
//  FullScreenBannerViewController.swift
//  DesynatAdmin
//
//  Created by fluper on 08/01/26.
//

import UIKit

class FullScreenBannerViewController: UIViewController {
    
    @IBOutlet weak var fullscreenButton: CustomButton!
    @IBOutlet weak var fullscreenLabel: UILabel!
    @IBOutlet weak var promotionalLabel: UILabel!
    @IBOutlet weak var promotionalButon: CustomButton!
    @IBOutlet weak var noDataFoundLabel: UILabel!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var pageCountLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var bannerTableView: UITableView! {
        didSet {
            bannerTableView.registerCellFromNib(cellID: "FullScreenBannerTableViewCell")
        }
    }
    
    private lazy var viewModel = FullScreenBannerViewModel(hostVC: self)
    private var searchWorkItem: DispatchWorkItem?
    var bannerType: BannerMangementType = .fullScreen
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTextField.delegate = self
        updatePaginationButtonImages()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.currentPage = 1
        switch bannerType {
        case .fullScreen:
            viewModel.getAllFullScreenBanners()
        case .promotional:
            viewModel.getPromotionalBanners()
        }
    }
    
    @IBAction func backDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func plusDidTapped(_ sender: Any) {
        switch bannerType {
        case .fullScreen:
            let vc = AddAdvertisementViewController.instantiate(fromAppStoryboard: .AffiliatedBannerOrder)
            vc.isComingForEdit = false
            self.navigationController?.pushViewController(vc, animated: false)
        case .promotional:
            let nextVC = AddPromotionalBannerViewController.instantiate(fromAppStoryboard: .AffiliatedBannerOrder)
            nextVC.isComingForEdit = false
            self.navigationController?.pushViewController(nextVC, animated: false)
        }
        
    }
    
    @IBAction func nextButtonAction(_ sender: Any) {
        viewModel.goToNextPage()
    }
    
    @IBAction func previousButtonAction(_ sender: Any) {
        viewModel.goToPreviousPage()
    }
    
    @IBAction func filterDidTapped(_ sender: Any) {
        let vc = FullScreenBannerFilterViewController.instantiate(fromAppStoryboard: .AffiliatedBannerOrder)
        vc.selectedFilter = viewModel.appliedFilter
        vc.bannerType = bannerType
        vc.onApplyFilter = { [weak self] filter in
            guard let self else { return }
            self.viewModel.appliedFilter = filter
            self.viewModel.currentPage = 1
            if self.bannerType == .fullScreen {
                self.viewModel.getAllFullScreenBanners()
            } else {
                self.viewModel.getPromotionalBanners()
            }
        }
        
        vc.onClearFilter = { [weak self] in
            guard let self else { return }
            self.viewModel.appliedFilter = FullScreenBannerFilterModel()
            self.viewModel.currentPage = 1
            if self.bannerType == .fullScreen {
                self.viewModel.getAllFullScreenBanners()
            } else {
                self.viewModel.getPromotionalBanners()
            }
        }
        present(vc, animated: true)
    }
    
    @IBAction func fullScreenBannerDidTapped(_ sender: Any) {
        fullscreenButton.setImage(UIImage(named: "btnGradient"), for: .normal)
        fullscreenLabel.textColor = UIColor.white
        promotionalButon.setImage(UIImage(named: ""), for: .normal)
        promotionalLabel.textColor = UIColor.black
        bannerType = .fullScreen
        viewModel.currentPage = 1
        viewModel.getAllFullScreenBanners()
    }
    
    @IBAction func promotionalDidTapped(_ sender: Any) {
        promotionalButon.setImage(UIImage(named: "btnGradient"), for: .normal)
        promotionalLabel.textColor = UIColor.white
        fullscreenButton.setImage(UIImage(named: ""), for: .normal)
        fullscreenLabel.textColor = UIColor.black
        bannerType = .promotional
        viewModel.currentPage = 1
        viewModel.getPromotionalBanners()
    }
    
    func updatePaginationButtonImages() {
        // Previous Button
        if viewModel.currentPage == 1 {
            previousButton.setImage(UIImage(named: "previousLeft"), for: .normal)
            previousButton.isUserInteractionEnabled = false
        } else {
            previousButton.setImage(UIImage(named: "darkpreviousimage"), for: .normal)
            previousButton.isUserInteractionEnabled = true
        }
        
        // Next Button
        if viewModel.currentPage >= viewModel.totalPages {
            nextButton.setImage(UIImage(named: "lightnextimage"), for: .normal)
            nextButton.isUserInteractionEnabled = false
        } else {
            nextButton.setImage(UIImage(named: "nextRight"), for: .normal)
            nextButton.isUserInteractionEnabled = true
        }
    }
    
}

extension FullScreenBannerViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.brandListData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FullScreenBannerTableViewCell", for: indexPath) as! FullScreenBannerTableViewCell
        let data = viewModel.brandListData[indexPath.row]
        switch bannerType {
        case .fullScreen:
            cell.configData(data: data)
        case .promotional:
            cell.configDataForPromotionalBanner(data: data)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch bannerType {
        case .fullScreen:
            let vc = FullScreenBanerDetailsViewController.instantiate(fromAppStoryboard: .AffiliatedBannerOrder)
            vc.bannerId = viewModel.brandListData[indexPath.row].id ?? 0
            vc.bannerType = bannerType
            self.navigationController?.pushViewController(vc, animated: false)
        case .promotional:
            let vc = FullScreenBanerDetailsViewController.instantiate(fromAppStoryboard: .AffiliatedBannerOrder)
            vc.bannerId = viewModel.promotionalListData[indexPath.row].id ?? 0
            self.navigationController?.pushViewController(vc, animated: false)
        }
    }
    
}

extension FullScreenBannerViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
        
        // Cancel previous search work item
        searchWorkItem?.cancel()
        
        // Create new one
        let workItem = DispatchWorkItem { [weak self] in
            guard let self = self else { return }
            self.viewModel.searchText = currentText
            self.viewModel.currentPage = 1
            if bannerType == .fullScreen {
                self.viewModel.getAllFullScreenBanners()
            } else {
                self.viewModel.getPromotionalBanners()
            }
        }
        
        // Store and execute after delay
        searchWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: workItem)
        
        return true
    }
}

enum BannerMangementType {
    case fullScreen
    case promotional
}
