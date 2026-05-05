//
//  ShowViewController.swift
//  DesynatUser
//
//  Created by Rakhi Kumari on 24/10/25.
//

import UIKit

class ShowViewController: UIViewController {
    
    // MARK: - IBOutlet's
    @IBOutlet weak var noDataFoundLabel: UILabel!
    @IBOutlet weak var countryLabel: CustomLabelFont!
    @IBOutlet weak var listTableView: UITableView! {
        didSet {
            listTableView.registerCellFromNib(cellID: "EventsTableViewCell")
        }
    }
    @IBOutlet weak var backButton: RTLButton!
    
    // MARK: - Property Decalaration
    private var isCountryExpanded : Bool = false
    private lazy var viewModel = ShowViewModel(hostVC: self)
    var hasActionPermission: Bool = true
    var comingFromTabbar: Bool = true
    
    // MARK: - View's LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.getAllCountry()
        backButton.isHidden = comingFromTabbar
    }
    
    @IBAction func backDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Button's Action
    @IBAction func handleChooseCountry(_ sender: UIButton) {
        let countryNames = viewModel.countryListData.map { country -> String in
            let name = country.name ?? ""
            let dialCode = country.dialCode ?? ""
            let flag = country.flag ?? "🇰🇼"
            return "\(flag)  \(name) (\(dialCode))"
        }
        
        kSharedAppDelegate.dropDown(dataSource: countryNames, anchorView: sender) { index, item in
            let selectedCountry = self.viewModel.countryListData[index]
            self.countryLabel.text = selectedCountry.name
            self.viewModel.adminAllLiveRequest(countryId: selectedCountry.id ?? 0)
        }
    }
    
    //MARK: Function's declaration
    
}

extension ShowViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.liveEventListData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventsTableViewCell", for: indexPath) as! EventsTableViewCell
        cell.configData(data: viewModel.liveEventListData[indexPath.row])
        cell.onWatchLiveSelect = { [weak self] in
            self?.viewModel.generateLiveStramingTokenRequest(id: self?.viewModel.liveEventListData[indexPath.row].id ?? 0)
        }
        return cell
    }
    
}
