//
//  SelectCitiesViewController.swift
//  DesynatAdmin
//
//  Created by Meet Goti on 11/11/25.
//

import UIKit

class SelectCitiesViewController: UIViewController {
    
    @IBOutlet weak var noDataFoundLabel: UILabel!
    @IBOutlet weak var selcectCityDropDownView: UIView!
    @IBOutlet weak var viewCityContainer: CustomView!
    @IBOutlet weak var lblSelectedCity: CustomLabelFont!
    @IBOutlet weak var viewMain: CustomView!
    @IBOutlet weak var tblCities: TableViewDynamicHeight!
    @IBOutlet weak var btnSubmit: CustomButton!
    
    private var isCityExpanded : Bool = false
    private var viewModel : SelectCityViewModel = SelectCityViewModel()
    private var callCackFromSelection:((String) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpUi()
        self.setData()
    }
    
    func setCountry(_ id:String,callCackFromSelection:@escaping ((String) -> Void))  {
        self.callCackFromSelection = callCackFromSelection
        self.viewModel.setCountryId(id)
    }
    
    private func setUpUi() {
        self.viewModel.setRefreshHandler(self)
        self.viewMain.borderRadiusWithCornerMask(radius: 24,cornerMask: [.layerMinXMinYCorner,.layerMaxXMinYCorner])
        self.tblCities.register(CountryTableViewCell.self)
        self.tblCities.dataSource = self
        self.tblCities.delegate = self
        self.tblCities.separatorStyle = .none
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.btnSubmit.applyGradient(colours: [UIColor.init(hexString: "#DFBF8F"), UIColor.init(hexString: "#6E4527")],gradientDirection: .topToBottom,cornerRadius: 5)
        }
    }
//    func setData() {
//        self.viewModel.getAllCities {
//            self.refreshCitySelection()
//        }
//    }
    
    func setData() {
        self.viewModel.getAllCities {
            self.updateNoDataUI()
            self.refreshCitySelection()
        }
    }
    
    private func updateNoDataUI() {
        let isEmpty = viewModel.citiesListData.isEmpty

        self.selcectCityDropDownView.isHidden = isEmpty
        self.btnSubmit.isHidden = isEmpty
        self.noDataFoundLabel.isHidden = !isEmpty
    }

    
    private func refreshCitySelection() {
        if let countryListData = viewModel.selectedCity {
            self.lblSelectedCity.text = String.getString(countryListData.name)
            self.lblSelectedCity.text = "Select"
            self.lblSelectedCity.textColor = .black
        } else {
            self.lblSelectedCity.text = "Select"
            self.lblSelectedCity.textColor = .black.withAlphaComponent(0.5)
        }
        self.viewCityContainer.isHidden = !self.isCityExpanded
    }
    
    @IBAction func handleClose(_ sender: Any) {
        self.dismiss(animated: false)
    }
    
    @IBAction func handleCitySelection(_ sender: Any) {
        isCityExpanded = !isCityExpanded
        self.refreshCitySelection()
    }
    
    @IBAction func handleSubmit(_ sender: Any) {
        guard let selectedCity = viewModel.selectedCity else {
            self.showAlert(msg: "Please select city")
            return
        }
        self.callCackFromSelection?(String.getString(viewModel.selectedCity?.id))
        self.dismiss(animated: false)
    }
}
extension SelectCitiesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.citiesListData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CountryTableViewCell", for: indexPath) as! CountryTableViewCell
        let data = viewModel.citiesListData[indexPath.row]
        cell.configCityData(data: data,isSelected: Int.getInt(self.viewModel.selectedCity?.id) == data.id)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (self.viewModel.citiesListData.count > indexPath.row) {
            self.viewModel.setCities(viewModel.citiesListData[indexPath.row])
            self.refreshCitySelection()
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        viewWillLayoutSubviews()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        42
    }
    
}

extension SelectCitiesViewController:HandleTableRefresh {
    func refreshTable(for string: String) {
        self.tblCities.reloadData()
    }
    
    
}
