//
//  HomeViewController.swift
//  DesynatUser
//
//  Created by Rakhi Kumari on 23/10/25.
//

import UIKit
import SDWebImage

class HomeViewController: UIViewController {
    
    // MARK: - IBOutlet's
    @IBOutlet weak var toDateTextField: UITextField!
    @IBOutlet weak var fromDateTextField: UITextField!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var userProfileImageView: CustomImageView!
    @IBOutlet weak var revenueDetailsView: UIView!
    @IBOutlet weak var totalRevenueIImageView: UIImageView!
    @IBOutlet weak var totalRevenueLabel: UILabel!
    @IBOutlet weak var byOrderLabel: UILabel!
    @IBOutlet weak var bySubscriptionLabel: UILabel!
    @IBOutlet weak var byAffiliateOrders: UILabel!
    @IBOutlet weak var byBannerLabel: UILabel!
    @IBOutlet weak var totalUserRegisteredLabel: UILabel!
    @IBOutlet weak var totalAffiliatedLabel: UILabel!
    @IBOutlet weak var inactiveRegisteredLabel: UILabel!
    @IBOutlet weak var activeRegisteredLabel: UILabel!
    @IBOutlet weak var inactiveAffiliatedLabel: UILabel!
    @IBOutlet weak var activeAffiliatedLabel: UILabel!
    @IBOutlet weak var totalDriverRegisteredCountLabel: UILabel!
    @IBOutlet weak var inactiveDriverLabel: UILabel!
    @IBOutlet weak var activeDriverLabel: UILabel!
    @IBOutlet weak var totalSellerCountLabel: UILabel!
    @IBOutlet weak var inactiveSellerLabel: UILabel!
    @IBOutlet weak var activeSellerLabel: UILabel!
    @IBOutlet weak var totalOrderCountLabel: UILabel!
    @IBOutlet weak var returnedOrderLabel: UILabel!
    @IBOutlet weak var ongoingOrderLabel: UILabel!
    @IBOutlet weak var completeOrderLabel: UILabel!
    @IBOutlet weak var cancelledOrderLabel: UILabel!
    @IBOutlet weak var totalTicketCountLabel: UILabel!
    @IBOutlet weak var resolvedLabel: UILabel!
    @IBOutlet weak var newTicketLabel: UILabel!
    @IBOutlet weak var unresolvedLabel: UILabel!
    @IBOutlet weak var totalOnlineUserCountLabel: UILabel!
    @IBOutlet weak var userVisitWebsiteLabel: UILabel!
    @IBOutlet weak var userVisitLabel: UILabel!
    @IBOutlet weak var countryTableViewHeightConstarint: NSLayoutConstraint!
    @IBOutlet weak var dropdownCountryLabel: CustomLabelFont!
    @IBOutlet weak var countryDropDownView: CustomView!
    @IBOutlet weak var selectedCountryView: CustomView!
    @IBOutlet weak var selectedCountryLabel: CustomLabelFont!
    @IBOutlet weak var dropDownCountryImage: UIImageView!
    @IBOutlet weak var extraSpaceLabel: UILabel!
    @IBOutlet weak var dropDownCountryFlagEmoji: CustomLabelFont!
    @IBOutlet weak var durationCollectionView: UICollectionView! {
        didSet {
            durationCollectionView.registerCellFromNib(cellID: "DurationCollectionViewCell")
        }
    }
    @IBOutlet weak var countryTableView: TableViewDynamicHeight! {
        didSet {
            countryTableView.registerCellFromNib(cellID: "CountryTableViewCell")
        }
    }
    
    @IBOutlet weak var notificationCountView: CustomView!
    @IBOutlet weak var notificationCountLabel: UILabel!
    
    // MARK: - Property Decalaration
    private var durationArray = ["Today", "Week", "Month", "Year"]
    private var selectedDurationIndex: Int?
    let datePicker = UIDatePicker()
    private var activeTextField: UITextField?
    private var selectedCountryIndex: Int = 0
    private lazy var viewModel = HomeViewModel(hostVC: self)
    
    // MARK: - View's LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        uiSetup()
        setUpTextFields()
        countryDropDownView.isHidden = true
        selectedCountryView.isHidden = false
        extraSpaceLabel.isHidden = true
        viewModel.getAllCountry()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        DispatchQueue.main.async {
            self.countryTableViewHeightConstarint.constant = self.countryTableView.contentSize.height
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getUserData()
        viewModel.getCountOfNotificationRequest()
    }
    
