//
//  AddPlanViewController.swift
//  DesynatAdmin
//
//  Created by Meet Goti on 10/11/25.
//

import UIKit

class AddPlanViewController: UIViewController {
    @IBOutlet weak var viewCountryContainer: CustomView!
    @IBOutlet weak var lblSelectedCountry: CustomLabelFont!
    @IBOutlet weak var lnlFlag: CustomLabelFont!
    @IBOutlet weak var tblCountry: TableViewDynamicHeight!
    
    @IBOutlet weak var txtFieldEnglishPlanName: BindableTextField! {
        didSet {
            txtFieldEnglishPlanName.bind(callback: {self.viewModel.setPlanEnglishName($0)})
        }
    }
    @IBOutlet weak var txtFieldArabicPlanName: BindableTextField!{
        didSet {
            txtFieldArabicPlanName.bind(callback: {self.viewModel.setPlanArabicName($0)})
        }
    }
    @IBOutlet weak var txtFieldDuration: BindableTextField!{
        didSet {
            txtFieldDuration.bind(callback: {self.viewModel.setDuration($0)})
        }
    }
    @IBOutlet weak var lblDurationTyp: CustomLabelFont!
    @IBOutlet weak var viewDurationSeletion: UIView!
    @IBOutlet weak var txtFielNoVideos: BindableTextField! {
        didSet {
            txtFielNoVideos.bind(callback: {self.viewModel.setNoOfVideo($0)})
        }
    }
    @IBOutlet weak var txtFielNoHighlights: BindableTextField! {
        didSet {
            txtFielNoHighlights.bind(callback: {self.viewModel.setNoOfHighLights($0)})
        }
    }
    @IBOutlet weak var txtFielNoEmployee: BindableTextField! {
        didSet {
            txtFielNoEmployee.bind(callback: {self.viewModel.setNoOfEmployee($0)})
        }
    }
    @IBOutlet weak var txtFielNoProducts: BindableTextField!{
        didSet {
            txtFielNoProducts.bind(callback: {self.viewModel.setNoOfProducts($0)})
        }
    }
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var txtFieldPrice: BindableTextField! {
        didSet {
            txtFieldPrice.bind(callback: {self.viewModel.setPrice($0)})
        }
    }
    @IBOutlet weak var txtFieldComission: BindableTextField!{
        didSet {
            txtFieldComission.bind(callback: {self.viewModel.setComission($0)})
        }
    }
    
    @IBOutlet weak var btnAdd: CustomButton!
    @IBOutlet weak var btnOpen: CustomButton!
    @IBOutlet weak var btnClose: CustomButton!
    @IBOutlet weak var btnYes: CustomButton!
    @IBOutlet weak var btnNo: CustomButton!
    
