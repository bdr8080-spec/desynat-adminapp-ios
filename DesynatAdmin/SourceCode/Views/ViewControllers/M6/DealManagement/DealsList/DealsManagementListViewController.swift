//
//  DealsManagementListViewController.swift
//  DesynatAdmin
//
//  Created by fluper on 07/01/26.
//

import UIKit

class DealsManagementListViewController: UIViewController {
    
    // MARK: - IBOutlet's
    @IBOutlet weak var searchTF: BindableTextField!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var pageCountLabel: UILabel!
    @IBOutlet weak var activeButtonOutlet: CustomButton!
    @IBOutlet weak var expiredButtonOutlet: CustomButton!
    @IBOutlet weak var expiredLabel: UILabel!
    @IBOutlet weak var activeLabel: UILabel!
    @IBOutlet weak var noDataFoundLabel: UILabel!
    @IBOutlet weak var dealsTableview: UITableView! {
        didSet {
            dealsTableview.registerCellFromNib(cellID: "DealsManagementListTableViewCell")
        }
    }
    
    // MARK: - Property Decalaration
    var type: Int = 1
    private lazy var viewModel = DealsManagementListViewModel(hostVC: self)
    private var searchWorkItem: DispatchWorkItem?
    var hasActionPermission: Bool = false
    
    // MARK: - View's LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTF.delegate = self
        updatePaginationButtonImages()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.currentPage = 1
        if type == 1 {
            viewModel.getActiveDeals()
        } else {
            viewModel.getExpiredDeals()
        }
    }
    
    // MARK: - Button's Action
    @IBAction func backDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func activedidTapped(_ sender: Any) {
        activeButtonOutlet.setImage(UIImage(named: "btnGradient"), for: .normal)
        activeLabel.textColor = UIColor.white
        expiredButtonOutlet.setImage(UIImage(named: ""), for: .normal)
        expiredLabel.textColor = UIColor.black
        type = 1
        viewModel.currentPage = 1
        searchTF.text = ""
        viewModel.getActiveDeals()
    }
    
    @IBAction func expiredDidTapped(_ sender: Any) {
        activeButtonOutlet.setImage(UIImage(named: ""), for: .normal)
        activeLabel.textColor = UIColor.black
        expiredButtonOutlet.setImage(UIImage(named: "btnGradient"), for: .normal)
        expiredLabel.textColor = UIColor.white
        type = 2
        viewModel.currentPage = 1
        searchTF.text = ""
        viewModel.getExpiredDeals()
    }
    
    @IBAction func serchDidTapped(_ sender: Any) {
    }
    
    @IBAction func plusDidTapped(_ sender: Any) {
        let nextVC = AddDealViewController.instantiate(fromAppStoryboard: .LiveStoryDealManagement)
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @IBAction func nextDidTapped(_ sender: Any) {
        viewModel.goToNextPage(type: type)
    }
    
    @IBAction func previousDidTapped(_ sender: Any) {
        viewModel.goToPreviousPage(type: type)
    }
    
    //MARK: Function's declaration
    func updatePaginationButtonImages() {
        // Previous Button
        if viewModel.currentPage == 1 {
            previousButton.setImage(UIImage(named: "previousLeft"), for: .normal)
            previousButton.isUserInteractionEnabled = false
        } else {
            previousButton.setImage(UIImage(named: "darkpreviousimage"), for: .normal)
            previousButton.isUserInteractionEnabled = true
        }
        
        // Next Button
        if viewModel.currentPage >= viewModel.totalPages {
            nextButton.setImage(UIImage(named: "lightnextimage"), for: .normal)
            nextButton.isUserInteractionEnabled = false
        } else {
            nextButton.setImage(UIImage(named: "nextRight"), for: .normal)
            nextButton.isUserInteractionEnabled = true
        }
    }
    
}

// MARK: - TABLE VIEW METHODS
extension DealsManagementListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.reasonListData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DealsManagementListTableViewCell", for: indexPath) as! DealsManagementListTableViewCell
        let data = viewModel.reasonListData[indexPath.row]
        cell.configData(data: data)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nextVC = DealDetailsViewController.instantiate(fromAppStoryboard: .LiveStoryDealManagement)
        nextVC.type = type
        nextVC.dealId = viewModel.reasonListData[indexPath.row].id ?? 0
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
}

//MARK: UITextFieldDelegate Methods
extension DealsManagementListViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
        searchWorkItem?.cancel()
        let workItem = DispatchWorkItem { [weak self] in
            guard let self = self else { return }
            self.viewModel.searchText = currentText
            self.viewModel.currentPage = 1
            if type == 1 {
                self.viewModel.getActiveDeals()
            } else {
                self.viewModel.getExpiredDeals()
            }
        }
        searchWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: workItem)
        return true
    }
}
