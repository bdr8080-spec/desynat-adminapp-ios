//
//  SideMenuViewController.swift
//  DesynatAdmin
//
//  Created by Rakhi Kumari on 31/10/25.
//

import UIKit

class SideMenuViewController: UIViewController {
    
    // MARK: - IBOutlet's
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var userProfileImageView: CustomImageView!
    @IBOutlet weak var sideMenuHeightConstaint: NSLayoutConstraint!
    @IBOutlet weak var sideMenuTableView: UITableView! {
        didSet {
            sideMenuTableView.registerCellFromNib(cellID: "SideMenuTableViewCell")
        }
    }
    
    // MARK: - Property Decalaration
    private var sideMenuData: [SideMenuModel] = [
        SideMenuModel(title: "Brand management", image: "brandManagemnt"),
        SideMenuModel(title: "Category & Sub- Category Management", image: "category"),
        SideMenuModel(title: "Seller Management", image: "sellerManagement"),
        SideMenuModel(title: "Country , City & Zone Management", image: "country"),
        SideMenuModel(title: "Reason Management", image: "reason"),
        SideMenuModel(title: "Delivery Boy Management", image: "deliveryBoy"),
        SideMenuModel(title: "User Management", image: "userManagemnet"),
        SideMenuModel(title: "Delivery charges & Tax Management", image: "shippingCharges"),
        SideMenuModel(title: "Gift Card Category Management", image: "gift"),
        SideMenuModel(title: "Banner per day price", image: "bannerPay"),
        SideMenuModel(title: "Promocode Management", image: "promocode"),
        SideMenuModel(title: "Affiliate Commission percentage", image: "affilitaeCommisiin"),
        SideMenuModel(title: "Banner requests Management", image: "bannerRequest"),
        SideMenuModel(title: "Banner Management", image: "bannerRequest"),
        SideMenuModel(title: "Orders Management", image: "orderManagemnt"),
        SideMenuModel(title: "Live Request  & Timeslot Management", image: "liveReuqest"),
        SideMenuModel(title: "Story Management", image: "storyManagment"),
        SideMenuModel(title: "Deals Management", image: "dealsManagement"),
        SideMenuModel(title: "Affiliate User Management", image: "userManagemnet"),
        SideMenuModel(title: "Affiliate withdrawal requests", image: "affilateWithdraw"),
        
        SideMenuModel(title: "Sub Admin", image: "subadmin"),
        SideMenuModel(title: "Refund Management", image: "refundManagemnt"),
        SideMenuModel(title: "Notifications Management", image: "notificationBell"),
        SideMenuModel(title: "Ticket Management", image: "ticketManagemnt"),
        SideMenuModel(title: "Seller Payouts", image: "sellerPayout"),
        SideMenuModel(title: "CMS", image: "cms"),
        SideMenuModel(title: "Support Chat", image: "support")]
    private lazy var viewModel = SideMenuViewModel(hostVC: self)
    
    // MARK: - View's LifeCycle Methods
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
    
    // MARK: - Button's Action
    @IBAction func backDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func logoutDidTapped(_ sender: Any) {
        self.showConfirmationAlert(msg: "Are you sure you want to logout?"){ [weak self] in
            guard let self = self else { return }
            self.viewModel.logoutAPI()
        }
    }
    
    //MARK: Function's declaration
    private func updateTableHeight() {
        DispatchQueue.main.async {
            self.sideMenuHeightConstaint.constant = self.sideMenuTableView.contentSize.height
        }
    }
}

// MARK: - TABLE VIEW METHODS
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
            let nextVC = AffiliatedUsersListViewController.instantiate(fromAppStoryboard: .LiveStoryDealManagement)
            self.navigationController?.pushViewController(nextVC, animated: false)
        case "Seller Management":
            self.navigate(to: SellerListViewController.viewFromNIB)
        case "Delivery Boy Management":
            let vc = DeliveryBoyViewController.instantiate(fromAppStoryboard: .ReasonManagement)
            self.navigationController?.pushViewController(vc, animated: false)
        case "Live Request  & Timeslot Management":
            let nextVC = LiveRequestListManagementViewController.instantiate(fromAppStoryboard: .LiveStoryDealManagement)
            self.navigationController?.pushViewController(nextVC, animated: false)
        case "Gift Card Category Management":
            let vc = GiftCardsListViewController.instantiate(fromAppStoryboard: .ShippingPromocode)
            self.navigationController?.pushViewController(vc, animated: false)
        case "Orders Management":
            let nextVC = OrdersManagementListViewController.instantiate(fromAppStoryboard: .AffiliatedBannerOrder)
            self.navigationController?.pushViewController(nextVC, animated: true)
        case "Country , City & Zone Management":
            self.navigate(to: CountryCityListViewController.viewFromNIB)
        case "Delivery charges & Tax Management":
            let vc = ShippingChargesListViewController.instantiate(fromAppStoryboard: .ShippingPromocode)
            self.navigationController?.pushViewController(vc, animated: false)
        case "Promocode Management":
            let vc = PromodeListViewController.instantiate(fromAppStoryboard: .ShippingPromocode)
            self.navigationController?.pushViewController(vc, animated: false)
        case "Affiliate Commission percentage":
            let nextVC = AffiliatedCommissionViewController.instantiate(fromAppStoryboard: .AffiliatedBannerOrder)
            self.navigationController?.pushViewController(nextVC, animated: false)
        case "Refund Management":
            print("➡️ Navigating to Refund Management")
        case "Affiliate withdrawal requests":
            print("➡️ Navigating to Affiliate withdrawal requests")
            let nextVC = AffiliatedWithdrawalRequestListViewController.instantiate(fromAppStoryboard: .LiveStoryDealManagement)
            self.navigationController?.pushViewController(nextVC, animated: true)
        case "Notifications Management":
            let nextVC = NotificationsListViewController.instantiate(fromAppStoryboard: .NotificationCMS)
            self.navigationController?.pushViewController(nextVC, animated: true)
        case "Story Management":
            let nextVC = StoryManagemnetViewController.instantiate(fromAppStoryboard: .LiveStoryDealManagement)
            self.navigationController?.pushViewController(nextVC, animated: true)
        case "Ticket Management":
            print("➡️ Navigating to Ticket Management")
        case "Seller Payouts":
            print("➡️ Navigating to Seller Payouts")
        case "Deals Management":
            let nextVC = DealsManagementListViewController.instantiate(fromAppStoryboard: .LiveStoryDealManagement)
            self.navigationController?.pushViewController(nextVC, animated: true)
            print("➡️ Navigating to Deals Management")
        case "Banner per day price":
            let vc = BannerPerDayListViewController.instantiate(fromAppStoryboard: .ShippingPromocode)
            self.navigationController?.pushViewController(vc, animated: false)
        case "Banner requests Management":
            let vc = BannersManagementListViewController.instantiate(fromAppStoryboard: .AffiliatedBannerOrder)
            self.navigationController?.pushViewController(vc, animated: false)
        case "Banner Management":
            let vc = FullScreenBannerViewController.instantiate(fromAppStoryboard: .AffiliatedBannerOrder)
            self.navigationController?.pushViewController(vc, animated: false)
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