    // MARK: - Button's Action
    @IBAction func profileButtonAction(_ sender: Any) {
        if viewModel.userProfileData?.type == "2" {
            let vc = SubAdminSideMenuViewController.instantiate(fromAppStoryboard: .SideMenu)
            self.navigationController?.pushViewController(vc, animated: false)
        } else {
            let vc = SideMenuViewController.instantiate(fromAppStoryboard: .SideMenu)
            self.navigationController?.pushViewController(vc, animated: false)
        }
    }
    
    @IBAction func chooseCountryDidTapepd(_ sender: Any) {
        selectedCountryView.isHidden = true
        countryDropDownView.isHidden = false
        extraSpaceLabel.isHidden = false
    }
    
    @IBAction func exportDidTapped(_ sender: Any) {
        let csvString = generateDashboardCSV()
        guard let fileURL = saveCSVFile(csvString: csvString) else { return }
        let activityVC = UIActivityViewController(activityItems: [fileURL], applicationActivities: nil)
        // For iPad support
        if let popover = activityVC.popoverPresentationController {
            popover.sourceView = self.view
            popover.sourceRect = CGRect(x: self.view.bounds.midX,
                                        y: self.view.bounds.midY,
                                        width: 0,
                                        height: 0)
            popover.permittedArrowDirections = []
        }
        self.present(activityVC, animated: true)
    }
    
    @IBAction func selectedCountryDropDownButtonAction(_ sender: Any) {
        selectedCountryView.isHidden = false
        extraSpaceLabel.isHidden = true
        countryDropDownView.isHidden = true
    }
    
    @IBAction func updateLanguageDidTapped(_ sender: Any) {
        let nextVC = ChangeLanguageViewController.instantiate(fromAppStoryboard: .NotificationCMS)
        self.present(nextVC, animated: true)
    }
    
