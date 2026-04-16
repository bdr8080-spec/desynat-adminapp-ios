//
//  RefundManagementViewController.swift
//  DesynatAdmin
//
//  Created by  shailendra singh on 27/03/26.
//

import UIKit

class RefundManagementViewController: UIViewController {
    
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var noDataFoundLabel: UILabel!
    @IBOutlet weak var pageCountLabel: UILabel!
    @IBOutlet weak var searchTF: BindableTextField!
    @IBOutlet weak var refundTableView: UITableView!{
        didSet{
            refundTableView.registerCellFromNib(cellID: "RefundManagementTableViewCell")
        }
    }
    
    private var expandedIndex: IndexPath?
    private lazy var viewModel = RefundManagementViewModel(hostVC: self)
    private var searchWorkItem: DispatchWorkItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTF.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.currentPage = 1
        viewModel.getAllRefundRequest()
    }
    
    // MARK: - Navigation
    @IBAction func backBtnTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func filterBtnTapped(_ sender: Any) {
        let vc =  RefundManagementFilterViewController.instantiate(fromAppStoryboard: .NotificationCMS)
        vc.selectedFilter = viewModel.appliedFilter
        vc.disbaleFutureDateSelection = true
        vc.onApplyFilter = { [weak self] filter in
            guard let self = self else { return }
            self.viewModel.appliedFilter = filter
            self.viewModel.currentPage = 1
            self.viewModel.getAllRefundRequest()
        }
        vc.onClearFilter = { [weak self] in
            guard let self = self else { return }
            self.viewModel.appliedFilter = PaymentFilterModel()
            self.viewModel.currentPage = 1
            self.viewModel.getAllRefundRequest()
        }
        self.present(vc, animated: true)
    }
    
    @IBAction func nextDidTapped(_ sender: Any) {
        viewModel.goToNextPage()
    }
    
    @IBAction func previousDidTapped(_ sender: Any) {
        viewModel.goToPreviousPage()
    }
    
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
extension RefundManagementViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.refundListData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RefundManagementTableViewCell", for: indexPath) as! RefundManagementTableViewCell
        let isExpanded = expandedIndex == indexPath
        cell.configure(isExpanded: isExpanded)
        let data = viewModel.refundListData[indexPath.row]
        cell.isViewMore = {
            if self.expandedIndex == indexPath {
                self.expandedIndex = nil
            } else {
                self.expandedIndex = indexPath
            }
            
            self.refundTableView.reloadData()
        }
        return cell
    }
}

//MARK: UITextFieldDelegate Methods
extension RefundManagementViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
        searchWorkItem?.cancel()
        let workItem = DispatchWorkItem { [weak self] in
            guard let self = self else { return }
            self.viewModel.searchText = currentText
            self.viewModel.currentPage = 1
            self.viewModel.getAllRefundRequest()
        }
        searchWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: workItem)
        return true
    }
}
