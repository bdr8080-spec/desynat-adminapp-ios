//
//  SellerDetailViewController.swift
//  DesynatAdmin
//
//  Created by Meet Goti on 07/11/25.
//

import UIKit
import Cosmos

class SellerDetailViewController: UIViewController {
    
    // MARK: - IBOutlet's
    @IBOutlet weak var btnPending: CustomButton!
    @IBOutlet weak var btnSwitch: CustomButton!
    @IBOutlet weak var btnOtherInfo: CustomButton!
    @IBOutlet weak var btnSellerInfo: CustomButton!
    @IBOutlet weak var viewTabContainer: UIView!
    @IBOutlet weak var lblSellerName: UILabel!
    @IBOutlet weak var viewSellerrating: CosmosView!
    @IBOutlet weak var viewSwitchTab: UIView!
    @IBOutlet weak var viewSellerInfo: UIView!
    @IBOutlet weak var viewReels: UIView!
    @IBOutlet weak var collectionHeighLights: UICollectionView! {
        didSet {
            collectionHeighLights.registerCellFromNib(cellID: "HighlightsCollectionViewCell")
        }
    }
    @IBOutlet weak var collectionReels: CollViewAdjustedHeight! {
        didSet {
            collectionReels.registerCellFromNib(cellID: "ReelsCollectionViewCell")
        }
    }
    @IBOutlet weak var viewHighLights: UIView!
    @IBOutlet weak var lblTotalCompletedOrder: UILabel!
    @IBOutlet weak var lblTotalCancelledOrder: UILabel!
    @IBOutlet weak var lblTotalComissionOrder: UILabel!
    @IBOutlet weak var lblTotalEarningOrder: UILabel!
    @IBOutlet weak var lblTotalOrderText: UILabel!
    @IBOutlet weak var lblSellerEmail: UILabel!
    @IBOutlet weak var lblSellerMobileNumber: UILabel!
    @IBOutlet weak var lblSellerCountry: UILabel!
    @IBOutlet weak var lblSellerBio: UILabel!
    @IBOutlet weak var imgSellerProfile: CustomImageView!
    @IBOutlet weak var imgSellerCover: UIImageView!
    @IBOutlet weak var viewOtherInfo: UIView!
    @IBOutlet weak var lblStoreSellerName: UILabel!
    @IBOutlet weak var imgStoreSellerImage: CustomImageView!
    @IBOutlet weak var stackCanceReason: UIStackView!
    @IBOutlet weak var lblStoreSellerMobileNumber: UILabel!
    @IBOutlet weak var lblStoreSellerEmail: UILabel!
    @IBOutlet weak var lblStoreSellerCountry: UILabel!
    @IBOutlet weak var lblStoreSellerJoinedOn: UILabel!
    @IBOutlet weak var viewStoreImage: UIView!
    @IBOutlet weak var viewStoreSellerInfo: UIView!
    @IBOutlet weak var imgStoreImage: CustomImageView!
    @IBOutlet weak var lblCancelledReason: UILabel!
    @IBOutlet weak var viewStoreName: UIView!
    @IBOutlet weak var lblStoreName: UILabel!
    @IBOutlet weak var viewStoreAddress: UIView!
    @IBOutlet weak var lblStoreAddress: UILabel!
    @IBOutlet weak var viewStorePhoneNumber: UIView!
    @IBOutlet weak var lblStorePhoneNumber: UILabel!
    @IBOutlet weak var viewStoreEmail: UIView!
    @IBOutlet weak var lblStoreEmail: UILabel!
    @IBOutlet weak var viewBio: UIView!
    @IBOutlet weak var viewStoreInfo: CustomView!
    @IBOutlet weak var lblBio: UILabel!
    @IBOutlet weak var viewOwnerDocuments: UIView!
    @IBOutlet weak var stackOwnerDocument: UIStackView!
    @IBOutlet weak var collectionOwnerDocuments: UICollectionView!
    @IBOutlet weak var imgOwnerDoc1: CustomImageView!
    @IBOutlet weak var imgOwnerDoc2: CustomImageView!
    @IBOutlet weak var viewOwnerDoc1: UIView!
    @IBOutlet weak var viewOwnerDoc2: UIView!
    @IBOutlet weak var viewStoreDocuments: UIView!
    @IBOutlet weak var stackStoreDocument: UIStackView!
    @IBOutlet weak var collectionStoreDocuments: UICollectionView!
    @IBOutlet weak var viewStoreDoc1: UIView!
    @IBOutlet weak var viewStoreDoc2: UIView!
    @IBOutlet weak var imgStoreDoc1: CustomImageView!
    @IBOutlet weak var imgStoreDoc2: CustomImageView!
    @IBOutlet weak var stackBankDetail: UIStackView!
    @IBOutlet weak var viewBankDetail: CustomView!
    @IBOutlet weak var viewAccountType: UIView!
    @IBOutlet weak var lblAccountType: UILabel!
    @IBOutlet weak var viewIBAN: UIView!
    @IBOutlet weak var lblIBAN: UILabel!
    @IBOutlet weak var viewSwiftBIC: UIView!
    @IBOutlet weak var lblSwiftBIC: UILabel!
    @IBOutlet weak var viewBankName: UIView!
    @IBOutlet weak var lblBankName: UILabel!
    @IBOutlet weak var viewAccountHolderName: UIView!
    @IBOutlet weak var lblAccountHolderName: UILabel!
    @IBOutlet weak var viewProofOfAccount: UIView!
    @IBOutlet weak var viewPurchasedPlan: CustomView!
    @IBOutlet weak var imgProofAccount: CustomImageView!
    @IBOutlet weak var tblPlans: TableViewDynamicHeight!
    @IBOutlet weak var btnReject: CustomButton!
    @IBOutlet weak var lblPlacePlans: UILabel!
    @IBOutlet weak var lblPlaceHighlights: UILabel!
    @IBOutlet weak var lblPlaceReels: UILabel!
    @IBOutlet weak var btnAccept: CustomButton!
    @IBOutlet weak var viewBottomAction: UIView!
    @IBOutlet weak var lctBottomMainStack: NSLayoutConstraint!
    @IBOutlet weak var heightOfStoriesCollectionView: NSLayoutConstraint!
    @IBOutlet weak var reelButtonOytlet: UIButton!
    