    @IBAction func bellDidTapped(_ sender: Any) {
        let nextVC = MyNotificationsListViewController.instantiate(fromAppStoryboard: .NotificationCMS)
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    //MARK: Function's declaration
    
    func setDefaultSelection() {
        let country = viewModel.countryListData.first(where: { $0.id == 89 })
        if AppLanguageManager.shared.currentLanguage == .ar {
            dropdownCountryLabel.text = country?.nameAr
            selectedCountryLabel.text = country?.nameAr
        }else {
            dropdownCountryLabel.text = country?.name
            selectedCountryLabel.text = country?.name
        }
        dropDownCountryFlagEmoji.text = country?.flag1
        durationCollectionView.reloadData()
        callDashboardAPI()
    }
    
    private func uiSetup() {
        totalRevenueIImageView.layer.cornerRadius = 16
        totalRevenueIImageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        totalRevenueIImageView.clipsToBounds = true
        revenueDetailsView.layer.cornerRadius = 16
        revenueDetailsView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        revenueDetailsView.clipsToBounds = true
    }
    
    func configData() {
        guard let data = viewModel.adminDashboardData else { return }
        totalRevenueLabel.text = CommonUtils.formatPriceStringInput(data.totalRevenue)
        byOrderLabel.text = CommonUtils.formatPriceStringInput(data.totalOrderRevenue)
        bySubscriptionLabel.text = CommonUtils.formatPriceStringInput(data.totalSubscriptionPlanRevenue)
        byAffiliateOrders.text = CommonUtils.formatPriceStringInput(data.totalAffiliateOrdersRevenue)
        byBannerLabel.text = CommonUtils.formatPriceStringInput(data.totalBannerRevenue)
        totalUserRegisteredLabel.text = String(format: "Total users registered (%@)".localiz(),"\(data.totalUsers ?? 0)")
        activeRegisteredLabel.text = data.totalActiveUsers?.description
        inactiveRegisteredLabel.text = data.totalInactiveUsers?.description
        totalAffiliatedLabel.text = String(format: "Total Affiliated registered (%@)".localiz(),"\(data.totalAffiliateUsers ?? 0)")
        activeAffiliatedLabel.text = data.totalActiveAffiliateUsers?.description
        inactiveAffiliatedLabel.text = data.totalInactiveAffiliateUsers?.description
        totalDriverRegisteredCountLabel.text = String(format: "Total Drivers registered (%@)".localiz(),"\(data.totalDeliveryBoy ?? 0)")
        activeDriverLabel.text = data.totalActiveDeliveryBoy?.description
        inactiveDriverLabel.text = data.totalInactiveDeliveryBoy?.description
        totalSellerCountLabel.text = String(format: "Total Seller registered (%@)".localiz(),"\(data.totalSellers ?? 0)")
        activeSellerLabel.text = data.totalActiveSellers?.description
        inactiveSellerLabel.text = data.totalInactiveSellers?.description
        totalOrderCountLabel.text = String(format: "Total Orders (%@)".localiz(),"\(data.totalOrders ?? 0)")
        returnedOrderLabel.text = data.totalReturnedOrders?.description
        ongoingOrderLabel.text = data.totalOngoingOrders?.description
        completeOrderLabel.text = data.totalCompletedOrders?.description
        cancelledOrderLabel.text = data.totalCancelledOrders?.description
        totalTicketCountLabel.text = String(format: "Total tickets (%@)".localiz(),"\(data.totalTickets ?? 0)")
        newTicketLabel.text = data.totalTickets?.description
        resolvedLabel.text = data.totalResolvedTickets?.description
        unresolvedLabel.text = data.totalUnresolvedTickets?.description
        totalOnlineUserCountLabel.text = String(format: "Total Online Users (%@)".localiz(),"\(data.totalOnlineUsers ?? 0)")
        userVisitLabel.text = data.totalAppVisitorUsers?.description
        userVisitWebsiteLabel.text = data.totalWebsiteVisitorUsers?.description
    }
    
}

// MARK: - COLLECTION VIEW METHODS
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return durationArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "DurationCollectionViewCell",
            for: indexPath
        ) as! DurationCollectionViewCell
        
        cell.titleLabel.text = durationArray[indexPath.row].localiz()
        
        let isSelected = selectedDurationIndex == indexPath.row
        
        cell.selectedImageView.image = UIImage(
            named: isSelected ? "durationSelected" : "durationUnselected"
        )
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if selectedDurationIndex == indexPath.row {
            // Deselect
            selectedDurationIndex = nil
        } else {
            // Select new
            selectedDurationIndex = indexPath.row
        }
        
        collectionView.reloadData()
        callDashboardAPI()
    }
    
    func saveCSVFile(csvString: String) -> URL? {
        
        let fileName = "DashboardData.csv"
        let path = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)
        
        do {
            try csvString.write(to: path, atomically: true, encoding: .utf8)
            return path
        } catch {
//            print("Error writing CSV:", error)
            return nil
        }
    }
    
    func generateDashboardCSV() -> String {
        
        guard let data = viewModel.adminDashboardData else { return "" }
        
        var csv = "Title,Value\n"
        
        csv += "Total Revenue,\(data.totalRevenue ?? "0")\n"
        csv += "By Order,\(data.totalOrderRevenue ?? "0")\n"
        csv += "By Subscription,\(data.totalSubscriptionPlanRevenue ?? "0")\n"
        csv += "By Affiliate Orders,\(data.totalAffiliateOrdersRevenue ?? "0")\n"
        csv += "By Banner,\(data.totalBannerRevenue ?? "0")\n"
        
        csv += "Total Users Registered,\(data.totalUsers ?? 0)\n"
        csv += "Active Users,\(data.totalActiveUsers ?? 0)\n"
        csv += "Inactive Users,\(data.totalInactiveUsers ?? 0)\n"
        
        csv += "Total Affiliated,\(data.totalAffiliateUsers ?? 0)\n"
        csv += "Active Affiliated,\(data.totalActiveAffiliateUsers ?? 0)\n"
        csv += "Inactive Affiliated,\(data.totalInactiveAffiliateUsers ?? 0)\n"
        
        csv += "Total Drivers,\(data.totalDeliveryBoy ?? 0)\n"
        csv += "Active Drivers,\(data.totalActiveDeliveryBoy ?? 0)\n"
        csv += "Inactive Drivers,\(data.totalInactiveDeliveryBoy ?? 0)\n"
        
        csv += "Total Sellers,\(data.totalSellers ?? 0)\n"
        csv += "Active Sellers,\(data.totalActiveSellers ?? 0)\n"
        csv += "Inactive Sellers,\(data.totalInactiveSellers ?? 0)\n"
        
        csv += "Total Orders,\(data.totalOrders ?? 0)\n"
        csv += "Returned Orders,\(data.totalReturnedOrders ?? 0)\n"
        csv += "Ongoing Orders,\(data.totalOngoingOrders ?? 0)\n"
        csv += "Completed Orders,\(data.totalCompletedOrders ?? 0)\n"
        csv += "Cancelled Orders,\(data.totalCancelledOrders ?? 0)\n"
        
        csv += "Total Tickets,\(data.totalTickets ?? 0)\n"
        csv += "Resolved Tickets,\(data.totalResolvedTickets ?? 0)\n"
        csv += "Unresolved Tickets,\(data.totalUnresolvedTickets ?? 0)\n"
        
        csv += "Total Online Users,\(data.totalOnlineUsers ?? 0)\n"
        csv += "App Visitors,\(data.totalAppVisitorUsers ?? 0)\n"
        csv += "Website Visitors,\(data.totalWebsiteVisitorUsers ?? 0)\n"
        
        return csv
    }
}

