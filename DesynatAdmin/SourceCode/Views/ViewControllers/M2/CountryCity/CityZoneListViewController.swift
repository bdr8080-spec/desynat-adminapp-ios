//
//  CityZoneListViewController.swift
//  DesynatAdmin
//
//  Created by Meet Goti on 11/11/25.
//

import UIKit

class CityZoneListViewController: UIViewController {
    
    // MARK: - IBOutlet's
    @IBOutlet weak var lblNodata: UILabel!
    @IBOutlet weak var tblZones: UITableView!
    @IBOutlet weak var txtFielSearch: BindableTextField! {
        didSet {
            txtFielSearch.bind(callback: {self.viewModel.setSearch($0)})
        }
    }
    @IBOutlet weak var plusButon: UIButton!
    
    // MARK: - Property Decalaration
    private var viewModel : ZoneViewModel = ZoneViewModel()
    var hasActionPermission: Bool = false
    
    // MARK: - View's LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpUi()
        plusButon.isHidden = !hasActionPermission
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.viewModel.getZones()
    }
    
    // MARK: - Button's Action
    @IBAction func handleBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func handleAddZone(_ sender: Any) {
        let vc = AddZoneViewController.viewFromNIB
        if let cityInfo = self.viewModel.cityInfo {
            vc.setCityData(cityInfo)
        }
        self.navigate(to: vc)
    }
    
    //MARK: Function's declaration
    func setCity(_ cityInfo:CitiesInfo)  {
        self.viewModel.setCity(cityInfo)
    }
    
    private func setUpUi() {
        self.viewModel.setRefreshHandler(self,zoneActionHandler: self)
        self.tblZones.register(ServiceCitiesTableViewCell.self)
        self.tblZones.delegate = self
        self.tblZones.dataSource = self
        self.tblZones.separatorStyle = .none
    }
}

// MARK: - TABLE VIEW METHODS
extension CityZoneListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.arrayZone.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if  let cell = self.tblZones.dequeueReusableCell(withIdentifier: ServiceCitiesTableViewCell.defaultIdentifier, for: indexPath) as? ServiceCitiesTableViewCell {
            if viewModel.arrayZone.count > indexPath.row {
                cell.setZone(viewModel.arrayZone[indexPath.row])
            }
            cell.btnSwitch.isUserInteractionEnabled = hasActionPermission
            cell.btnEdit.isHidden = !hasActionPermission
            cell.btnDelete.isHidden = !hasActionPermission
            cell.selectionStyle = .none
            return cell
        }
        
        return .init(frame: .zero)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //        viewWillLayoutSubviews()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        76
    }
    
}
extension CityZoneListViewController:HandleTableRefresh {
    func refreshTable(for string: String) {
        self.lblNodata.isHidden = self.viewModel.arrayZone.count > 0
        self.tblZones.reloadData()
    }
}
extension CityZoneListViewController:HandleZoneAction {
    
    func viewLocation(_ data: ZoneInfo) {
        let vc = AddZoneViewController.viewFromNIB
        
        vc.setData(data)
        vc.setTitle("View".localiz(),isForView: true)
        self.navigate(to: vc)
    }
    
    func editZone(_ data: ZoneInfo) {
        let vc = AddZoneViewController.viewFromNIB
        vc.setData(data,isForEdit: true)
        if var cityInfo = self.viewModel.cityInfo {
            vc.setCityData(cityInfo)
        }
        
        vc.setTitle("Edit Zone".localiz())
        self.navigate(to: vc)
    }
    
    func deleteZone(_ data: ZoneInfo) {
        self.showConfirmationAlert(msg: "Are you sure want\nto delete this zone?".localiz()) {
            self.viewModel.deleteZone(id: data.id) {
                let vc = RegisterationSuccessViewController.instantiate(fromAppStoryboard: .Main)
                vc.setTitle("Zone deleted\nsuccessfully!".localiz())
                vc.callBackDismiss = {
                    self.viewModel.getZones()
                }
                self.presentVC(vc,modalPresentationStyle: .overCurrentContext)
            }
        }
    }
    
    func setActiveZone(_ data: ZoneInfo) {
        self.viewModel.changeZoneStatus(id: data.id) {
            self.viewModel.getZones()
        }
    }
}

