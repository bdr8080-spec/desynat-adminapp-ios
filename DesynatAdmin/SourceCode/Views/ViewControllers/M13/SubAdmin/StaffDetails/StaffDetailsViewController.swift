//
//  StaffDetailsViewController.swift
//  DesynatDealer
//
//  Created by  shailendra singh on 26/03/26.
//

import UIKit

class StaffDetailsViewController: UIViewController {
    
    // MARK: - IBOutlet
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
    
    // MARK: - Variable
    var isActive: Bool = false
    var isSecureTextEntry: Bool = true
    var originalPassword: String = ""
    var selectedRow: Int?
    var moduleNames = ["Dashboard", "Orders", "Users", "Reports", "Settings"]
    var moduleSelctedData: [ModulSelctedData] = []
    var staffDetails: StaffDetails?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Navigation
    
    @IBAction func backBtnTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func editProfileBtntapped(_ sender: Any) {
        let vc = AddNewStaffViewController.instantiate(fromAppStoryboard: .NotificationCMS)
        vc.comingReason = .editStaff
        vc.staffDetails = staffDetails
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func activeStatusBtnTapped(_ sender: Any) {
        isActive.toggle()
        let imageName: String = isActive ? "toggle_on": "toggle_off"
        activeStatusbtn.setImage(UIImage(named: imageName), for: .normal)
    }
    
    @IBAction func deleteDidTapped(_ sender: Any) {
//        guard let gift = bannerListData else { return }
        self.showConfirmationAlert(msg: "Are you sure you want to delete this sub admin?"){ [weak self] in
            guard let self = self else { return }
//            let param:[String:Any] = ["banner_id": bannerId]
//            viewModel.deletePromtoionalBanner(param: param)
        }
    }
    
}
extension StaffDetailsViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moduleNames.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AccessModuleTableViewCell",for: indexPath) as! AccessModuleTableViewCell
        let moduleId = indexPath.row + 1
        cell.titleView.text = moduleNames[indexPath.row]
        cell.moduleId = moduleId
        cell.viewSelected = false
        cell.actionSelected = false
        cell.isRowSelected = false
        cell.radioimageView.image = .radioUnselected
        if let data = moduleSelctedData.first(where: { $0.moduleId == moduleId }) {
            cell.isRowSelected = true
            cell.viewSelected = data.viewSelcted == 1
            cell.actionSelected = data.actionIsSelected == 1
            cell.radioimageView.image = .radioSelected
        }
        cell.selectionUpdated = { [weak self] moduleId, view, action in
            self?.updateSelection(moduleId: moduleId,viewSelected: view,actionSelected: action)
        }
        cell.collectionView.reloadData()
        return cell
    }
    
    func tableView(_ tableView: UITableView,didSelectRowAt indexPath: IndexPath) {
        let moduleId = indexPath.row + 1
        if let index = moduleSelctedData.firstIndex(where: { $0.moduleId == moduleId }) {
            moduleSelctedData.remove(at: index)
        } else {
            let obj = ModulSelctedData(moduleId: moduleId,viewSelcted: 1,actionIsSelected: 0)
            moduleSelctedData.append(obj)
        }
        tableView.reloadRows(at: [indexPath], with: .none)
    }
    
    func updateSelection(moduleId: Int, viewSelected: Bool, actionSelected: Bool) {
        if let index = moduleSelctedData.firstIndex(where: { $0.moduleId == moduleId }) {
            if viewSelected == false && actionSelected == false {
                moduleSelctedData.remove(at: index)
            } else {
                moduleSelctedData[index].viewSelcted = viewSelected ? 1 : 0
                moduleSelctedData[index].actionIsSelected = actionSelected ? 1 : 0
            }
        } else {
            if viewSelected || actionSelected {
                let obj = ModulSelctedData(moduleId: moduleId,viewSelcted: viewSelected ? 1 : 0,actionIsSelected: actionSelected ? 1 : 0)
                moduleSelctedData.append(obj)
            }
        }
        let indexPath = IndexPath(row: moduleId - 1, section: 0)
        accessModuleTableView.reloadRows(at: [indexPath], with: .none)
    }
}
