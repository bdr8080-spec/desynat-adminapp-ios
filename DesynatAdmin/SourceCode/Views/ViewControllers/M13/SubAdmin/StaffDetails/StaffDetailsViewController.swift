//
//  StaffDetailsViewController.swift
//  DesynatDealer
//
//  Created by  shailendra singh on 26/03/26.
//

import UIKit
import SDWebImage
import MessageUI

class StaffDetailsViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var isActiveLbl: UILabel!
    @IBOutlet weak var profileImageView: CustomImageView!
    @IBOutlet weak var mobileNumberLbl: UILabel!
    @IBOutlet weak var designationLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var activeStatusbtn: UIButton!
    @IBOutlet weak var accessModuleTableView: UITableView!{
        didSet{
            accessModuleTableView.registerCellFromNib(cellID:
                                                        "AccessModuleTableViewCell")
        }
    }
    
    @IBOutlet weak var shareButtton: UIButton!
    @IBOutlet weak var shareCredentailLabel: UILabel!
    @IBOutlet weak var buttonActionStackView: UIStackView!
    
    // MARK: - Variable
    private lazy var viewModel = StaffDetailsViewModel(hostVC: self)
    var isActive: Bool = false
    var isSecureTextEntry: Bool = true
    var originalPassword: String = ""
    var selectedRow: Int?
    var moduleSelctedData: [ModulSelctedData] = []
    var staffID: Int? = 0
    var hasActionPermission: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        shareButtton.isHidden = !hasActionPermission
        shareCredentailLabel.isHidden = !hasActionPermission
        buttonActionStackView.isHidden = !hasActionPermission
        activeStatusbtn.isUserInteractionEnabled = hasActionPermission
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getStaffDetails()
    }
    
    // MARK: - Navigation
    @IBAction func backBtnTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func editProfileBtntapped(_ sender: Any) {
        let vc = AddNewStaffViewController.instantiate(fromAppStoryboard: .NotificationCMS)
        vc.comingReason = .editStaff
        vc.staffDetails = viewModel.staffDetails
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func activeStatusBtnTapped(_ sender: Any) {
        viewModel.upadteStaffStatus(param: ["id": staffID ?? 0])
    }
    
    @IBAction func deleteDidTapped(_ sender: Any) {
        self.showConfirmationAlert(msg: "Are you sure you want to delete this sub admin?".localiz()){ [weak self] in
            guard let self = self else { return }
            let param:[String:Any] = ["id": staffID ?? 0]
            viewModel.deleteStaffDetails(param: param)
        }
    }
    
    @IBAction func shareCredentialDidTapped(_ sender: Any) {
        viewModel.shareStaffDetails()
    }
    
    func configUserData() {
        guard let data = viewModel.staffDetails else { return }
        nameLbl.text = data.fullName
        if let imageUrlString = data.profilePic,
           let url = URL(string: imageUrlString) {
            profileImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            profileImageView.sd_imageIndicator?.startAnimatingIndicator()
            profileImageView.sd_setImage(with: url, placeholderImage: .userProfile)
        } else {
            profileImageView.image = .userProfile
        }
        mobileNumberLbl.text = "\(data.countryCode ?? "")-\(data.mobile ?? "")"
        emailLbl.text = data.email
        countryLabel.text = data.countryInfo?.name
        accessModuleTableView.reloadData()
        isActiveLbl.text = data.status == "1" ? "Active".localiz() : "Inactive".localiz()
        isActiveLbl.textColor = data.status == "1" ? UIColor(hex: "1A900D") : UIColor(hex: "E80B26")
        activeStatusbtn.setImage(UIImage(named: data.status == "1" ? "toggleOn" : "toggleOff"), for: .normal)
    }
    
}
extension StaffDetailsViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.staffDetails?.permissionDetails?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AccessModuleTableViewCell",for: indexPath) as! AccessModuleTableViewCell
        //        let moduleId = indexPath.row + 1
        let permissionsDetails = viewModel.staffDetails?.permissionDetails?[indexPath.row]
        cell.titleView.text = permissionsDetails?.moduleDetails?.displayName
        //        cell.moduleId = moduleId
        cell.viewSelected = (permissionsDetails?.canView == 1) ? true : false
        cell.actionSelected = (permissionsDetails?.canAction == 1) ? true : false
        cell.isRowSelected = true
        cell.radioimageView.image = .radioSelected
        cell.collectionView.isUserInteractionEnabled = false
        cell.collectionView.reloadData()
        return cell
    }
}

