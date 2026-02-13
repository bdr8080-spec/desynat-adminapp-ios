//
//  ProductsViewModel.swift
//  DesynatAdmin
//
//  Created by fluper_mac3 on 13/02/26.
//


import Foundation

class ProductsViewModel {
    
    private var hostVC: ProductsViewController?
    var productsListData: ProductsListDataModel?
    var searchText: String = ""
    var categoriesList: [GetCategoryModel] = []
    var brandsList: [GetBrandDataList] = []
    var countryList: [GetCountryDataModel] = []
    var appliedFilter = AppliedFilter()
    var searchWorkItem: DispatchWorkItem?
    
    init(hostVC: ProductsViewController) {
        self.hostVC = hostVC
    }
    
    func getCategoriesListApi() {
        WebService.sharedInstance.getAllCategory { [weak self] list in
            self?.categoriesList = list
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
    
    func getAllProducts() {
        var params: [String : Any] = [:]
        // Search
        if !searchText.isEmpty {
            params["search"] = searchText
        }
        //      // cargory_filter
        //    if let categoryIDs = appliedFilter.categoryIDs, !categoryIDs.isEmpty {
        //        params["cargory_filter"] = categoryIDs
        //    }
        //
        //    // BRAND FILTER
        //    if let brandIDs = appliedFilter.brandIDs, !brandIDs.isEmpty {
        //        params["brand_filter"] = brandIDs
        //    }
        
        // API CALL
        //      WebService.sharedInstance.getProductsListServices(param: params) { [weak self] response in
        //          guard let self = self else { return }
        //          self.productsListData = response
        //          DispatchQueue.main.async {
        //              self.hostVC?.productsTableView.reloadData()
        //                self.hostVC?.noDataFoundLabel.isHidden = !(self.productsListData?.activeProduct?.isEmpty ?? true0
        //          }
        //      }
    }
    
    func updateActiveStatus(param: [String: Any], completion: @escaping (Bool) -> Void) {
        //      WebService.sharedInstance.updateProductActiveStatus(param: param){ response in
        //          completion(true)
        //      }
    }
}
