//
//  SubscriptionPlanListViewController.swift
//  DesynatAdmin
//
//  Created by Meet Goti on 10/11/25.
//

import UIKit

class SubscriptionPlanListViewController: UIViewController, PermissionAccessible {
    
    // MARK: - IBOutlet's
    @IBOutlet weak var viewCountryContainer: CustomView!
    @IBOutlet weak var lblSelectedCountry: CustomLabelFont!
    @IBOutlet weak var lblNodata: UILabel!
    @IBOutlet weak var tblCountry: TableViewDynamicHeight!
    @IBOutlet weak var lnlFlag: CustomLabelFont!
    @IBOutlet weak var tblPlans: UITableView!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var backButton: RTLButton!
    
    // MARK: - Property Decalaration
    private var viewModel : SubscriptionPlanViewModel = SubscriptionPlanViewModel()
    private var isCountryExpanded : Bool = false
    var hasActionPermission: Bool = true
    var commingFromTabbar: Bool = true
    
    // MARK: - View's LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpUi()
        plusButton.isHidden = !hasActionPermission
        backButton.isHidden = commingFromTabbar
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.setData()
    }
    
    @IBAction func backDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Button's Action
    @IBAction func handleAddPlan(_ sender: Any) {
        //self.navigate(to: AddPlanViewController.viewFromNIB)
        let vc = AddPlanViewController.viewFromNIB
        if let selected = self.viewModel.selectedCountry {
            vc.viewModel.setCountry(selected)
        }
        self.navigate(to: vc)
    }
    
    @IBAction func handleChooseCountry(_ sender: Any) {
        self.isCountryExpanded = !isCountryExpanded
        self.refreshCountrySelection()
    }
    
    //MARK: Function's declaration
    func refreshCountrySelection() {
        if let countryListData = viewModel.selectedCountry {
            if AppLanguageManager.shared.currentLanguage == .ar {
                self.lblSelectedCountry.text = String.getString(countryListData.nameAr)
            }else {
                self.lblSelectedCountry.text = String.getString(countryListData.name)
            }
            self.lnlFlag.text = String.getString(countryListData.flag)
        } else {
            self.lblSelectedCountry.text = ""
        }
        self.lnlFlag.isHidden = !self.isCountryExpanded
        self.viewCountryContainer.isHidden = !self.isCountryExpanded
    }
    
    private func setUpUi() {
        self.viewModel.setRefreshHandler(self)
        self.tblCountry.register(CountryTableViewCell.self)
        self.tblPlans.register(PlansTableViewCell.self)
        self.tblPlans.delegate = self
        self.tblPlans.dataSource = self
        self.tblPlans.separatorStyle = .none
        self.tblCountry.dataSource = self
        self.tblCountry.delegate = self
        self.tblCountry.separatorStyle = .none
    }
    
    func setData() {
        self.viewModel.getAllCountry {
            self.refreshCountrySelection()
        }
    }
}

// MARK: - TABLE VIEW METHODS
extension SubscriptionPlanListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableView == self.tblPlans ? self.viewModel.arrayPlans.count : viewModel.countryListData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView {
        case tblPlans:
            if  let cell = tableView.dequeueReusableCell(withIdentifier: PlansTableViewCell.defaultIdentifier, for: indexPath) as? PlansTableViewCell {
                if viewModel.arrayPlans.count > indexPath.row {
                    cell.setData(viewModel.arrayPlans[indexPath.row])
                    cell.applyGradientForIndex(indexPath.row)
                }
                cell.selectionStyle = .none
                return cell
            }
        case tblCountry:
            if  let cell = tableView.dequeueReusableCell(withIdentifier: "CountryTableViewCell", for: indexPath) as? CountryTableViewCell {
                let data = viewModel.countryListData[indexPath.row]
                cell.configData(data: data,isSelected: (Int.getInt(self.viewModel.selectedCountry?.id) - 1) == indexPath.row)
                return cell
            }
        default:
            break
        }
        
        return .init(frame: .zero)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch tableView {
        case tblPlans:
            if (self.viewModel.arrayPlans.count > indexPath.row) {
                let vc = SubscriptionDetailViewController.viewFromNIB
                vc.setVM(SubscriptionDetailViewModel(data: viewModel.arrayPlans[indexPath.row]))
                vc.hasActionPermission = hasActionPermission
                self.navigate(to: vc)
            }
        case tblCountry:
            if (self.viewModel.countryListData.count > indexPath.row) {
                let data = viewModel.countryListData[indexPath.row]
                self.viewModel.setCountry(data)
                self.isCountryExpanded = false
                self.refreshCountrySelection()
            }
        default:
            break
        }
        
    }
}
extension SubscriptionPlanListViewController:HandleTableRefresh {
    func refreshTable(for string: String) {
        if let type = SubscriptionTableType(rawValue: string) {
            switch type {
            case .country:
                self.tblCountry.reloadData()
            case .plans:
                self.lblNodata.isHidden = self.viewModel.arrayPlans.count > 0
                self.tblPlans.reloadData()
            }
        }
    }
}
