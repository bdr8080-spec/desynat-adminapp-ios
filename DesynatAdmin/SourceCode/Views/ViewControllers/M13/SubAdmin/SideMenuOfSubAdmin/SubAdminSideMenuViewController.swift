//
//  SubAdminSideMenuViewController.swift
//  DesynatAdmin
//
//  Created by fluper_mac3 on 22/04/26.
//

import UIKit

class SubAdminSideMenuViewController: UIViewController {
    
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
    @IBOutlet weak var backButtonOutlet: UIButton!
    
    // MARK: - Property Decalaration
    private lazy var viewModel = SubAdminSideMenuViewModel(hostVC: self)
    var isNeedToHideBackButton: Bool = false
    private var filteredPermissions: [PermissionDetail] {
            return viewModel.staffDetails?.permissionDetails?
                .filter { $0.moduleID != 1 } ?? []
        }
    // MARK: - View's LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        updateTableHeight()
        backButtonOutlet.isHidden = isNeedToHideBackButton
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
    @IBAction func editProfileBtnTapped(_ sender: Any) {
        let vc  = EditProfileViewController.instantiate(fromAppStoryboard: .NotificationCMS)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func getActionPermission(at indexPath: IndexPath) -> Bool {
        return filteredPermissions[indexPath.row].canAction == 1
    }
    
}

// MARK: - TABLE VIEW METHODS
extension SubAdminSideMenuViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredPermissions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuTableViewCell", for: indexPath) as! SideMenuTableViewCell
        let item = filteredPermissions[indexPath.row]
            cell.configDataForSubAdmin(data: item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = filteredPermissions[indexPath.row]
            let selectedItem = item.moduleDetails?.displayName
            let hasPermission = item.canAction == 1
        switch selectedItem {
        case "Brands Management":
            let vc = BrandManagementViewController.instantiate(fromAppStoryboard: .SideMenu)
            vc.hasActionPermission = hasPermission
            self.navigationController?.pushViewController(vc, animated: false)
        case "Category & Sub-Category Management":
            let vc = CategoryViewController.instantiate(fromAppStoryboard: .SideMenu)
            vc.hasActionPermission = hasPermission
            self.navigationController?.pushViewController(vc, animated: false)
        case "User Management":
            let vc = UserManagementViewController.instantiate(fromAppStoryboard: .ReasonManagement)
            vc.hasActionPermission = hasPermission
            self.navigationController?.pushViewController(vc, animated: false)
        case "Sub Admin Management":
            let nextVC = SubAdminListViewController.instantiate(fromAppStoryboard: .NotificationCMS)
            nextVC.hasActionPermission = hasPermission
            self.navigationController?.pushViewController(nextVC, animated: false)
        case "Affiliate User Management":
            let nextVC = AffiliatedUsersListViewController.instantiate(fromAppStoryboard: .LiveStoryDealManagement)
            nextVC.hasActionPermission = hasPermission
            self.navigationController?.pushViewController(nextVC, animated: false)
        case "Seller Management":
            self.navigate(to: SellerListViewController.viewFromNIB, hasPermission: hasPermission)
        case "Delivery Boy Management":
            let vc = DeliveryBoyViewController.instantiate(fromAppStoryboard: .ReasonManagement)
            vc.hasActionPermission = hasPermission
            self.navigationController?.pushViewController(vc, animated: false)
        case "Live Request & Timeslot Management":
            let nextVC = LiveRequestListManagementViewController.instantiate(fromAppStoryboard: .LiveStoryDealManagement)
            nextVC.hasActionPermission = hasPermission
            self.navigationController?.pushViewController(nextVC, animated: false)
        case "Gift Card Category Management":
            let vc = GiftCardsListViewController.instantiate(fromAppStoryboard: .ShippingPromocode)
            vc.hasActionPermission = hasPermission
            self.navigationController?.pushViewController(vc, animated: false)
        case "Order Management":
            let nextVC = OrdersManagementListViewController.instantiate(fromAppStoryboard: .AffiliatedBannerOrder)
            nextVC.hasActionPermission = hasPermission
            self.navigationController?.pushViewController(nextVC, animated: true)
        case "Country, City & Zone Management":
            self.navigate(to: CountryCityListViewController.viewFromNIB, hasPermission: hasPermission)
        case "Delivery Charges & Tax Management":
            let vc = ShippingChargesListViewController.instantiate(fromAppStoryboard: .ShippingPromocode)
            vc.hasActionPermission = hasPermission
            self.navigationController?.pushViewController(vc, animated: false)
        case "Promo Code Management":
            let vc = PromodeListViewController.instantiate(fromAppStoryboard: .ShippingPromocode)
            vc.hasActionPermission = hasPermission
            self.navigationController?.pushViewController(vc, animated: false)
        case "Affiliate Commission Management":
            let nextVC = AffiliatedCommissionViewController.instantiate(fromAppStoryboard: .AffiliatedBannerOrder)
            nextVC.hasActionPermission = hasPermission
            self.navigationController?.pushViewController(nextVC, animated: false)
        case "Refund Management":
            let vc = RefundManagementViewController.instantiate(fromAppStoryboard: .NotificationCMS)
            vc.hasActionPermission = hasPermission
            self.navigationController?.pushViewController(vc, animated: false)
        case "Affiliate User Withdraw Request Management":
            let nextVC = AffiliatedWithdrawalRequestListViewController.instantiate(fromAppStoryboard: .LiveStoryDealManagement)
            nextVC.hasActionPermission = hasPermission
            self.navigationController?.pushViewController(nextVC, animated: true)
        case "Notification Management":
            let nextVC = NotificationsListViewController.instantiate(fromAppStoryboard: .NotificationCMS)
            nextVC.hasActionPermission = hasPermission
            self.navigationController?.pushViewController(nextVC, animated: true)
        case "Story Management":
            let nextVC = StoryManagemnetViewController.instantiate(fromAppStoryboard: .LiveStoryDealManagement)
            nextVC.hasActionPermission = hasPermission
            self.navigationController?.pushViewController(nextVC, animated: true)
        case "Ticket Management":
            let nextVC = TicketManagementListViewController.instantiate(fromAppStoryboard: .NotificationCMS)
            nextVC.hasActionPermission = hasPermission
            self.navigationController?.pushViewController(nextVC, animated: true)
        case "Seller Payouts":
            let nextVC = SellerPayoutListViewController.instantiate(fromAppStoryboard: .NotificationCMS)
            nextVC.hasActionPermission = hasPermission
            self.navigationController?.pushViewController(nextVC, animated: true)
        case "Deal Management":
            let nextVC = DealsManagementListViewController.instantiate(fromAppStoryboard: .LiveStoryDealManagement)
            nextVC.hasActionPermission = hasPermission
            self.navigationController?.pushViewController(nextVC, animated: true)
        case "Banner Per Day Price Management":
            let vc = BannerPerDayListViewController.instantiate(fromAppStoryboard: .ShippingPromocode)
            vc.hasActionPermission = hasPermission
            self.navigationController?.pushViewController(vc, animated: false)
        case "Banner Request Management":
            let vc = BannersManagementListViewController.instantiate(fromAppStoryboard: .AffiliatedBannerOrder)
            vc.hasActionPermission = hasPermission
            self.navigationController?.pushViewController(vc, animated: false)
        case "Banner Management":
            let vc = FullScreenBannerViewController.instantiate(fromAppStoryboard: .AffiliatedBannerOrder)
            vc.hasActionPermission = hasPermission
            self.navigationController?.pushViewController(vc, animated: false)
        case "Reason Management":
            let vc = ReasonManagementViewController.instantiate(fromAppStoryboard: .ReasonManagement)
            vc.hasActionPermission = hasPermission
            self.navigationController?.pushViewController(vc, animated: false)
        case "CMS Management":
            let nextVC = CMSTermsConditionViewController.instantiate(fromAppStoryboard: .NotificationCMS)
            nextVC.hasActionPermission = hasPermission
            self.navigationController?.pushViewController(nextVC, animated: true)
        case "Support Chat":
            let vc = ChatInboxViewController.instantiate(fromAppStoryboard: .NotificationCMS)
            vc.hasActionPermission = hasPermission
            self.navigationController?.pushViewController(vc, animated: false)
        default:
            print("⚠️ Unknown option selected")
        }
        sideMenuTableView.deselectRow(at: indexPath, animated: true)
    }
}


