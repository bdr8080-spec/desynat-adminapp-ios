//
//  EnrollDealDetailsViewModel.swift
//  DesynatAdmin
//
//  Created by fluper_mac3 on 29/01/26.
//

import Foundation

class EnrollDealDetailsViewModel {
    
    private var hostVC: EnrollDealDetailsViewController?
    var productsList: ProductsListInDealListDataModel?
    let pageSize = 4        // 4 products per page
    var currentPage: Int = 1
    var totalPages: Int = 1
    var searchText: String = ""
    var appliedFilter = ProductFilterModelOnBrand()
    
    private var allProducts: [Product] {
        return productsList?.sellerDealrecords?.first?.products ?? []
    }
    
    var paginatedProducts: [Product] {
        let startIndex = (currentPage - 1) * pageSize
        let endIndex = min(startIndex + pageSize, allProducts.count)
        
        guard startIndex < endIndex else { return [] }
        return Array(allProducts[startIndex..<endIndex])
    }
    
    init(hostVC: EnrollDealDetailsViewController) {
        self.hostVC = hostVC
    }
    
    func getAllProductsList() {
        var params: [String: Any] = ["deal_id": hostVC?.dealId ?? 0,
                                     "seller_id":hostVC?.sellerId ?? 0]
        if !searchText.isEmpty {
            params["search"] = searchText
        }
        
        if let brandName = appliedFilter.brandName {
            params["filter"] = brandName
        }
        
        WebService.shared.getAllProductsInDealRequest(param: params) { [weak self] response in
            guard let self = self else { return }
            self.productsList = response
            
            let totalItems = self.allProducts.count
            self.totalPages = max(1, Int(ceil(Double(totalItems) / Double(self.pageSize))))
            self.currentPage = min(self.currentPage, self.totalPages)
            
            DispatchQueue.main.async {
                self.hostVC?.configData(data: response.sellerDealrecords?.first)
                self.hostVC?.reloadPaginationUI()
            }
        }
    }
    
    
    func goToNextPage() {
        guard currentPage < totalPages else { return }
        currentPage += 1
        getAllProductsList()
    }
    
    func goToPreviousPage() {
        guard currentPage > 1 else { return }
        currentPage -= 1
        getAllProductsList()
    }
    
}
