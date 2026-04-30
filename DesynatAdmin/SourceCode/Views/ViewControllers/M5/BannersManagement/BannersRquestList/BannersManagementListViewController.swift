//
//  BannersManagementListViewController.swift
//  DesynatAdmin
//
//  Created by fluper on 16/12/25.
//

import UIKit

class BannersManagementListViewController: UIViewController, HandleTableRefresh {
    
    func refreshTable(for string: String) {
        bannersTableView.reloadData()
        noDataFoundLabel.isHidden = !viewModel.arraySellers.isEmpty
        refreshPageActionButton()
    }
    
    // MARK: - IBOutlet's
    @IBOutlet weak var txtFieldSearch: BindableTextField! {
        didSet {
            self.txtFieldSearch.bind(callback: {self.viewModel.setSearch($0)})
        }
    }
    @IBOutlet weak var noDataFoundLabel: UILabel!
    @IBOutlet weak var nowButton: CustomButton!
    @IBOutlet weak var nowLabel: UILabel!
    @IBOutlet weak var approvedButton: CustomButton!
    @IBOutlet weak var approvedLabel: UILabel!
    @IBOutlet weak var rejectedButton: CustomButton!
    @IBOutlet weak var rejectedLabel: UILabel!
    @IBOutlet weak var bannersTableView: UITableView! {
        didSet {
            bannersTableView.registerCellFromNib(cellID: "BannersManagementListTableViewCell")
        }
    }
    @IBOutlet weak var pageTitleLabel: UILabel!
    @IBOutlet weak var lblPageCount: UILabel!
    @IBOutlet weak var btnPreviousPage: UIButton!
    @IBOutlet weak var btnNextPage: UIButton!
    
    // MARK: - Property Decalaration
    var type: BannersSelectedListType = .new
    private var viewModel : BannersManagementListViewModel = BannersManagementListViewModel()
    var hasActionPermission: Bool = false
    
    // MARK: - View's LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nowButton.layer.cornerRadius = 5
        nowButton.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        nowButton.clipsToBounds = true
        
        setUpUi()
        
        // Default tab = New
        viewModel.changeTab(.new)
    }
    
    // MARK: - Button's Action
    @IBAction func nowDidTapped(_ sender: Any) {
        handleNewAction()
        pageTitleLabel.text = "Banner requests".localiz()
    }
    
    @IBAction func approveDidTapped(_ sender: Any) {
        handleApproveAction()
        pageTitleLabel.text = "Approved".localiz()
    }
    
    @IBAction func rejectedDidTapped(_ sender: Any) {
        handleRejectAction()
        pageTitleLabel.text = "Rejected".localiz()
    }
    
    @IBAction func handleNextPage(_ sender: UIButton) {
        self.viewModel.changePage(false)
        self.refreshPageActionButton()
    }
    
    @IBAction func handlePreviousPage(_ sender: UIButton) {
        self.viewModel.changePage(true)
        self.refreshPageActionButton()
    }
    
    @IBAction func backDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func filterDidTapped(_ sender: Any) {
        let vc = BannersMangementFilterViewController
            .instantiate(fromAppStoryboard: .AffiliatedBannerOrder)
        vc.configure(
            context: .banners,
            filter: viewModel.filterInfo
        ) { [weak self] updatedFilter in
            guard let self else { return }
            self.viewModel.setFilter(updatedFilter)
            self.viewModel.setCurrentPage(1)
            self.viewModel.getData()
        }
        self.present(vc, animated: true)
    }
    
    //MARK: Function's declaration
    private func setUpUi() {
        self.bannersTableView.dataSource = self
        self.bannersTableView.delegate = self
        self.bannersTableView.separatorStyle = .none
        self.viewModel.setRefreshHandler(self,sellerActionHandler: self)
        self.refreshPageActionButton()
    }
    
    private func refreshPageActionButton() {
        self.btnNextPage.setImage(self.viewModel.isLastPage ? .lightnextimage : .nextRight, for: .normal)
        self.btnNextPage.isUserInteractionEnabled = !self.viewModel.isLastPage
        self.btnPreviousPage.setImage(self.viewModel.isFirstPage ? .previousLeft : .darkpreviousimage, for: .normal)
        self.btnPreviousPage.isUserInteractionEnabled = !self.viewModel.isFirstPage
        self.lblPageCount.text = "\(self.viewModel.currentPage < 10 ? "0" : "")\(self.viewModel.currentPage) of \(self.viewModel.totalPage < 10 ? "0" : "")\(self.viewModel.totalPage)"
    }
    
    private func handleApproveAction() {
        nowButton.setImage(UIImage(named: ""), for: .normal)
        nowButton.layer.cornerRadius = 0
        nowLabel.textColor = UIColor.black
        approvedButton.setImage(UIImage(named: "topTabbar"), for: .normal)
        approvedButton.layer.cornerRadius = 0
        approvedLabel.textColor = UIColor.white
        rejectedButton.setImage(UIImage(named: ""), for: .normal)
        rejectedButton.layer.cornerRadius = 0
        rejectedLabel.textColor = UIColor.black
        type = .approved
        txtFieldSearch.text = ""
        viewModel.changeTab(.approved)
    }
    
    private func handleRejectAction() {
        nowButton.setImage(UIImage(named: ""), for: .normal)
        nowButton.layer.cornerRadius = 0
        nowLabel.textColor = UIColor.black
        approvedButton.setImage(UIImage(named: ""), for: .normal)
        approvedLabel.textColor = UIColor.black
        approvedButton.layer.cornerRadius = 0
        rejectedButton.setImage(UIImage(named: "topTabbar"), for: .normal)
        rejectedLabel.textColor = UIColor.white
        rejectedButton.layer.cornerRadius = 5
        rejectedButton.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        rejectedButton.clipsToBounds = true
        type = .rejected
        txtFieldSearch.text = ""
        viewModel.changeTab(.reject)
    }
    
    private func handleNewAction() {
        nowButton.setImage(UIImage(named: "topTabbar"), for: .normal)
        nowButton.layer.cornerRadius = 5
        nowButton.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        nowButton.clipsToBounds = true
        nowLabel.textColor = UIColor.white
        approvedButton.setImage(UIImage(named: ""), for: .normal)
        approvedButton.layer.cornerRadius = 0
        approvedLabel.textColor = UIColor.black
        rejectedButton.setImage(UIImage(named: ""), for: .normal)
        rejectedButton.layer.cornerRadius = 0
        rejectedLabel.textColor = UIColor.black
        type = .new
        txtFieldSearch.text = ""
        viewModel.changeTab(.new)
    }
    
}

