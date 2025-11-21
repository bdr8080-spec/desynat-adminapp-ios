//
//  SideMenuViewController.swift
//  DesynatAdmin
//
//  Created by Rakhi Kumari on 31/10/25.
//

import UIKit

class SideMenuViewController: UIViewController {

    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var userProfileImageView: CustomImageView!
    @IBOutlet weak var sideMenuHeightConstaint: NSLayoutConstraint!
    @IBOutlet weak var sideMenuTableView: UITableView! {
        didSet {
            sideMenuTableView.registerCellFromNib(cellID: "SideMenuTableViewCell")
        }
    }
    
    private var sideMenuData: [SideMenuModel] = [
        SideMenuModel(title: "Brand management", image: "brandManagemnt"),
        SideMenuModel(title: "Category & Sub- Category Management", image: "category"),
        SideMenuModel(title: "Seller Management", image: "sellerManagement"),
        SideMenuModel(title: "Country , City & Zone Management", image: "country"),
        SideMenuModel(title: "Reason Management", image: "reason"),
        SideMenuModel(title: "Delivery Boy Management", image: "deliveryBoy"),
        SideMenuModel(title: "User Management", image: "userManagemnet"),
        SideMenuModel(title: "Sub Admin", image: "subadmin"),
        SideMenuModel(title: "Affiliate User Management", image: "userManagemnet"),
        SideMenuModel(title: "Live Request  & Timeslot Management", image: "liveReuqest"),
        SideMenuModel(title: "Gift Card Management", image: "gift"),
        SideMenuModel(title: "Orders Management", image: "orderManagemnt"),
        SideMenuModel(title: "Shipping charges & Tax Management", image: "shippingCharges"),
        SideMenuModel(title: "Promocode Management", image: "promocode"),
        SideMenuModel(title: "Affiliate Commission percentage", image: "affilitaeCommisiin"),
        SideMenuModel(title: "Refund Management", image: "refundManagemnt"),
        SideMenuModel(title: "Affiliate withdrawal requests", image: "affilateWithdraw"),
        SideMenuModel(title: "Notifications Management", image: "notificationBell"),
        SideMenuModel(title: "Story Management", image: "storyManagment"),
        SideMenuModel(title: "Ticket Management", image: "ticketManagemnt"),
        SideMenuModel(title: "Seller Payouts", image: "sellerPayout"),
        SideMenuModel(title: "Deals Management", image: "dealsManagement"),
        SideMenuModel(title: "Banner per day price", image: "bannerPay"),
        SideMenuModel(title: "Banner requests Management", image: "bannerRequest"),
        SideMenuModel(title: "CMS", image: "cms"),
        SideMenuModel(title: "Support Chat", image: "support")]
    private lazy var viewModel = SideMenuViewModel(hostVC: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateTableHeight()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getUserData()
    }
    
    override func viewDidLayoutSubviews() {
            super.viewDidLayoutSubviews()
            updateTableHeight()
        }

        private func updateTableHeight() {
            DispatchQueue.main.async {
                self.sideMenuHeightConstaint.constant = self.sideMenuTableView.contentSize.height
            }
        }
    

    @IBAction func backDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func logoutDidTapped(_ sender: Any) {
        self.showConfirmationAlert(msg: "Are you sure you want to logout?"){ [weak self] in
            guard let self = self else { return }
            self.viewModel.logoutAPI()
        }
    }
    
}

extension SideMenuViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sideMenuData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuTableViewCell", for: indexPath) as! SideMenuTableViewCell
        let item = sideMenuData[indexPath.row]
        cell.configData(data: item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let selectedItem = sideMenuData[indexPath.row].title
            
            switch selectedItem {
            case "Brand management":
                let vc = BrandManagementViewController.instantiate(fromAppStoryboard: .SideMenu)
                self.navigationController?.pushViewController(vc, animated: false)
            case "Category & Sub- Category Management":
                let vc = CategoryViewController.instantiate(fromAppStoryboard: .SideMenu)
                self.navigationController?.pushViewController(vc, animated: false)
            case "User Management":
              let vc = UserManagementViewController.instantiate(fromAppStoryboard: .ReasonManagement)
              self.navigationController?.pushViewController(vc, animated: false)
            case "Sub Admin":
                print("➡️ Navigating to Sub Admin")
            case "Affiliate User Management":
                print("➡️ Navigating to Affiliate User Management")
            case "Seller Management":
                self.navigate(to: SellerListViewController.viewFromNIB)
            case "Delivery Boy Management":
              let vc = DeliveryBoyViewController.instantiate(fromAppStoryboard: .SideMenu)
              self.navigationController?.pushViewController(vc, animated: false)
                print("➡️ Navigating to Delivery Boy Management")
            case "Live Request  & Timeslot Management":
                print("➡️ Navigating to Live Request & Timeslot Management")
            case "Gift Card Management":
                print("➡️ Navigating to Gift Card Management")
            case "Orders Management":
                print("➡️ Navigating to Orders Management")
            case "Country , City & Zone Management":
                self.navigate(to: CountryCityListViewController.viewFromNIB)
            case "Shipping charges & Tax Management":
                print("➡️ Navigating to Shipping & Tax Management")
            case "Promocode Management":
                print("➡️ Navigating to Promocode Management")
            case "Affiliate Commission percentage":
                print("➡️ Navigating to Affiliate Commission Percentage")
            case "Refund Management":
                print("➡️ Navigating to Refund Management")
            case "Affiliate withdrawal requests":
                print("➡️ Navigating to Affiliate Withdrawal Requests")
            case "Notifications Management":
                print("➡️ Navigating to Notifications Management")
            case "Story Management":
                print("➡️ Navigating to Story Management")
            case "Ticket Management":
                print("➡️ Navigating to Ticket Management")
            case "Seller Payouts":
                print("➡️ Navigating to Seller Payouts")
            case "Deals Management":
                print("➡️ Navigating to Deals Management")
            case "Banner per day price":
                print("➡️ Navigating to Banner Per Day Price")
            case "Banner requests Management":
                print("➡️ Navigating to Banner Requests Management")
            case "Reason Management":
              let vc = ReasonManagementViewController.instantiate(fromAppStoryboard: .ReasonManagement)
              self.navigationController?.pushViewController(vc, animated: false)
            case "CMS":
                print("➡️ Navigating to CMS")
            case "Support Chat":
                print("➡️ Navigating to Support Chat")
            default:
                print("⚠️ Unknown option selected")
            }
            
        sideMenuTableView.deselectRow(at: indexPath, animated: true)
        }
}


