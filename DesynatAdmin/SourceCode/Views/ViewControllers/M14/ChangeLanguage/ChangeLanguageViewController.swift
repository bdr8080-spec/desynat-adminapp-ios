//
//  ChangeLanguageViewController.swift
//  DesynatAdmin
//
//  Created by fluper_mac2 on 30/04/26.
//


import UIKit

class ChangeLanguageViewController: UIViewController {

    // MARK: - IBOutlet's
    @IBOutlet weak var arabicView: CustomView!
    @IBOutlet weak var englishView: CustomView!
    @IBOutlet weak var imgArabic: UIImageView!
    @IBOutlet weak var imgEnglish: UIImageView!
    @IBOutlet weak var headerView: UIView!
    
    // MARK: - Property Decalaration
    var selectedLanguage: Languages = .en
    var comingFromDashboard: Bool = false
    var hasActionPermission: Bool = false
    
    // MARK: - View's LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        handleUISetup()
        selectedLanguage = AppLanguageManager.shared.currentLanguage
        selectLanguage(isEnglishSelected: selectedLanguage != .ar)
    }
    
    // MARK: - Button's Action
    @IBAction func btnSelectLanguage(_ sender: UIButton) {
        if sender.tag == 0 {
            selectedLanguage = .en
            selectLanguage(isEnglishSelected: true)
        } else {
            selectedLanguage = .ar
            selectLanguage(isEnglishSelected: false)
        }
        applyLanguageChange()
    }
    
    @IBAction func btnTapSave(_ sender: Any) {
        AppLanguageManager.shared.setLanguage(language: selectedLanguage)
        if kSharedUserDefaults.isUserLoggedIn() {
            if let savedUser: UserModel = kSharedUserDefaults.retrieveModelFor(key: .user, model: UserModel.self) {
                if savedUser.type == "2" {
                    self.getStaffDetails()
                } else {
                    self.dismiss(animated: true)
                    kSharedSceneDelegate.navigateToUserHomeVc()
                }
            }
        }
    }

    @IBAction func dismissDidTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    private func handleUISetup() {
        headerView.layer.cornerRadius = 24
        headerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        headerView.clipsToBounds = true
    }
    
    func getStaffDetails() {
        if kSharedUserDefaults.isSubAdminUserHasDashboardAccess() {
            self.dismiss(animated: true)
            kSharedSceneDelegate.navigateToDashboardHomeVc()
        } else {
            self.dismiss(animated: true)
            kSharedSceneDelegate.navigateToSideMenuVc()
        }
    }
    
    private func selectLanguage(isEnglishSelected: Bool) {
        let selectedColor = UIColor(named: "darkBrown")?.cgColor
        let deselectedColor = UIColor.lightGray.cgColor
        
        // English
        englishView.layer.borderColor = isEnglishSelected ? selectedColor : deselectedColor
        imgEnglish.image = UIImage(named: isEnglishSelected ? "radioSelected" : "radioUnselected")
        
        // Arabic
        arabicView.layer.borderColor = isEnglishSelected ? deselectedColor : selectedColor
        imgArabic.image = UIImage(named: isEnglishSelected ? "radioUnselected" : "radioSelected")
    }
    
    private func applyLanguageChange() {
        AppLanguageManager.shared.setLanguage(language: selectedLanguage)
        if selectedLanguage == .ar {
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
        } else {
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
        }
        refreshUI()
    }
    
    private func refreshUI() {
        let nextVC = ChangeLanguageViewController.instantiate(fromAppStoryboard: .NotificationCMS)
        self.navigationController?.setViewControllers([nextVC], animated: false)
    }
}


