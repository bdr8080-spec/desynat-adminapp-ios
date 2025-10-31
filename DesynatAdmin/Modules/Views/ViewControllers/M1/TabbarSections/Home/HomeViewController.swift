//
//  HomeViewController.swift
//  DesynatUser
//
//  Created by Rakhi Kumari on 23/10/25.
//

import UIKit

class HomeViewController: UIViewController {
    
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
    @IBOutlet weak var durationCollectionView: UICollectionView! {
        didSet {
            durationCollectionView.registerCellFromNib(cellID: "DurationCollectionViewCell")
        }
    }
    
    private var durationArray = ["Today", "Week", "Month", "Year"]
    private var durationSelectedIndex: Int = 0
    let datePicker = UIDatePicker()
    private var activeTextField: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uiSetup()
        bindData()
        setUpTextFields()
    }
    
    @IBAction func profileButtonAction(_ sender: Any) {
        let vc = SideMenuViewController.instantiate(fromAppStoryboard: .SideMenu)
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    @IBAction func chooseCountryDidTapepd(_ sender: Any) {
        
    }
    
    @IBAction func exportDidTapped(_ sender: Any) {
        
    }
    
    private func bindData() {
        totalUserRegisteredLabel.text = "Total users registered (2380)"
        totalAffiliatedLabel.text = "Total Affiliated registered (2380)"
        totalDriverRegisteredCountLabel.text = "Total Drivers registered (2380)"
        totalSellerCountLabel.text = "Total Seller registered (2380)"
        totalOrderCountLabel.text = "Total Orders(14)"
        totalTicketCountLabel.text = "Total tickets (14)"
        totalOnlineUserCountLabel.text = "Total Online Users (2000)"
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

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return durationArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DurationCollectionViewCell", for: indexPath) as! DurationCollectionViewCell
        cell.titleLabel.text = durationArray[indexPath.row]
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

extension HomeViewController {
    private func setUpTextFields() {
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .date
        datePicker.minimumDate = nil
        datePicker.backgroundColor = .white
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneDatePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker))
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
}

extension HomeViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
    }
}