    @IBOutlet weak var viewComission: UIView!
    private var isCountryExpanded : Bool = false
    private(set) var viewModel : AddSubscriptionPlansViewModel = AddSubscriptionPlansViewModel()
    private(set) var subscriptionInfo: PlanInfo = PlanInfo()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setUpUi()
        self.setData()
    }
    
    func setIntial(_ data:PlanInfo) {
        self.viewModel.setData(data)
    }
    
    func setCountry(_ country: GetCountryDataModel) {
        self.subscriptionInfo.country = country
    }

    private func setUpUi() {
        self.viewModel.setRefreshHandler(self)
        self.txtFieldArabicPlanName.delegate = self
        self.txtFieldEnglishPlanName.delegate = self
        self.tblCountry.register(CountryTableViewCell.self)
        self.tblCountry.dataSource = self
        self.tblCountry.delegate = self
        self.txtFieldDuration.delegate = self
        self.tblCountry.separatorStyle = .none
        self.lblTitle.text = self.viewModel.isForEdit ? "Update plan" : "Create New Plan"
        self.btnAdd.setTitle(self.viewModel.isForEdit ? "Update" : "Add", for: .normal)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.btnAdd.applyGradient(colours: [UIColor.init(hexString: "#DFBF8F"), UIColor.init(hexString: "#6E4527")],gradientDirection: .topToBottom,cornerRadius: 5)
        }
        self.lblDurationTyp.text = self.viewModel.subscriptionInfo.durationType.title
    }
    
    func setData() {
        self.viewModel.getAllCountry {
            self.refreshCountrySelection()
        }
        if (self.viewModel.isForEdit) {
            self.txtFieldEnglishPlanName.text = self.viewModel.subscriptionInfo.planNameEnglish
            self.txtFieldArabicPlanName.text = self.viewModel.subscriptionInfo.planNameArabic
            self.txtFieldDuration.text = String.getString(self.viewModel.subscriptionInfo.duration)
            self.txtFielNoVideos.text = String.getString(self.viewModel.subscriptionInfo.noOfVideos)
            self.txtFielNoProducts.text = String.getString(self.viewModel.subscriptionInfo.noOfProducts)
            self.txtFielNoHighlights.text = String.getString(self.viewModel.subscriptionInfo.noOfHighlights)
            self.txtFielNoEmployee.text = String.getString(self.viewModel.subscriptionInfo.noOfEmployee)
            self.txtFieldPrice.text = String.getString(self.viewModel.subscriptionInfo.price)
            self.txtFieldComission.text = String.getString(self.viewModel.subscriptionInfo.comission)
        }
        self.selectComission(self.viewModel.subscriptionInfo.isComission)
        self.viewComission.isHidden = !self.viewModel.subscriptionInfo.isComission
        self.selectStoryOpen(self.viewModel.subscriptionInfo.isStoryOpen)
    }
    func selectStoryOpen(_ bool:Bool) {
        self.btnOpen.setImage(bool ? .radioSelected : .radioUnselected, for: .normal)
        self.btnClose.setImage(!bool ? .radioSelected : .radioUnselected, for: .normal)
    }
    func selectComission(_ bool:Bool) {
        self.btnYes.setImage(bool ? .radioSelected : .radioUnselected, for: .normal)
        self.btnNo.setImage(!bool ? .radioSelected : .radioUnselected, for: .normal)
    }
    @IBAction func handleChooseCountry(_ sender: Any) {
        self.isCountryExpanded = !isCountryExpanded
        self.refreshCountrySelection()
    }
    
    @IBAction func handleDiscountTypeSelection(_ sender: Any) {
        CommonUtils.dropDown(dataSource: DurationType.allCases.filter({$0 != .none}).map({$0.title}), anchorView: self.viewDurationSeletion, selectedColor: .black) { index, item in
            self.viewModel.setDurationType(index)
            self.lblDurationTyp.text = self.viewModel.subscriptionInfo.durationType.title
        }
    }
    
    @IBAction func handleChooseStoryOption(_ sender: UIButton) {
        self.btnOpen.setImage(sender.tag == 0 ? .radioSelected : .radioUnselected, for: .normal)
        self.btnClose.setImage(sender.tag == 1 ? .radioSelected : .radioUnselected, for: .normal)
        self.viewModel.setStory(sender.tag == 0)
    }
    
    @IBAction func handleChooseComissionOption(_ sender: UIButton) {
        self.btnYes.setImage(sender.tag == 0 ? .radioSelected : .radioUnselected, for: .normal)
        self.btnNo.setImage(sender.tag == 1 ? .radioSelected : .radioUnselected, for: .normal)
        self.viewComission.isHidden = sender.tag == 1
        if (sender.tag == 1) {
            self.txtFieldComission.text = ""
        }
        self.viewModel.isComission(sender.tag == 0)
    }
    
    @IBAction func handleAdd(_ sender: Any) {
        let validationMessage = self.viewModel.subscriptionInfo.validateData()
        if (validationMessage != .none) {
            self.showAlert(msg: validationMessage.value())
            return
        }
        self.viewModel.makePlan {
            DispatchQueue.main.async {
                let vc = RegisterationSuccessViewController.instantiate(fromAppStoryboard: .Main)
                vc.setTitle(self.viewModel.isForEdit ? "Subscription plan updated\nsuccessfully!" : "Subscription plan added\nsuccessfully!")
                vc.callBackDismiss = {
                    self.navigationController?.popViewController(animated: true)
                }
                self.presentVC(vc,modalPresentationStyle: .overCurrentContext)
            }
        }
    }

    
    @IBAction func handleBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func refreshCountrySelection() {
        if let countryListData = viewModel.subscriptionInfo.country {
            self.lblSelectedCountry.text = String.getString(countryListData.name)
            self.lnlFlag.text = String.getString(countryListData.flag)
        } else {
            self.lblSelectedCountry.text = ""
        }
        self.lnlFlag.isHidden = !self.isCountryExpanded
        self.viewCountryContainer.isHidden = !self.isCountryExpanded
    }

}
extension AddPlanViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.countryListData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if  let cell = tableView.dequeueReusableCell(withIdentifier: "CountryTableViewCell", for: indexPath) as? CountryTableViewCell {
            let data = viewModel.countryListData[indexPath.row]
            cell.configData(data: data,isSelected: (Int.getInt(self.viewModel.subscriptionInfo.country?.id) - 1) == indexPath.row)
            return cell
        }
        return .init(frame: .zero)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (self.viewModel.countryListData.count > indexPath.row) {
            let data = viewModel.countryListData[indexPath.row]
            self.viewModel.setCountry(data)
            self.isCountryExpanded = false
            self.refreshCountrySelection()
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        viewWillLayoutSubviews()
    }
    
}
extension AddPlanViewController :HandleTableRefresh {
    func refreshTable(for string: String) {
        self.tblCountry.reloadData()
        
    }
}
extension AddPlanViewController:UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var validation: StringValidation?
        let currentText = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        if string.isEmpty {
            return true
        }
        var newText = textField.text ?? ""
        newText = string.isEmpty ? String(newText.dropLast()) : newText + string
        if (textField == self.txtFieldArabicPlanName) {
            if currentText.hasPrefix(" "){
                return false
            }
            // Define the set of English letters to block
            let englishLetters = CharacterSet.lowercaseLetters.union(CharacterSet.uppercaseLetters)
            
            // Check if the replacement string contains any English letters
            if string.rangeOfCharacter(from: englishLetters) != nil {
                self.showAlert(msg: "Plese enter arabic letter.")
                return false
            }
        } else if (textField == self.txtFieldEnglishPlanName) {
            if currentText.hasPrefix(" "){
                return false
            }
            //validation = StringValidation(string: currentText, characterCount: 30, validation: .firstName)
        } else if (textField == self.txtFieldDuration) {
            if currentText.hasPrefix(" "){
                return false
            }
            validation = StringValidation(string: currentText, characterCount: 2, validation: .mobileNo)
        }
        if let data = validation {
            return data.validate()
        } else {
            return true
        }
    }
}
