//
//  OrdersManagementListViewController.swift
//  DesynatAdmin
//
//  Created by fluper on 16/12/25.
//

import UIKit

class OrdersManagementListViewController: UIViewController {
    
    // MARK: - IBOutlet's
    @IBOutlet weak var collectionViewMainView: CustomView!
    @IBOutlet weak var categorriesCollectionView: UICollectionView! {
        didSet {
            categorriesCollectionView.registerCellFromNib(cellID: "OrdersManagementCategoryCollectionViewCell")
        }
    }
    @IBOutlet weak var ordersTableView: UITableView! {
        didSet {
            ordersTableView.registerCellFromNib(cellID: "OrderMangementTableViewCell")
        }
    }
    @IBOutlet weak var txtFieldSearch: BindableTextField! {
        didSet {
            self.txtFieldSearch.bind(callback: {self.viewModel.setSearch($0)})
        }
    }
    @IBOutlet weak var noDataFoundLabel: UILabel!
    @IBOutlet weak var lblPageCount: UILabel!
    @IBOutlet weak var btnPreviousPage: UIButton!
    @IBOutlet weak var btnNextPage: UIButton!
    
    // MARK: - Property Decalaration
    private var orderCategoriesList = ["Active", "Return & Exchange", "Completed", "Cancelled"]
    private lazy var viewModel = OrderManagementListViewModel()
    private var selecetedCategoryId: Int = 0
    var hasActionPermission: Bool = false
    
    // MARK: - View's LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupBinding()
        categorriesCollectionView.reloadData()
        selecetedCategoryId = 0
        viewModel.setCategory(.active)
    }
    
    // MARK: - Button's Action
    @IBAction func backDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func filterDidTapped(_ sender: Any) {
        let vc = BannersMangementFilterViewController
            .instantiate(fromAppStoryboard: .AffiliatedBannerOrder)
        vc.configure(
            context: .orders(viewModel.currentCategory),
            filter: viewModel.filterInfo
        ) { [weak self] updatedFilter in
            guard let self else { return }
            self.viewModel.filterInfo = updatedFilter
            self.viewModel.setCategory(self.viewModel.currentCategory)
        }
        
        self.present(vc, animated: true)
    }
    
    @IBAction func handleNextPage(_ sender: UIButton) {
        viewModel.changePage(false)
    }
    
    @IBAction func handlePreviousPage(_ sender: UIButton) {
        viewModel.changePage(true)
    }
    
    //MARK: Function's declaration
    private func setupBinding() {
        
        viewModel.onDataUpdate = { [weak self] in
            guard let self else { return }
            self.ordersTableView.reloadData()
            self.refreshPageActionButton()
        }
        
        viewModel.onNoData = { [weak self] isEmpty in
            guard let self else { return }
            self.noDataFoundLabel.isHidden = !isEmpty
            self.ordersTableView.isHidden = isEmpty
        }
    }
    
    private func refreshPageActionButton() {
        btnNextPage.isUserInteractionEnabled = !viewModel.isLastPage
        btnPreviousPage.isUserInteractionEnabled = !viewModel.isFirstPage
        btnNextPage.setImage(viewModel.isLastPage ? .lightnextimage : .nextRight, for: .normal)
        btnPreviousPage.setImage(viewModel.isFirstPage ? .previousLeft : .darkpreviousimage, for: .normal)
        lblPageCount.text =
        "\(viewModel.currentPage < 10 ? "0" : "")\(viewModel.currentPage) of \(viewModel.totalPage < 10 ? "0" : "")\(viewModel.totalPage)"
    }
    
}

// MARK: - COLLECTION VIEW METHODS
extension OrdersManagementListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return orderCategoriesList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OrdersManagementCategoryCollectionViewCell", for: indexPath) as! OrdersManagementCategoryCollectionViewCell
        cell.configure(title: orderCategoriesList[indexPath.row])
        
        if selecetedCategoryId == indexPath.row {
            cell.mainImageView.isHidden = false
            cell.titleLabel.textColor = .white
        } else {
            cell.mainImageView.isHidden = true
            cell.titleLabel.textColor = .black
        }
        let lastIndex = orderCategoriesList.count - 1
        cell.mainImageView.layer.cornerRadius = 5
        cell.mainImageView.clipsToBounds = true
        if indexPath.row == 0 {
            cell.mainImageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        } else if indexPath.row == lastIndex {
            cell.mainImageView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        } else {
            cell.mainImageView.layer.cornerRadius = 0
            cell.mainImageView.layer.maskedCorners = []
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let text = orderCategoriesList[indexPath.item]
        let font = UIFont.systemFont(ofSize: 14, weight: .medium)
        let textWidth = text.size(withAttributes: [.font: font]).width
        let padding: CGFloat = 24
        return CGSize(width: textWidth + padding, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        selecetedCategoryId = indexPath.row
        categorriesCollectionView.reloadData()
        
        let category: OrderCategory
        switch indexPath.row {
        case 0: category = .active
        case 1: category = .returnExchange
        case 2: category = .completed
        case 3: category = .cancelled
        default: return
        }
        viewModel.setCategory(category)
    }
}

// MARK: - TABLE VIEW METHODS
extension OrdersManagementListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.orders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderMangementTableViewCell", for: indexPath) as! OrderMangementTableViewCell
        let order = viewModel.orders[indexPath.row]
        cell.assignDriverView.isHidden = true
        cell.assignDriverStackView.isHidden = true
        if viewModel.currentCategory == .active {
            //      if order.deliveryDetails?.countryName == "Kuwait" {
            if order.deliveryStatus == "2" || order.deliveryStatus == "2.1"  {
                if order.assignStatus == "1" {
                    cell.assignDriverView.isHidden = true
                    cell.assignDriverStackView.isHidden = true
                } else {
                    cell.assignDriverView.isHidden = false
                    cell.assignDriverStackView.isHidden = false
                }
            } else if order.deliveryStatus == "1" {
                if order.rEApprove == "1" {
                    cell.assignDriverView.isHidden = false
                    cell.assignDriverStackView.isHidden = false
                    
                    if order.assignStatus == "1" {
                        cell.assignDriverView.isHidden = true
                        cell.assignDriverStackView.isHidden = true
                    }
                }
            } else {
                cell.assignDriverView.isHidden = true
                cell.assignDriverStackView.isHidden = true
            }
        } else if order.deliveryStatus == "1" {
            if order.rEApprove == "1" {
                cell.assignDriverView.isHidden = false
                cell.assignDriverStackView.isHidden = false
                
                if order.assignStatus == "1" {
                    cell.assignDriverView.isHidden = true
                    cell.assignDriverStackView.isHidden = true
                }
            }
        } else {
            cell.assignDriverView.isHidden = true
            cell.assignDriverStackView.isHidden = true
        }
        cell.configure(data: order)
        cell.assignDriverTapped = { [weak self] in
            guard let self else { return }
            let nextVC = DriversListViewController.instantiate(fromAppStoryboard: .AffiliatedBannerOrder)
            nextVC.orderId = order.id ?? 0
            nextVC.driverIsAssigned = { driverId, driver in
                self.viewModel.assignDriver(orderId: order.id ?? 0, driverId: driverId) {
                    self.viewModel.setCategory(self.viewModel.currentCategory)
                }
            }
            self.navigationController?.present(nextVC, animated: true)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nextVC = OrderManagementDetailsViewController.instantiate(fromAppStoryboard: .AffiliatedBannerOrder)
        nextVC.orderId = self.viewModel.orders[indexPath.row].id
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
}