    // MARK: - Property Decalaration
    private var viewModel: SellerDetailViewModel = SellerDetailViewModel()
    var hasActionPermission : Bool = false
    
    // MARK: - View's LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpUi()
        self.setData()
    }
    
    // MARK: - Button's Action
    @IBAction func handleBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func handleTabSwitch(_ sender: UIButton) {
        if let type = DetailTab(rawValue: sender.tag) {
            self.switchTab(type)
        }
    }
    
    @IBAction func profileImageDidTapped(_ sender: Any) {
        let nextVC = StoryViewerViewController.instantiate(fromAppStoryboard: .Home)
        nextVC.comingFor = .forSellerStory
        nextVC.viewModel.sellerStories = viewModel.detailModel?.stories ?? []
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @IBAction func handleReject(_ sender: Any) {
        let vc = RejectReasonViewController.viewFromNIB
        vc.needToShowButtonStackView = true
        vc.setCallback { reason,type in
            self.viewModel.rejectSeller(reason: reason,type: type) {
                DispatchQueue.main.async {
                    let succesVC = RegisterationSuccessViewController.instantiate(fromAppStoryboard: .Main)
                    succesVC.setTitle("Seller rejected\nsuccessfully!".localiz())
                    succesVC.callBackDismiss = {
                        self.navigationController?.popViewController(animated: true)
                    }
                    vc.dismiss(animated: false)
                    self.presentVC(succesVC)
                }
            }
        }
        self.presentVC(vc,withAnimation: false,modalPresentationStyle: .overCurrentContext)
    }
    
    @IBAction func handleAccept(_ sender: Any) {
        self.viewModel.approveSeller {
            DispatchQueue.main.async {
                let vc = RegisterationSuccessViewController.instantiate(fromAppStoryboard: .Main)
                vc.setTitle("Seller approved\nsuccessfully!".localiz())
                vc.callBackDismiss = {
                    self.navigationController?.popViewController(animated: true)
                }
                self.presentVC(vc,modalPresentationStyle: .overCurrentContext)
            }
        }
        
    }
    
    @IBAction func handleSwitch(_ sender: Any) {
        self.viewModel.updateStatusSellers {
            self.viewModel.setActive(!self.viewModel.isActive)
            self.btnSwitch.setImage(self.viewModel.isActive ? .toggleOn : .toggleOff , for: .normal)
        }
        
    }
    
    //MARK: Function's declaration
    func setInitial(_ sellerData:SellerListInfo) {
        self.viewModel.setData(sellerData)
    }
    
    
    private func setUpUi() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.viewTabContainer.addGradientBorder(cornerRadius: 5,direction: .topToBottom,colors: [UIColor.init(hexString: "#DFBF8F"), UIColor.init(hexString: "#6E4527")])
            self.viewOwnerDoc1.appendDashedBorder(rect: self.viewOwnerDoc1.frame,radius: 12, gap: 2, dashWidth: 2,color: .init(hexString: "#DFBF8F"))
            self.viewOwnerDoc2.appendDashedBorder(rect: self.viewOwnerDoc2.frame,radius: 12, gap: 2, dashWidth: 2,color: .init(hexString: "#DFBF8F"))
            self.viewStoreDoc1.appendDashedBorder(rect: self.viewStoreDoc1.frame,radius: 12, gap: 2, dashWidth: 2,color: .init(hexString: "#DFBF8F"))
            self.viewStoreDoc2.appendDashedBorder(rect: self.viewStoreDoc2.frame,radius: 12, gap: 2, dashWidth: 2,color: .init(hexString: "#DFBF8F"))
            self.btnReject.addGradientBorder(cornerRadius: 5,direction: .topToBottom,colors: [UIColor.init(hexString: "#DFBF8F"), UIColor.init(hexString: "#6E4527")])
            self.imgSellerProfile.addGradientBorder(cornerRadius: 5,direction: .topToBottom,colors: [UIColor.init(hexString: "#DFBF8F"), UIColor.init(hexString: "#6E4527")])
            self.btnAccept.applyGradient(colours: [UIColor.init(hexString: "#DFBF8F"), UIColor.init(hexString: "#6E4527")],gradientDirection: .topToBottom,cornerRadius: 5)
        }
        
        self.tblPlans.register(PurchasedPlanTableViewCell.self)
        self.tblPlans.delegate = self
        self.tblPlans.dataSource = self
        self.tblPlans.separatorStyle = .none
    }
    
    private func setData() {
        if let listInfo = self.viewModel.sellerData {
            self.viewSwitchTab.isHidden = listInfo.status != .approved
            self.viewSellerInfo.isHidden =  listInfo.status != .approved
            self.btnSwitch.isHidden =  listInfo.status != .approved
            if listInfo.status == .approved {
                if hasActionPermission {
                    self.btnSwitch.isUserInteractionEnabled = true
                } else {
                    self.btnSwitch.isUserInteractionEnabled = false
                }
            }
            let storiesCount = viewModel.detailModel?.stories?.count ?? 0
            if storiesCount > 0 {
//                self.hostVC.userProfileImageView.borderWidth = 3
                self.reelButtonOytlet.setImage(.gradientBorder, for: .normal)
                self.reelButtonOytlet.isUserInteractionEnabled = true
            }else {
//                self.hostVC.userProfileImageView.borderWidth = 0
                self.reelButtonOytlet.setImage(UIImage(named: ""), for: .normal)
                self.reelButtonOytlet.isUserInteractionEnabled = false
//                false
            }
            self.btnPending.isHidden =  listInfo.status == .approved
            self.btnPending.setTitle(listInfo.status.title, for: .normal)
            self.stackCanceReason.isHidden = listInfo.status != .reject
            self.lblCancelledReason.text = listInfo.reason
            self.lblStoreSellerName.text = listInfo.name
            self.imgSellerProfile.image = .sellerActive
            self.imgStoreSellerImage.image = .sellerActive
            if let url = URL(string: listInfo.image) {
                self.imgSellerProfile.sd_setImage(with: url,placeholderImage: .sellerActive)
                self.imgStoreSellerImage.sd_setImage(with: url,placeholderImage: .sellerActive)
            }
            self.lblSellerName.text = listInfo.name
            self.lblStoreSellerJoinedOn.text = "\("Joined on".localiz()) \(listInfo.joinedOn)"
            self.lblStoreSellerMobileNumber.text = listInfo.mobileNumber
            self.lblSellerMobileNumber.text = listInfo.mobileNumber
            self.lblStoreSellerEmail.text = listInfo.email
            self.lblSellerEmail.text = listInfo.email
            self.lblSellerCountry.text = listInfo.country
            self.lctBottomMainStack.constant = listInfo.status == .new ? self.viewBottomAction.frame.height : 50.0
            //            self.viewBottomAction.isHidden = listInfo.status != .new
           
            if listInfo.status == .new {
                if hasActionPermission {
                    self.viewBottomAction.isHidden = false
                } else {
                    self.viewBottomAction.isHidden = true
                }
            } else {
                self.viewBottomAction.isHidden = true
            }
            if (listInfo.status == .approved) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    self.switchTab(.sellerInfo)
                }
            }
            self.viewStoreSellerInfo.isHidden = listInfo.status == .approved
            self.viewStoreImage.isHidden = listInfo.status == .approved
            //self.viewStoreName.isHidden = listInfo.status == .approved
            self.viewStorePhoneNumber.isHidden = listInfo.status == .approved
            self.viewStoreEmail.isHidden = listInfo.status == .approved
            self.viewBio.isHidden = listInfo.status == .approved
            self.viewPurchasedPlan.isHidden = listInfo.status != .approved
        }
        self.setUpStoreInfo()
    }
    
    private func setUpStoreInfo() {
        
        self.viewModel.getSellerDetailInfo {
            if let detailModel = self.viewModel.detailModel {
                self.imgSellerCover.image = .imgCoverPlace
                if let url = URL(string: String.getString(detailModel.storeInfo?.storeImage)) {
                    self.imgSellerCover.sd_setImage(with: url, placeholderImage: .imgCoverPlace)
                }
                self.btnSwitch.setImage(self.viewModel.isActive ? .toggleOn : .toggleOff , for: .normal)
                self.viewSellerrating.rating = 4.0
                let totalOrders = (detailModel.totalCancelledOrders ?? 0) + (detailModel.totalCompletedOrders ?? 0)
                self.lblTotalOrderText.text = String(format: "Total Orders (%@)".localiz(),"\(totalOrders)")
                self.lblTotalCompletedOrder.text = String.getString(detailModel.totalCompletedOrders)
                self.lblTotalCancelledOrder.text = String.getString(detailModel.totalCancelledOrders)
                self.lblTotalEarningOrder.text = CommonUtils.formatPrice(detailModel.totalEarning)
                self.lblTotalComissionOrder.text = CommonUtils.formatPrice(detailModel.totalCommission)
                if let storeInfo = detailModel.storeInfo {
                    self.imgStoreImage.image = .userProfile
                    if let url = URL(string: String.getString(storeInfo.storeImage)) {
                        self.imgStoreImage.sd_setImage(with: url,placeholderImage: .userProfile)
                    }
                    self.lblStoreName.text = storeInfo.storeName
                    self.lblStoreAddress.text = storeInfo.storeAddress
                    self.lblStorePhoneNumber.text = "\(String.getString(storeInfo.countryCode))-\(String.getString(storeInfo.storePhone))"
                    self.lblStoreEmail.text = String.getString(storeInfo.storeMailId)
                    self.lblBio.text = storeInfo.bio
                    self.lblSellerBio.text = storeInfo.bio
                    if AppLanguageManager.shared.currentLanguage == .ar {
                        self.lblSellerCountry.text = storeInfo.countryInfo?.nameAr
                        self.lblStoreSellerCountry.text = storeInfo.countryInfo?.nameAr
                    }else {
                        self.lblSellerCountry.text = storeInfo.countryInfo?.name
                        self.lblStoreSellerCountry.text = storeInfo.countryInfo?.name
                    }
                }
                let storiesCount = self.viewModel.detailModel?.stories?.count ?? 0
                if storiesCount > 0 {
    //                self.hostVC.userProfileImageView.borderWidth = 3
                    self.reelButtonOytlet.setImage(.gradientBorder, for: .normal)
                    self.reelButtonOytlet.isUserInteractionEnabled = true
                }else {
    //                self.hostVC.userProfileImageView.borderWidth = 0
                    self.reelButtonOytlet.setImage(UIImage(named: ""), for: .normal)
                    self.reelButtonOytlet.isUserInteractionEnabled = false
    //                false
                }
                if let bankInformation = detailModel.sellerBankDetails {
                    self.lblAccountType.text = bankInformation.accountType == "0" ? "Personal".localiz() : "Business".localiz()
                    self.lblIBAN.text = bankInformation.iban
                    self.lblSwiftBIC.text = bankInformation.swift
                    self.lblBankName.text = bankInformation.bankName
                    self.lblAccountHolderName.text = bankInformation.accountHolderName
                    self.imgProofAccount.image = .imgPlaceDoc
                    if let url = URL(string: String.getString(bankInformation.uploadProof)) {
                        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleImageTap(_:)))
                        self.imgProofAccount.addGestureRecognizer(tapGesture)
                        self.imgProofAccount.isUserInteractionEnabled = true
                        self.imgProofAccount.sd_setImage(with: url,placeholderImage: .imgPlaceDoc)
                    }
                }
                if let ownerDocument = detailModel.ownerDocument {
                    if ownerDocument.count > 0 {
                        self.imgOwnerDoc1.image = .imgPlaceDoc
                        if let url = URL(string: String.getString(ownerDocument[0].documentPath)) {
                            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleImageTap(_:)))
                            self.imgOwnerDoc1.addGestureRecognizer(tapGesture)
                            self.imgOwnerDoc1.isUserInteractionEnabled = true
                            self.imgOwnerDoc1.sd_setImage(with: url,placeholderImage: .imgPlaceDoc)
                        }
                    }
                    if ownerDocument.count > 1 {
                        self.imgOwnerDoc2.image = .imgPlaceDoc
                        if let url = URL(string: String.getString(ownerDocument[1].documentPath)) {
                            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleImageTap(_:)))
                            self.imgOwnerDoc2.addGestureRecognizer(tapGesture)
                            self.imgOwnerDoc2.isUserInteractionEnabled = true
                            self.imgOwnerDoc2.sd_setImage(with: url,placeholderImage: .imgPlaceDoc)
                        }
                    }
                }
                if let storeDocument = detailModel.storeDocument {
                    if storeDocument.count > 0 {
                        self.imgStoreDoc1.image = .imgPlaceDoc
                        
                        if let url = URL(string: String.getString(storeDocument[0].documentPath)) {
                            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleImageTap(_:)))
                            self.imgStoreDoc1.addGestureRecognizer(tapGesture)
                            self.imgStoreDoc1.isUserInteractionEnabled = true
                            self.imgStoreDoc1.sd_setImage(with: url,placeholderImage: .imgPlaceDoc)
                        }
                    }
                    if storeDocument.count > 1 {
                        self.imgStoreDoc2.image = .imgPlaceDoc
                        if let url = URL(string: String.getString(storeDocument[1].documentPath)) {
                            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleImageTap(_:)))
                            self.imgStoreDoc2.addGestureRecognizer(tapGesture)
                            self.imgStoreDoc2.isUserInteractionEnabled = true
                            self.imgStoreDoc2.sd_setImage(with: url,placeholderImage: .imgPlaceDoc)
                        }
                    }
                }
                
                let highlightsCount = self.viewModel.detailModel?.highlights?.count ?? 0
                self.collectionHeighLights.isHidden = highlightsCount == 0
                if highlightsCount > 0 {
                    self.heightOfStoriesCollectionView.constant = 100
                } else {
                    self.heightOfStoriesCollectionView.constant = 40
                }
                self.lblPlaceHighlights.isHidden = highlightsCount > 0
                self.lblPlaceReels.isHidden = (self.viewModel.detailModel?.stories?.count ?? 0) > 0
                self.collectionReels.reloadData()
                self.collectionHeighLights.reloadData()
                self.lblPlacePlans.isHidden = self.viewModel.arrayPlans.count > 0
                self.tblPlans.reloadData()
            }
        }
    }
    
    func switchTab(_ tab:DetailTab)  {
        switch tab {
        case .sellerInfo:
            self.btnSellerInfo.applyGradient(colours: [UIColor.init(hexString: "#DFBF8F"), UIColor.init(hexString: "#6E4527")],gradientDirection: .topToBottom,cornerRadius: 5,corners: [.layerMinXMinYCorner,.layerMinXMaxYCorner])
            self.btnOtherInfo.removeGLayer()
            self.btnOtherInfo.backgroundColor = .white
        case .otherInfo:
            self.btnOtherInfo.applyGradient(colours: [UIColor.init(hexString: "#DFBF8F"), UIColor.init(hexString: "#6E4527")],gradientDirection: .topToBottom,cornerRadius: 5,corners: [.layerMaxXMinYCorner,.layerMaxXMaxYCorner])
            self.btnSellerInfo.removeGLayer()
            self.btnSellerInfo.backgroundColor = .white
        }
        self.btnOtherInfo.setTitleColor(tab == .otherInfo ? .white : .black, for: .normal)
        self.btnSellerInfo.setTitleColor(tab == .sellerInfo ? .white : .black, for: .normal)
        self.viewOtherInfo.isHidden = tab != .otherInfo
        self.viewSellerInfo.isHidden = tab != .sellerInfo
    }
    
    @objc func handleImageTap(_ sender:UITapGestureRecognizer) {
        if let view = sender.view as? UIImageView {
            let vc : FullScreenImageViewController = FullScreenImageViewController.viewFromNIB
            vc.setImage(view.image)
            self.navigate(to:vc)
        }
    }
}

