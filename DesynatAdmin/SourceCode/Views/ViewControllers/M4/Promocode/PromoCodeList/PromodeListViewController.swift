//
//  PromodeListViewController.swift
//  DesynatAdmin
//
//  Created by fluper on 09/12/25.
//

import UIKit

class PromodeListViewController: UIViewController {
    
    // MARK: - IBOutlet's
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var pageCountLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var noDataFoundLabel: UILabel!
    @IBOutlet weak var promocdeTableView: UITableView! {
        didSet {
            promocdeTableView.registerCellFromNib(cellID: "PromoCodeTableViewCell")
        }
    }
    
    // MARK: - Property Decalaration
    private lazy var viewModel = PromodeListViewModel(hostVC: self)
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
        viewModel.getAllPromocode()
    }
    
    // MARK: - Button's Action
    @IBAction func backDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func plusDidTapped(_ sender: Any) {
        let nextVC = AddPromocodeViewController.instantiate(fromAppStoryboard: .ShippingPromocode)
        nextVC.isComingForEdit = false
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @IBAction func filterDidTapped(_ sender: Any) {
        let vc = PromocodeFilterViewController.instantiate(fromAppStoryboard: .ShippingPromocode)
        vc.allowPastDates = false
        vc.selectedFilter = viewModel.appliedFilter
        vc.onApplyFilter = { [weak self] filter in
            guard let self = self else { return }
            self.viewModel.appliedFilter = filter
            self.viewModel.currentPage = 1
            self.viewModel.getAllPromocode()
        }
        vc.onClearFilter = { [weak self] in
            guard let self = self else { return }
            self.viewModel.appliedFilter = UserFilterModel()
            self.viewModel.currentPage = 1
            self.viewModel.getAllPromocode()
        }
        self.navigationController?.present(vc, animated: true)
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
extension PromodeListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.promocodeListData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PromoCodeTableViewCell", for: indexPath) as! PromoCodeTableViewCell
        let data = viewModel.promocodeListData[indexPath.row]
        cell.configureData(data: data)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nextVC = PromocodeDetailsViewController.instantiate(fromAppStoryboard: .ShippingPromocode)
        nextVC.promocodeDetails = viewModel.promocodeListData[indexPath.row]
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
}

//MARK: UITextFieldDelegate Methods
extension PromodeListViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
        searchWorkItem?.cancel()
        let workItem = DispatchWorkItem { [weak self] in
            guard let self = self else { return }
            self.viewModel.searchText = currentText
            self.viewModel.currentPage = 1
            self.viewModel.getAllPromocode()
        }
        searchWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: workItem)
        return true
    }
}