// MARK: - TABLE VIEW METHODS
extension BannersManagementListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.arraySellers.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BannersManagementListTableViewCell", for: indexPath) as! BannersManagementListTableViewCell
        if (self.viewModel.arraySellers.count > indexPath.row) {
            cell.setData(self.viewModel.arraySellers[indexPath.row],for: type, hasActionPermission: hasActionPermission)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = BannersManagementDetailsViewController
            .instantiate(fromAppStoryboard: .AffiliatedBannerOrder)
        vc.detailData = viewModel.arraySellers[indexPath.row]
        vc.type = type
        vc.hasActionPermission = hasActionPermission
        vc.onStatusUpdated = { [weak self] updatedBanner in
            guard let self = self else { return }
            
            // Find same banner & update it
            if let index = self.viewModel.arraySellers.firstIndex(where: {
                $0.id == updatedBanner.id
            }) {
                self.viewModel.arraySellers[index] = updatedBanner
                
                // Reload only that row (efficient)
                let indexPath = IndexPath(row: index, section: 0)
                self.bannersTableView.reloadRows(
                    at: [indexPath],
                    with: .none
                )
            }
        }
        
        navigationController?.pushViewController(vc, animated: true)
    } 
}


extension BannersManagementListViewController: HandleBannerAction {
    func aprovedBanner(_ data: BannerListInfo) {
        viewModel.acceptBanner(id: data.id) {
            DispatchQueue.main.async {
                let vc = RegisterationSuccessViewController.instantiate(fromAppStoryboard: .Main)
                vc.setTitle("Banner approved\nsuccessfully!".localiz())
                vc.callBackDismiss = {
                    //          self.handleApproveAction()
                    self.viewModel.getData()
                }
                self.presentVC(vc,modalPresentationStyle: .overCurrentContext)
            }
        }
    }
    
    
    func rejectBanner(_ data: BannerListInfo) {
        let vc = RejectReasonViewController.viewFromNIB
        vc.needToShowButtonStackView = false
        vc.setCallback { reason,type in
            self.viewModel.rejectBanner(id: data.id, reason: reason) {
                DispatchQueue.main.async {
                    let succesVC = RegisterationSuccessViewController.instantiate(fromAppStoryboard: .Main)
                    succesVC.setTitle("Banner rejected\nsuccessfully!".localiz())
                    succesVC.callBackDismiss = {
                        //            self.handleRejectAction()
                        self.viewModel.getData()
                    }
                    vc.dismiss(animated: false)
                    self.presentVC(succesVC)
                }
            }
        }
        self.presentVC(vc,withAnimation: false,modalPresentationStyle: .overCurrentContext)
    }
}

enum BannersSelectedListType: Int {
    case new = 0
    case approved = 1
    case rejected = 2
}

