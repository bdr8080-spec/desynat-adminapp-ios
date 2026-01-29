//
//  EnrollDealDetailsViewController.swift
//  DesynatAdmin
//
//  Created by fluper on 07/01/26.
//

import UIKit

class EnrollDealDetailsViewController: UIViewController {
    
    @IBOutlet weak var totalRevenueView: CustomView!
    @IBOutlet weak var noDataFoundLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var searchTF: BindableTextField!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var productsoldabel: UILabel!
    @IBOutlet weak var addedProductsLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var pagecountLabel: UILabel!
    @IBOutlet weak var productCollectionView: UICollectionView! {
        didSet {
            productCollectionView.registerCellFromNib(cellID: "DealDetailsCollectionViewCell")
        }
    }
    var type: Int = 0
    private lazy var viewModel = EnrollDealDetailsViewModel(hostVC: self)
    private var searchWorkItem: DispatchWorkItem?
    var dealId: Int? = 0
    var sellerId: Int? = 0
    var appliedDealFilter = DealFilterModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTF.delegate = self
        updatePaginationButtonImages()
        if type == 1 {
            totalRevenueView.isHidden = true
        } else {
            totalRevenueView.isHidden = false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
            viewModel.currentPage = 1
            viewModel.getAllProductsList()
    }
    
    @IBAction func backDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func filterDidTapped(_ sender: Any) {
        let vc = FilterForDealsViewController.instantiate(fromAppStoryboard: .LiveStoryDealManagement)
        vc.selectedFilter = viewModel.appliedFilter
        vc.onApplyFilter = { [weak self] filter in
            guard let self = self else { return }
            self.viewModel.appliedFilter = filter
            self.viewModel.currentPage = 1
            self.viewModel.getAllProductsList()
        }
        vc.onClearFilter = { [weak self] in
            guard let self = self else { return }
            self.viewModel.appliedFilter = ProductFilterModelOnBrand()
            self.viewModel.currentPage = 1
            self.viewModel.getAllProductsList()
        }
        self.navigationController?.present(vc, animated: false)
    }
    
    @IBAction func nextDidTapped(_ sender: Any) {
        guard viewModel.currentPage < viewModel.totalPages else { return }
            viewModel.currentPage += 1
            reloadPaginationUI()
    }
    
    @IBAction func previousDidTapped(_ sender: Any) {
        guard viewModel.currentPage > 1 else { return }
            viewModel.currentPage -= 1
            reloadPaginationUI()
    }
    
    func configData(data: SellerDealrecord?) {
        usernameLabel.text = "\(data?.sellerDetails?.firstName ?? "") \(data?.sellerDetails?.lastName ?? "")"
        locationLabel.text = "\(data?.sellerDetails?.countryDetails?.name ?? "")"
        addedProductsLabel.text = "\(data?.productCount ?? 0) Products"
//        productAddedLabel.text = data?.?.description
        
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
    
    func reloadPaginationUI() {

        let hasData = !viewModel.paginatedProducts.isEmpty

        noDataFoundLabel.isHidden = hasData
        productCollectionView.isHidden = !hasData

        pagecountLabel.text = String(
            format: "%02d of %02d",
            viewModel.currentPage,
            viewModel.totalPages
        )

        productCollectionView.reloadData()
        updatePaginationButtonImages()
    }

    
}

extension EnrollDealDetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.paginatedProducts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "DealDetailsCollectionViewCell",
                for: indexPath
            ) as! DealDetailsCollectionViewCell

            let product = viewModel.paginatedProducts[indexPath.item]

//            if type == 1 {
//                cell.statusButtonOutlet.isHidden = false
//            } else {
                cell.statusButtonOutlet.isHidden = true
//            }
        cell.configDealData(data: product, categoryName: viewModel.productsList?.categoryDetails?.name ?? "", subCategoryName: viewModel.productsList?.subCategoryDetails?.nameEnglish ?? "")
            return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spacing: CGFloat = 10
        let totalSpacing = spacing * 2 // 3 cells per row → 2 spaces between
        let width = (collectionView.frame.width - totalSpacing) / 2
        return CGSize(width: width, height: 240)
    }
    
}


extension EnrollDealDetailsViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
        searchWorkItem?.cancel()
        let workItem = DispatchWorkItem { [weak self] in
            guard let self = self else { return }
            self.viewModel.searchText = currentText
            self.viewModel.currentPage = 1
            self.viewModel.getAllProductsList()
        }
        searchWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: workItem)
        return true
    }
}

