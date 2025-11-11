//
//  CountryCityListViewController.swift
//  DesynatAdmin
//
//  Created by Meet Goti on 10/11/25.
//

import UIKit
enum CountryCityListTableType:String {
    case country,cities
}
class CountryCityListViewController: UIViewController {
    @IBOutlet weak var viewCountryContainer: CustomView!
    @IBOutlet weak var lblSelectedCountry: CustomLabelFont!
    @IBOutlet weak var lblNodata: UILabel!
    @IBOutlet weak var tblCountry: TableViewDynamicHeight!
    @IBOutlet weak var lnlFlag: CustomLabelFont!
    @IBOutlet weak var tblCities: UITableView!
    
    @IBOutlet weak var lblPageCount: UILabel!
    @IBOutlet weak var btnPreviousPage: UIButton!
    @IBOutlet weak var btnNextPage: UIButton!
    
    @IBOutlet weak var txtFielSearch: BindableTextField! {
        didSet {
            txtFielSearch.bind(callback: {self.viewModel.setSearch($0)})
        }
    }
    
    private var viewModel : CountryCityViewModel = CountryCityViewModel()
    private var isCountryExpanded : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpUi()
        self.setData()
    }
    private func setUpUi() {
        self.viewModel.setRefreshHandler(self,cityActionHandler: self)

        self.tblCities.register(ServiceCitiesTableViewCell.self)
        self.tblCities.delegate = self
        self.tblCities.dataSource = self
        self.tblCities.separatorStyle = .none
        
        self.tblCountry.register(CountryTableViewCell.self)
        self.tblCountry.dataSource = self
        self.tblCountry.delegate = self
        self.tblCountry.separatorStyle = .none
        
        self.refreshPageActionButton()
    }
    
    func setData() {
        self.viewModel.getAllCountry {
            self.refreshCountrySelection()
        }
    }
    
    private func refreshPageActionButton() {
        self.btnNextPage.setImage(self.viewModel.isLastPage ? .lightnextimage : .nextRight, for: .normal)
        self.btnNextPage.isUserInteractionEnabled = !self.viewModel.isLastPage
        self.btnPreviousPage.setImage(self.viewModel.isFirstPage ? .previousLeft : .darkpreviousimage, for: .normal)
        self.btnPreviousPage.isUserInteractionEnabled = !self.viewModel.isFirstPage
        self.lblPageCount.text = "\(self.viewModel.currentPage < 10 ? "0" : "")\(self.viewModel.currentPage) of \(self.viewModel.totalPage < 10 ? "0" : "")\(self.viewModel.totalPage)"
    }
    
    private func refreshCountrySelection() {
        if let countryListData = viewModel.selectedCountry {
            self.lblSelectedCountry.text = String.getString(countryListData.name)
            self.lnlFlag.text = String.getString(countryListData.flag)
        } else {
            self.lblSelectedCountry.text = ""
        }
        self.lnlFlag.isHidden = !self.isCountryExpanded
        self.viewCountryContainer.isHidden = !self.isCountryExpanded
    }
    
    @IBAction func handleAddCity(_ sender: UIButton) {
        let vc = SelectCitiesViewController.viewFromNIB
        vc.setCountry(String.getString(self.viewModel.selectedCountry?.id)) { cityId in
            self.viewModel.addCity(id: cityId) {
                self.viewModel.getCities()
            }
        }
        self.presentVC(vc,withAnimation: false,modalPresentationStyle: .overCurrentContext)
    }
    
    
    @IBAction func handleChooseCountry(_ sender: UIButton) {
        self.isCountryExpanded = !isCountryExpanded
        self.refreshCountrySelection()
    }

    @IBAction func handleNextPage(_ sender: UIButton) {
        self.viewModel.changePage(false)
        self.refreshPageActionButton()
    }
    
    @IBAction func handlePreviousPage(_ sender: UIButton) {
        self.viewModel.changePage(true)
        self.refreshPageActionButton()
    }
    @IBAction func handleBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
}
extension CountryCityListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableView == self.tblCities ? self.viewModel.arrayCities.count : viewModel.countryListData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView {
        case tblCities:
            if  let cell = self.tblCities.dequeueReusableCell(withIdentifier: ServiceCitiesTableViewCell.defaultIdentifier, for: indexPath) as? ServiceCitiesTableViewCell {
                if viewModel.arrayCities.count > indexPath.row {
                    cell.setCity(viewModel.arrayCities[indexPath.row])
                }
                cell.selectionStyle = .none
                return cell
            }
        case tblCountry:
            if  let cell = tableView.dequeueReusableCell(withIdentifier: "CountryTableViewCell", for: indexPath) as? CountryTableViewCell {
                let data = viewModel.countryListData[indexPath.row]
                cell.selectionStyle = .none
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
        case tblCities:
//            if (self.viewModel.arrayPlans.count > indexPath.row) {
//                let vc = SubscriptionDetailViewController.viewFromNIB
//                vc.setVM(SubscriptionDetailViewModel(data: viewModel.arrayPlans[indexPath.row]))
//                self.navigate(to: vc)
//            }
            break
        case tblCountry:
            if (self.viewModel.countryListData.count > indexPath.row) {
                let data = viewModel.countryListData[indexPath.row]
                self.viewModel.setCountry(data)
                self.txtFielSearch.text = ""
                self.refreshCountrySelection()
            }
        default:
            break
        }
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        viewWillLayoutSubviews()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView == self.tblCities ? 76 : UITableView.automaticDimension
    }
    
}
extension CountryCityListViewController:HandleTableRefresh {
    func refreshTable(for string: String) {
        if let type = CountryCityListTableType(rawValue: string) {
            switch type {
            case .country:
                self.tblCountry.reloadData()
            case .cities:
                self.refreshPageActionButton()
                self.lblNodata.isHidden = self.viewModel.arrayCities.count > 0
                self.tblCities.reloadData()
            }
        }
    }
}
extension CountryCityListViewController:HandleCityAction {
    func viewZone(_ data: CitiesInfo) {
        let vc = CityZoneListViewController.viewFromNIB
        var dd = data
        dd.countryName = String.getString(self.viewModel.selectedCountry?.name)
        vc.setCity(dd)
        self.navigate(to: vc)
    }
    
    func deleteCity(_ data: CitiesInfo) {
        self.showConfirmationAlert(msg: "Are you sure want\nto delete this city?") {
            self.viewModel.deleteCity(id: data.id) {
                let vc = RegisterationSuccessViewController.instantiate(fromAppStoryboard: .Main)
                vc.setTitle("City deleted\nsuccessfully!")
                vc.callBackDismiss = {
                    self.viewModel.getCities()
                }
                self.presentVC(vc,modalPresentationStyle: .overCurrentContext)
            }
        }
    }
    
    func setActiveCity(_ data: CitiesInfo) {
        self.viewModel.changeCityStatus(id: data.id) {
            self.viewModel.getCities()
        }
    }
}
