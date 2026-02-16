//
//  ProductsViewModel.swift
//  DesynatAdmin
//
//  Created by fluper_mac3 on 13/02/26.
//


import Foundation

class ProductsViewModel {
    
    private var hostVC: ProductsViewController?
    var searchText: String = ""
    
    var categoriesList: [GetCategoryModel] = []
    var subcategoriesList: [GetSubCategoryDataList] = []
    var brandsList: [GetBrandDataList] = []
    var countryList: [GetCountryDataModel] = []
    
    var appliedFilter: AppliedFilterForProductList?
    var searchWorkItem: DispatchWorkItem?
    var productsListData: [ProductsList] = []
    
    private var currentPage = 1
    private var lastPage = 1
    private var isFetching = false
    private var hasMorePages = true
    
    init(hostVC: ProductsViewController) {
        self.hostVC = hostVC
    }
    
    func getCategoriesListApi() {
        WebService.sharedInstance.getAllCategory { [weak self] list in
            self?.categoriesList = list
            self?.getAllsubcategoryApi(id: list.first?.id)
        }
    }
    
    func getAllsubcategoryApi(id: Int?) {
        let param: [String :Any] = ["category_id": id ?? ""]
        WebService.sharedInstance.getAllsubcategory(param: param) { [self] list in
            self.subcategoriesList = list.data ?? []
        }
    }
    
    func getCountryListApi() {
        WebService.sharedInstance.getAllCountry { [weak self] list in
            self?.countryList = list
        }
    }
    
    func getBrandListApi() {
        WebService.sharedInstance.getAllBrandsListForFilter { [weak self] list in
            self?.brandsList = list.data ?? []
        }
    }
    
    func getAllProducts(reset: Bool = false) {
        if reset {
            currentPage = 1
            lastPage = 1
            hasMorePages = true
            productsListData.removeAll()
            hostVC?.productsTableView.reloadData()
        }
        guard !isFetching, hasMorePages else { return }
        isFetching = true
        var params: [String: Any] = [
            "page": currentPage,
            "limit": 10]
        
        if !searchText.isEmpty {
            params["search"] = searchText
        }
        if let countryIDs = appliedFilter?.countryIDs, !countryIDs.isEmpty {
            params["country"] = countryIDs
        }
        if let categoryId = appliedFilter?.categoryId, !categoryId.isEmpty {
            params["category"] = categoryId
        }
        if let subCategoryIDs = appliedFilter?.subcategoryIDs, !subCategoryIDs.isEmpty {
            params["subcategory"] = subCategoryIDs
        }
        if let brandIDs = appliedFilter?.brandIDs, !brandIDs.isEmpty {
            params["brand"] = brandIDs
        }
        WebService.shared.getAllProductsList(param: params) { [weak self] response in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.isFetching = false
                let data = response.data ?? []
                if reset {
                    self.productsListData = data
                } else {
                    self.productsListData.append(contentsOf: data)
                }
                self.lastPage = response.lastPage ?? 1
                self.hasMorePages = self.currentPage < self.lastPage
                if self.hasMorePages {
                    self.currentPage += 1
                }
                self.hostVC?.productsTableView.reloadData()
                self.hostVC?.noDataFoundLabel.isHidden = !self.productsListData.isEmpty
            }
        }
    }
    
    func resetAndFetchProducts() {
        currentPage = 1
        lastPage = 1
        isFetching = false
        hasMorePages = true
        productsListData.removeAll()
        getAllProducts(reset: true)
    }
    
    func updateActiveStatus(param: [String: Any], completion: @escaping (Bool) -> Void) {
        WebService.sharedInstance.updateProductsstatus(param: param){ response in
            completion(true)
        }
    }
}
