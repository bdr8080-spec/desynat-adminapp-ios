//
//  ProfileViewController.swift
//  DesynatUser
//
//  Created by Rakhi Kumari on 24/10/25.
//

import UIKit

class ProductsViewController: UIViewController {
    
    // MARK: - IBOutlet's
    @IBOutlet weak var searchTF: UITextField!
    @IBOutlet weak var noDataFoundLabel: UILabel!
    @IBOutlet weak var productsTableView: UITableView! {
        didSet {
            productsTableView.registerCellFromNib(cellID: "ProductManagementTableViewCell")
        }
    }
    @IBOutlet weak var backButton: UIButton!
    
    // MARK: - Property Decalaration
    private lazy var viewModel = ProductsViewModel(hostVC: self)
    var hasActionPermission: Bool = true
    var comingFromTabbar: Bool = true
    
    // MARK: - View's LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTF.delegate = self
        viewModel.getCategoriesListApi()
        viewModel.getCountryListApi()
        viewModel.getBrandListApi()
        backButton.isHidden = comingFromTabbar
//        if kSharedUserDefaults.isSubAdminHasActionDashboardAccess() {
//            hasActionPermission = true
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.resetAndFetchProducts()
    }
    
    @IBAction func backDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    // MARK: - Button's Action
    @IBAction func filterDidTapped(_ sender: Any) {
        let nextVC = ProductFiltersViewController.instantiate(fromAppStoryboard: .Home)
        
        nextVC.countriesList = viewModel.countryList
        nextVC.categoriesList = viewModel.categoriesList
        nextVC.subCategoriesList = viewModel.subcategoriesList
        nextVC.brandsList = viewModel.brandsList
        
        nextVC.selectedCountryIDs = viewModel.appliedFilter?.countryIDs ?? []
        nextVC.selectedCategoryIDs = viewModel.appliedFilter?.categoryId ?? ""
        nextVC.selectedSubCategoryIDs = viewModel.appliedFilter?.subcategoryIDs ?? []
        nextVC.selectedBrandIDs = viewModel.appliedFilter?.brandIDs ?? []
        
        nextVC.onFilterApplied = { [weak self] selectedCountryIds, selectedCat, selectedSubCat, selectedBrand in
            guard let self = self else { return }
            if self.viewModel.appliedFilter == nil {
                self.viewModel.appliedFilter = AppliedFilterForProductList()
            }
            self.viewModel.appliedFilter?.countryIDs = selectedCountryIds
            self.viewModel.appliedFilter?.categoryId = selectedCat
            self.viewModel.appliedFilter?.subcategoryIDs = selectedSubCat
            self.viewModel.appliedFilter?.brandIDs = selectedBrand
            self.viewModel.resetAndFetchProducts()
        }
        
        nextVC.onClearFilter = { [weak self] in
            guard let self = self else { return }
            self.viewModel.appliedFilter = AppliedFilterForProductList()
            self.viewModel.resetAndFetchProducts()
        }
        self.navigationController?.present(nextVC, animated: true)
    }
    
    @IBAction func exportDidTapped(_ sender: Any) {
        
    }
    
    //MARK: Function's declaration
    func toggleStatus(at index: Int) {
        let productID = viewModel.productsListData[index].id ?? 0
        let params = ["id": productID]
        viewModel.updateActiveStatus(param: params) { [weak self] success in
            guard let self = self else { return }
            if success {
                if self.viewModel.productsListData[index].productActiveStatus == 1 {
                    self.viewModel.productsListData[index].productActiveStatus = 0
                } else {
                    self.viewModel.productsListData[index].productActiveStatus = 1
                }
                let newStatus = viewModel.productsListData[index].productActiveStatus == 1 ? 0 : 1
                let message = newStatus == 1 ? "Product has been blocked successfully" : "Product has been unblocked successfully"
                CommonUtils.showToast(message: message)
                DispatchQueue.main.async {
                    self.productsTableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
                }
            }
        }
    }
    
}

// MARK: - TABLE VIEW METHODS
extension ProductsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.productsListData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductManagementTableViewCell", for: indexPath) as! ProductManagementTableViewCell
        let product = viewModel.productsListData[indexPath.row]
        cell.configData(data: product)
        cell.statusButton.isUserInteractionEnabled = hasActionPermission
        cell.onStatusToggle = { [weak self] in
            self?.toggleStatus(at: indexPath.row)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nextVC = ProductDetailViewController.instantiate(fromAppStoryboard: .Home)
        nextVC.productId = viewModel.productsListData[indexPath.row].id ?? 0
        nextVC.hasActionPermission = hasActionPermission
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
}

extension ProductsViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView == productsTableView else { return }
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.size.height
        if offsetY > contentHeight - frameHeight - 50 {
            viewModel.getAllProducts()
        }
    }
    
}

//MARK: UITextFieldDelegate Methods
extension ProductsViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
        viewModel.searchWorkItem?.cancel()
        let workItem = DispatchWorkItem { [weak self] in
            guard let self = self else { return }
            self.viewModel.searchText = currentText
            viewModel.resetAndFetchProducts()
        }
        viewModel.searchWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: workItem)
        return true
    }
    
}
