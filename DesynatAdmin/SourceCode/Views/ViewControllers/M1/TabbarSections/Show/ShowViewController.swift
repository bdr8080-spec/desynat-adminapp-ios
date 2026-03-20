//
//  ShowViewController.swift
//  DesynatUser
//
//  Created by Rakhi Kumari on 24/10/25.
//

import UIKit

class ShowViewController: UIViewController {
    
    // MARK: - IBOutlet's
    
    @IBOutlet weak var countryLabel: CustomLabelFont!
    @IBOutlet weak var listTableView: UITableView! {
        didSet {
            listTableView.registerCellFromNib(cellID: "EventsTableViewCell")
        }
    }
    // MARK: - Property Decalaration
    private var isCountryExpanded : Bool = false
    private lazy var viewModel = ShowViewModel(hostVC: self)
    
    // MARK: - View's LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.getAllCountry()
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
        }
    }
    
    //MARK: Function's declaration
    
}

extension ShowViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventsTableViewCell", for: indexPath) as! EventsTableViewCell
        cell.onWatchLiveSelect = { [weak self] in
            let nextVC = SellerLiveViewController.instantiate(fromAppStoryboard: .Home)
            self?.navigationController?.pushViewController(nextVC, animated: true)
        }
        return cell
    }
    
    
}
