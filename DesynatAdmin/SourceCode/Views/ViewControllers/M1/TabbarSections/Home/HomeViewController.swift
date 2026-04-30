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
    @IBOutlet weak var newOrderLabel: UILabel!
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
    private var durationSelectedIndex: Int = 0
    let datePicker = UIDatePicker()
    private var activeTextField: UITextField?
    private var selectedCountryIndex: Int = 0
    private lazy var viewModel = HomeViewModel(hostVC: self)
    
    // MARK: - View's LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        uiSetup()
        bindData()
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
    private func bindData() {
        totalUserRegisteredLabel.text = String(format: "Total users registered (%@)".localiz(),"\(100)")
        totalAffiliatedLabel.text = String(format: "Total Affiliated registered (%@)".localiz(),"\(100)")
        totalDriverRegisteredCountLabel.text = String(format: "Total Drivers registered (%@)".localiz(),"\(100)")
        totalSellerCountLabel.text = String(format: "Total Seller registered (%@)".localiz(),"\(100)")
        totalOrderCountLabel.text = String(format: "Total Orders (%@)".localiz(),"\(100)")
        totalTicketCountLabel.text = String(format: "Total tickets (%@)".localiz(),"\(100)")
        totalOnlineUserCountLabel.text = String(format: "Total Online Users (%@)".localiz(),"\(100)")
    }
    
    private func uiSetup() {
        totalRevenueIImageView.layer.cornerRadius = 16
        totalRevenueIImageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        totalRevenueIImageView.clipsToBounds = true
        revenueDetailsView.layer.cornerRadius = 16
        revenueDetailsView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        revenueDetailsView.clipsToBounds = true
    }
    
}

// MARK: - COLLECTION VIEW METHODS
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return durationArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DurationCollectionViewCell", for: indexPath) as! DurationCollectionViewCell
        cell.titleLabel.text = durationArray[indexPath.row].localiz()
        if durationSelectedIndex == indexPath.row {
            cell.selectedImageView.image = UIImage(named: "durationSelected")
        } else {
            cell.selectedImageView.image = UIImage(named: "durationUnselected")
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        durationSelectedIndex = indexPath.row
        durationCollectionView.reloadData()
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
        cell.configData(data: data,isSelected: indexPath.row == selectedCountryIndex)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCountryIndex = indexPath.row
        let data = viewModel.countryListData[indexPath.row]
        dropdownCountryLabel.text = data.name
        dropDownCountryFlagEmoji.text = data.flag
        selectedCountryLabel.text = data.name
        countryTableView.reloadData()
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
    
    @objc private func doneDatePicker() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        
        if activeTextField == fromDateTextField {
            fromDateTextField.text = formatter.string(from: datePicker.date)
        } else if activeTextField == toDateTextField {
            toDateTextField.text = formatter.string(from: datePicker.date)
        }
        view.endEditing(true)
    }
    
    @objc private func cancelDatePicker() {
        view.endEditing(true)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
    }
}
