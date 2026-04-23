//
//  DeliveryBoyViewController.swift
//  DesynatAdmin
//
//  Created by fluper on 20/11/25.
//

import UIKit

class DeliveryBoyViewController: UIViewController {
    
    // MARK: - IBOutlet's
    @IBOutlet weak var deliveryTableView: UITableView! {
        didSet {
            deliveryTableView.registerCellFromNib(cellID: "DeliveryBoyTableViewCell")
        }
    }
    @IBOutlet weak var noDataFoundLabel: UILabel!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var pageCountLabel: UILabel!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var searchTextField: UITextField!
    
    // MARK: - Property Decalaration
    private lazy var viewModel = DeliveryBoyViewModel(hostVC: self)
    private var searchWorkItem: DispatchWorkItem?
    var hasActionPermission: Bool = false
    
    // MARK: - View's LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTextField.delegate = self
        updatePaginationButtonImages()
        plusButton.isHidden = !hasActionPermission
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.currentPage = 1
        viewModel.getAllDeliveryBoy()
    }
    
    // MARK: - Button's Action
    @IBAction func backDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func plusDidTapped(_ sender: Any) {
        let vc = AddNewDriverViewController.instantiate(fromAppStoryboard: .ReasonManagement)
        vc.isComingForEdit = false
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    @IBAction func nextButtonAction(_ sender: Any) {
        viewModel.goToNextPage()
    }
    
    @IBAction func previousButtonAction(_ sender: Any) {
        viewModel.goToPreviousPage()
    }
    
    @IBAction func filterDidTapped(_ sender: Any) {
        let vc = DeliveryManagementFilterViewController.instantiate(fromAppStoryboard: .ReasonManagement)
        vc.selectedFilter = viewModel.appliedFilter
        vc.onApplyFilter = { [weak self] filter in
            guard let self = self else { return }
            self.viewModel.appliedFilter = filter
            self.viewModel.currentPage = 1
            self.viewModel.getAllDeliveryBoy()
        }
        vc.onClearFilter = { [weak self] in
            guard let self = self else { return }
            self.viewModel.appliedFilter = DriverFilterModel()
            self.viewModel.currentPage = 1
            self.viewModel.getAllDeliveryBoy()
        }
        self.navigationController?.present(vc, animated: false)
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
    
    private func toggleReasonStatus(at indexPath: IndexPath) {
        var category = viewModel.boysListData[indexPath.row]
        let newStatus = category.status == "1" ? "0" : "1"
        let params: [String: Any] = ["user_id": category.id ?? 0]
        viewModel.updateActiveStatus(param: params) { [weak self] success in
            guard let self = self else { return }
            if success {
                category.status = newStatus
                self.viewModel.boysListData[indexPath.row] = category
                self.deliveryTableView.reloadRows(at: [indexPath], with: .automatic)
                if let status = category.status {
                    if status == "1" {
                        CommonUtils.showToast(message: "Delivery boy has been unblocked Successfully")
                    } else {
                        CommonUtils.showToast(message: "Delivery boy has been blocked Successfully")
                    }
                }
            }
        }
    }
    
}

// MARK: - TABLE VIEW METHODS
extension DeliveryBoyViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.boysListData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DeliveryBoyTableViewCell", for: indexPath) as! DeliveryBoyTableViewCell
        let data = viewModel.boysListData[indexPath.row]
        cell.delegate = self
        cell.configData(data: data)
        cell.onStatusToggle = { [weak self] in
            guard let self = self else { return }
            self.toggleReasonStatus(at: indexPath)
        }
        cell.statusButtonOutlet.isUserInteractionEnabled = hasActionPermission
        cell.buttonStackView.isHidden = !hasActionPermission
        cell.deleteView.isHidden = !hasActionPermission
        cell.editView.isHidden = !hasActionPermission
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DriverDetailsViewController.instantiate(fromAppStoryboard: .ReasonManagement)
        vc.userId = viewModel.boysListData[indexPath.row].id ?? 0
        vc.hasActionPermission = hasActionPermission
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
}

//MARK: UITextFieldDelegate Methods
extension DeliveryBoyViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
        searchWorkItem?.cancel()
        let workItem = DispatchWorkItem { [weak self] in
            guard let self = self else { return }
            self.viewModel.searchText = currentText
            self.viewModel.currentPage = 1
            self.viewModel.getAllDeliveryBoy()
        }
        searchWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: workItem)
        return true
    }
}

extension DeliveryBoyViewController: DeliveryBoyManagementCellDelegate {
    
    func didTapEdit(_ cell: DeliveryBoyTableViewCell) {
        guard let indexPath = deliveryTableView.indexPath(for: cell) else { return }
        let vc = AddNewDriverViewController.instantiate(fromAppStoryboard: .ReasonManagement)
        vc.isComingForEdit = true
        vc.userId = viewModel.boysListData[indexPath.row].id ?? 0
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    func didTapDelete(_ cell: DeliveryBoyTableViewCell) {
        guard let indexPath = deliveryTableView.indexPath(for: cell) else { return }
        let driverId = viewModel.boysListData[indexPath.row].id ?? 0
        self.showConfirmationAlert(msg: "Are you sure you want to delete this user?") { [weak self] in
            guard let self = self else { return }
            let param: [String: Any] = ["user_id": driverId]
            viewModel.deleteBoy(param: param)
        }
    }
}