// MARK: - TABLE VIEW METHODS
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.countryListData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CountryTableViewCell", for: indexPath) as! CountryTableViewCell
        let data = viewModel.countryListData[indexPath.row]
        cell.configAdminDashboardData(data: data,isSelected: indexPath.row == selectedCountryIndex)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedCountryIndex = indexPath.row
        
        let data = viewModel.countryListData[indexPath.row]
        
//        dropdownCountryLabel.text = data.name
        dropDownCountryFlagEmoji.text = data.flag1
//        selectedCountryLabel.text = data.name
        if AppLanguageManager.shared.currentLanguage == .ar {
            dropdownCountryLabel.text = data.nameAr
            selectedCountryLabel.text = data.nameAr
        }else {
            dropdownCountryLabel.text = data.name
            selectedCountryLabel.text = data.name
        }
        countryTableView.reloadData()
        selectedCountryView.isHidden = false
        extraSpaceLabel.isHidden = true
        countryDropDownView.isHidden = true
        callDashboardAPI()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        viewWillLayoutSubviews()
    }
    
}

//MARK: UITextFieldDelegate Methods
extension HomeViewController: UITextFieldDelegate {
    private func setUpTextFields() {
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .date
        datePicker.minimumDate = nil
        datePicker.backgroundColor = .white
        datePicker.maximumDate = Date()
        if AppLanguageManager.shared.currentLanguage == .ar {
            datePicker.locale = Locale(identifier: "ar")
            datePicker.semanticContentAttribute = .forceRightToLeft
        } else {
            datePicker.locale = Locale(identifier: "en")
            datePicker.semanticContentAttribute = .forceLeftToRight
        }
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done".localiz(), style: .done, target: self, action: #selector(doneDatePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel".localiz(), style: .plain, target: self, action: #selector(cancelDatePicker))
        toolbar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        
        fromDateTextField.inputView = datePicker
        fromDateTextField.inputAccessoryView = toolbar
        toDateTextField.inputView = datePicker
        toDateTextField.inputAccessoryView = toolbar
        
        fromDateTextField.delegate = self
        toDateTextField.delegate = self
    }
    
    private func convertToDate(_ string: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: string)
    }
    
    @objc private func doneDatePicker() {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        if activeTextField == fromDateTextField {
            
            let selectedDate = datePicker.date
            fromDateTextField.text = formatter.string(from: selectedDate)
            
            // 🔥 Reset To Date if invalid
            if let toText = toDateTextField.text,
               let toDate = convertToDate(toText),
               toDate < selectedDate {
                
                toDateTextField.text = ""
            }
        }
        
        else if activeTextField == toDateTextField {
            
            let selectedDate = datePicker.date
            toDateTextField.text = formatter.string(from: selectedDate)
        }
        
        view.endEditing(true)
        
        // ✅ Call API only when valid range exists
        if let from = fromDateTextField.text,
           let to = toDateTextField.text,
           !from.isEmpty, !to.isEmpty {
            
            callDashboardAPI()
        }
    }
    
    @objc private func cancelDatePicker() {
        view.endEditing(true)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
        updateDatePickerRange()
    }
    
    private func updateDatePickerRange() {
        
        if activeTextField == fromDateTextField {
            // From date: no restriction (or max = today)
            datePicker.minimumDate = nil
            datePicker.maximumDate = Date()
        }
        
        else if activeTextField == toDateTextField {
            
            // If from date exists → restrict to date
            if let fromText = fromDateTextField.text,
               let fromDate = convertToDate(fromText) {
                
                datePicker.minimumDate = fromDate
            } else {
                // If no from date selected → block future selection until today logic
                datePicker.minimumDate = nil
            }
            
            datePicker.maximumDate = Date()
        }
    }
    
    func callDashboardAPI() {
        
        let countryId = viewModel.countryListData[selectedCountryIndex].id
        
        let fromDate = fromDateTextField.text
        let toDate = toDateTextField.text
        
        let isDateFilterActive =
        !(fromDate?.isEmpty ?? true) &&
        !(toDate?.isEmpty ?? true)
        
        var filterIndexToSend: Int?
        
        if isDateFilterActive {
            // ignore duration when date is applied
            filterIndexToSend = nil
        } else {
            // duration logic
            if let selected = selectedDurationIndex {
                filterIndexToSend = selected
            } else {
                filterIndexToSend = nil // or default API behavior
            }
        }
        
        viewModel.getDashboardData(
            filterIndex: filterIndexToSend,
            countryId: countryId,
            fromDate: isDateFilterActive ? fromDate : nil,
            toDate: isDateFilterActive ? toDate : nil
        )
    }
}
