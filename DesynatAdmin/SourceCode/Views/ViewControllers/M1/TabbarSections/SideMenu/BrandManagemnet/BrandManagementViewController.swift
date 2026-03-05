//
//  BrandManagementViewController.swift
//  DesynatAdmin
//
//  Created by Rakhi Kumari on 31/10/25.
//

import UIKit

class BrandManagementViewController: UIViewController {
    
    // MARK: - IBOutlet's
    @IBOutlet weak var noDataFoundLabel: UILabel!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var pageCountLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var brandTableView: UITableView! {
        didSet {
            brandTableView.registerCellFromNib(cellID: "BrandManagementTableViewCell")
        }
    }
    
    // MARK: - Property Decalaration
    private lazy var viewModel = BrandViewModel(hostVC: self)
    private var searchWorkItem: DispatchWorkItem?
    
    // MARK: - View's LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTextField.delegate = self
        updatePaginationButtonImages()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.currentPage = 1
        viewModel.getAllBrands()
    }
    
    // MARK: - Button's Action
    @IBAction func backDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func plusDidTapped(_ sender: Any) {
        let vc = AddNewBrandViewController.instantiate(fromAppStoryboard: .SideMenu)
        vc.isComingForEdit = false
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    @IBAction func nextButtonAction(_ sender: Any) {
        viewModel.goToNextPage()
    }
    
    @IBAction func previousButtonAction(_ sender: Any) {
        viewModel.goToPreviousPage()
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
extension BrandManagementViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.brandListData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BrandManagementTableViewCell", for: indexPath) as! BrandManagementTableViewCell
        let data = viewModel.brandListData[indexPath.row]
        cell.configData(data: data)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 178
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = BrandDetailsViewController.instantiate(fromAppStoryboard: .SideMenu)
        vc.brandData = viewModel.brandListData[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
}

//MARK: UITextFieldDelegate Methods
extension BrandManagementViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
        
        // Cancel previous search work item
        searchWorkItem?.cancel()
        
        // Create new one
        let workItem = DispatchWorkItem { [weak self] in
            guard let self = self else { return }
            self.viewModel.searchText = currentText
            self.viewModel.currentPage = 1
            self.viewModel.getAllBrands()
        }
        
        // Store and execute after delay
        searchWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: workItem)
        
        return true
    }
}
