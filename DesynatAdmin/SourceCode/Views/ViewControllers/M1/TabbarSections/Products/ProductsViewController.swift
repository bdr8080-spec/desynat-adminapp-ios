//
//  ProfileViewController.swift
//  DesynatUser
//
//  Created by Rakhi Kumari on 24/10/25.
//

import UIKit

class ProductsViewController: UIViewController {
    
    @IBOutlet weak var searchTF: UITextField!
    @IBOutlet weak var noDataFoundLabel: UILabel!
    @IBOutlet weak var productsTableView: UITableView! {
        didSet {
            productsTableView.registerCellFromNib(cellID: "ProductManagementTableViewCell")
        }
    }
    private lazy var viewModel = ProductsViewModel(hostVC: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTF.delegate = self
        viewModel.getCategoriesListApi()
        viewModel.getCountryListApi()
        viewModel.getBrandListApi()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getAllProducts()
    }
    
    @IBAction func filterDidTapped(_ sender: Any) {
        let nextVC = ProductFiltersViewController.instantiate(fromAppStoryboard: .Home)
        nextVC.brandsList = viewModel.brandsList
        nextVC.categoriesList = viewModel.categoriesList
        nextVC.countriesList = viewModel.countryList
//        nextVC.selectedCategoryIDs = viewModel.appliedFilter.categoryIDs
        nextVC.selectedBrandIDs = viewModel.appliedFilter.brandIDs
        nextVC.onFilterApplied = { [weak self] selectedCountryIds, selectedCat, selectedSubCat, selectedBrand in
          guard let self = self else { return }
            viewModel.appliedFilter.categoryIDs = selectedCat
            viewModel.appliedFilter.brandIDs = selectedBrand
          viewModel.getAllProducts()
        }
        self.navigationController?.present(nextVC, animated: true)
    }
    
    @IBAction func exportDidTapped(_ sender: Any) {
        
    }
    
    func toggleStatus(at index: Int) {
        let productID = viewModel.productsListData!.allProductData?[index].id ?? 0
        let params = ["product_id": productID]
        viewModel.updateActiveStatus(param: params) { [weak self] success in
            guard let self else { return }
            if success {
                viewModel.getAllProducts()
            }
        }
    }
    
}

extension ProductsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4//viewModel.productsListData?.allProductData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductManagementTableViewCell", for: indexPath) as! ProductManagementTableViewCell
//        let product = viewModel.productsListData?.allProductData?[indexPath.row]
//        cell.configData(data: product)
//        cell.onStatusToggle = { [weak self] in
//            self?.toggleStatus(at: indexPath.row)
//        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let nextVC = ProductDetailViewController.instantiate(fromAppStoryboard: .Home)
//        nextVC.productId = viewModel.productsListData?.allProductData?[indexPath.row].id
            self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
}

extension ProductsViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
        viewModel.searchWorkItem?.cancel()
        let workItem = DispatchWorkItem { [weak self] in
            guard let self = self else { return }
            self.viewModel.searchText = currentText
            viewModel.getAllProducts()
        }
        viewModel.searchWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: workItem)
        return true
    }
}
