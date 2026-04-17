//
//  EditProfileViewController.swift
//  DesynatAdmin
//
//  Created by  shailendra singh on 30/03/26.
//

import UIKit
import SDWebImage

class EditProfileViewController: UIViewController {

    @IBOutlet weak var mobileTF: UITextField!
    @IBOutlet weak var countryCodeTF: UITextField!
    @IBOutlet weak var fullnameTF: UITextField!
    @IBOutlet weak var emailIdTF: UITextField!
    @IBOutlet weak var userProfileImageView: CustomImageView!
    
    private lazy var viewModel = EditProfileViewModel(hostVC: self)
    var selectedImageUrl: String = ""
    var countryCode: String = "+965"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.getUserProfile()
        viewModel.getAllCountry() {
            self.configData()
        }
    }

    // MARK: - Navigation
    @IBAction func backBtnTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func changePasswordTapped(_ sender: Any) {
        let vc =  ChangePassowrdViewController.instantiate(fromAppStoryboard: .NotificationCMS)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func changeImageDidTapped(_ sender: Any) {
        ImagePickerManager().pickImage(self) { [weak self] image, fileName, url in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.userProfileImageView.image = image
            }
            guard let compressedImage = image.jpegData(compressionQuality: 0.25),
                  let finalImage = UIImage(data: compressedImage) else {
                return
            }
            self.viewModel.uploadDocument(file: finalImage, isImage: true) { [weak self] uploadedUrl in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.selectedImageUrl = uploadedUrl
                }
            }
        }
    }
    
    @IBAction func saveImageDidTapped(_ sender: Any) {
        if viewModel.validFields() {
            viewModel.editProfileRequest()
        }
    }
    
    @IBAction func countryCodeDidTapped(_ sender: UIButton) {
        let countryNames = viewModel.countryListData.map { country -> String in
            let name = country.name ?? ""
            let dialCode = country.dialCode ?? ""
            let flag = country.flag ?? "🇰🇼"
            return "\(flag)  \(name) (\(dialCode))"
        }
        kSharedAppDelegate.dropDown(dataSource: countryNames, anchorView: sender) { index, item in
            let selectedCountry = self.viewModel.countryListData[index]
            self.countryCodeTF.text = selectedCountry.dialCode
            self.countryCode = selectedCountry.dialCode ?? "+965"
        }
    }
    
    func configData() {
        let data = viewModel.userProfile
        if let imageUrlString = data?.profileImage,
           let url = URL(string: imageUrlString) {
            selectedImageUrl = imageUrlString
            userProfileImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            userProfileImageView.sd_imageIndicator?.startAnimatingIndicator()
            userProfileImageView.sd_setImage(with: url, placeholderImage: .userProfile)
        } else {
            userProfileImageView.image = .userProfile
        }
        fullnameTF.text = data?.fullName
        emailIdTF.text = data?.email
        mobileTF.text = data?.mobile
        countryCode = data?.countryCode ?? "+965"
        countryCodeTF.text = data?.countryCode
        userProfileImageView.enableFullscreenZoom()
    }
    
}
