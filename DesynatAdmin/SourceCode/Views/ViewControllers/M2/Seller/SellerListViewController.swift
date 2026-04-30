//
//  SellerListViewController.swift
//  DesynatAdmin
//
//  Created by Meet Goti on 07/11/25.
//

import UIKit

class SellerListViewController: UIViewController, PermissionAccessible {
    
    // MARK: - IBOutlet's
    @IBOutlet weak var btnExport: CustomButton!
    @IBOutlet weak var btnNew: CustomButton!
    @IBOutlet weak var viewNewBar: UIView!
    @IBOutlet weak var btnApproved: CustomButton!
    @IBOutlet weak var viewApprovedBar: UIView!
    @IBOutlet weak var btnRejected: CustomButton!
    @IBOutlet weak var viewRejectedBar: UIView!
    @IBOutlet weak var txtFieldSearch: BindableTextField! {
        didSet {
            self.txtFieldSearch.bind(callback: {self.viewModel.setSearch($0)})
        }
    }
    @IBOutlet weak var lblPageCount: UILabel!
    @IBOutlet weak var lblNoData: UILabel!
    @IBOutlet weak var btnPreviousPage: UIButton!
    @IBOutlet weak var tblSellers: UITableView!
    @IBOutlet weak var btnNextPage: UIButton!
    
    // MARK: - Property Decalaration
    private var viewModel : SellerViewModel = SellerViewModel()
    var hasActionPermission: Bool = false
    var commingFromTabbar: Bool = false
    
    // MARK: - View's LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpUi()
    }

    override func viewDidAppear(_ animated: Bool) {
        self.switchTab(self.viewModel.currentTab)
    }
    
    // MARK: - Button's Action
    @IBAction func handleBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func handleExport(_ sender: Any) {
    }
    
    @IBAction func handleFilter(_ sender: Any) {
        let vc = ApplyFilterViewController.viewFromNIB
        vc.setIntitial(self.viewModel.filterInfo) { info in
            self.viewModel.setFilter(info)
            self.viewModel.getData()
        }
        self.presentVC(vc,withAnimation: false,modalPresentationStyle: .overCurrentContext)
    }
    
    @IBAction func handleTabSwitch(_ sender: UIButton) {
        if let tab = SellersTab(rawValue: sender.tag) {
            self.switchTab(tab)
        }
    }
    
    @IBAction func handleNextPage(_ sender: Any) {
        self.viewModel.changePage(false)
        self.refreshPageActionButton()
    }
    
    @IBAction func handlePreviousPage(_ sender: Any) {
        self.viewModel.changePage(true)
        self.refreshPageActionButton()
    }
    
    //MARK: Function's declaration
    private func setUpUi() {
        self.tblSellers.register(SellersListTableViewCell.self)
        self.tblSellers.dataSource = self
        self.tblSellers.delegate = self
        self.tblSellers.separatorStyle = .none
        self.viewModel.setRefreshHandler(self,sellerActionHandler: self)
        self.refreshPageActionButton()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.btnExport.addGradientBorder(cornerRadius: 5,direction: .topToBottom,colors: [UIColor.init(hexString: "#DFBF8F"), UIColor.init(hexString: "#6E4527")])
        }
    }
    
    private func switchTab(_ tab:SellersTab) {
        self.btnNew.setTitleColor(.init(hexString: tab == .new ? "#875C3A" : "#C0BBBB") , for: .normal)
        self.viewNewBar.backgroundColor = .init(hexString: tab == .new ? "#875C3A" : "#C0BBBB")
        self.btnApproved.setTitleColor(.init(hexString: tab == .approved ? "#875C3A" : "#C0BBBB") , for: .normal)
        self.viewApprovedBar.backgroundColor = .init(hexString: tab == .approved ? "#875C3A" : "#C0BBBB")
        self.btnRejected.setTitleColor(.init(hexString: tab == .reject ? "#875C3A" : "#C0BBBB") , for: .normal)
        self.viewRejectedBar.backgroundColor = .init(hexString: tab == .reject ? "#875C3A" : "#C0BBBB")
        self.txtFieldSearch.text = ""
        self.viewModel.changeTab(tab)
    }
    
    private func refreshPageActionButton() {
        self.btnNextPage.setImage(self.viewModel.isLastPage ? .lightnextimage : .nextRight, for: .normal)
        self.btnNextPage.isUserInteractionEnabled = !self.viewModel.isLastPage
        self.btnPreviousPage.setImage(self.viewModel.isFirstPage ? .previousLeft : .darkpreviousimage, for: .normal)
        self.btnPreviousPage.isUserInteractionEnabled = !self.viewModel.isFirstPage
        self.lblPageCount.text = "\(self.viewModel.currentPage < 10 ? "0" : "")\(self.viewModel.currentPage) of \(self.viewModel.totalPage < 10 ? "0" : "")\(self.viewModel.totalPage)"
    }
}

// MARK: - TABLE VIEW METHODS
extension SellerListViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.viewModel.arraySellers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = self.tblSellers.dequeueReusableCell(withIdentifier: SellersListTableViewCell.defaultIdentifier, for: indexPath) as? SellersListTableViewCell {
            if (self.viewModel.arraySellers.count > indexPath.row) {
                cell.setData(self.viewModel.arraySellers[indexPath.row], hasActionPermission: hasActionPermission)
            }
            cell.selectionStyle = .none
            return cell
        }
        return UITableViewCell(frame: .zero)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.viewModel.arraySellers.count > indexPath.row {
            let vc :SellerDetailViewController = SellerDetailViewController.viewFromNIB
            vc.setInitial(self.viewModel.arraySellers[indexPath.row])
            vc.hasActionPermission = hasActionPermission
            self.navigate(to: vc)
        }
    }
    
}
extension SellerListViewController:HandleTableRefresh {
    func refreshTable(for string: String) {
        self.refreshPageActionButton()
        self.lblNoData.text = self.viewModel.currentTab.placeHolder
        self.lblNoData.isHidden = self.viewModel.arraySellers.count > 0
        self.tblSellers.reloadData()
    }
}


extension SellerListViewController:HandleSellerAction {
    func aprovedSeller(_ data: SellerListInfo) {
        self.viewModel.approveSeller(id: data.id) {
            DispatchQueue.main.async {
                let vc = RegisterationSuccessViewController.instantiate(fromAppStoryboard: .Main)
                vc.setTitle("Seller approved\nsuccessfully!".localiz())
                vc.callBackDismiss = {
                    self.switchTab(.approved)
                }
                self.presentVC(vc,modalPresentationStyle: .overCurrentContext)
            }
        }
        
    }
    
    func rejectSeller(_ data: SellerListInfo) {
        let vc = RejectReasonViewController.viewFromNIB
        vc.needToShowButtonStackView = true
        vc.setCallback { reason,type in
            self.viewModel.rejectSeller(id: data.id, reason: reason,type: type) {
                DispatchQueue.main.async {
                    let succesVC = RegisterationSuccessViewController.instantiate(fromAppStoryboard: .Main)
                    succesVC.setTitle("Seller rejected\nsuccessfully!".localiz())
                    succesVC.callBackDismiss = {
                        self.switchTab(.reject)
                    }
                    vc.dismiss(animated: false)
                    self.presentVC(succesVC)
                }
            }
        }
        self.presentVC(vc,withAnimation: false,modalPresentationStyle: .overCurrentContext)
    }
}