// MARK: - TABLE VIEW METHODS
extension SellerDetailViewController:UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.viewModel.arrayPlans.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = self.tblPlans.dequeueReusableCell(withIdentifier: PurchasedPlanTableViewCell.defaultIdentifier, for: indexPath) as? PurchasedPlanTableViewCell {
            cell.selectionStyle = .none
            if (self.viewModel.arrayPlans.count > indexPath.row) {
                cell.setData(self.viewModel.arrayPlans[indexPath.row])
            }
            return cell
        }
        return UITableViewCell(frame: .zero)
    }
    
}

extension SellerDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionReels {
            self.viewModel.detailModel?.reels?.count ?? 0
        } else {
            self.viewModel.detailModel?.highlights?.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collectionReels {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ReelsCollectionViewCell", for: indexPath) as! ReelsCollectionViewCell
            cell.configData(data: viewModel.detailModel?.reels?[indexPath.row])
            cell.onDeleteTapped = { [weak self] in
                self?.showConfirmationAlert(msg: "Are you sure you want to delete this reel?".localiz()) { [weak self] in
                    guard let self = self else { return }
                    self.deleteReel(reelId: viewModel.detailModel?.reels?[indexPath.row].id)
                }
            }
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HighlightsCollectionViewCell", for: indexPath) as! HighlightsCollectionViewCell
            cell.configData(data: viewModel.detailModel?.highlights?[indexPath.row])
            return cell
        }
    }
    
    func deleteReel(reelId: Int?) {
        let param: [String: Any] = ["reel_id": reelId ?? 0]
        WebService.sharedInstance.deleetSellerReelListService(param: param) { [weak self] response in
            guard let self = self else { return }
            CommonUtils.showToast(message: "Reel deleted Successfully".localiz())
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == collectionReels {
            let nextVC = SellerReelsAndHighLightsViewController.instantiate(fromAppStoryboard: .LiveStoryDealManagement)
            nextVC.comingReason = .sellerReels
            nextVC.reelsData = self.viewModel.detailModel?.reels?[indexPath.row]
            self.navigationController?.pushViewController(nextVC, animated: true)
        } else {
            let nextVC = SellerReelsAndHighLightsViewController.instantiate(fromAppStoryboard: .LiveStoryDealManagement)
            nextVC.comingReason = .sellerHightLights
            nextVC.highlights = self.viewModel.detailModel?.highlights?[indexPath.row]
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == collectionReels {
            let spacing: CGFloat = 10
            let totalSpacing = spacing * 2 // 3 cells per row → 2 spaces between
            let width = (collectionReels.frame.width - totalSpacing) / 2
            return CGSize(width: width, height: 240)
        } else {
            let width = collectionHeighLights.frame.width / 5
            let height: CGFloat = 100
            return CGSize(width: width, height: height)
        }
    }
}

enum DetailTab:Int {
    case sellerInfo = 0,otherInfo
}
