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
    @IBOutlet weak var lblTitle: UILabel!
    
    private var expandedIndex: IndexPath?
    private lazy var viewModel = RefundManagementViewModel(hostVC: self)
    private var searchWorkItem: DispatchWorkItem?
    var hasActionPermission: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTF.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.currentPage = 1
        viewModel.getAllRefundRequest()
        lblTitle.text = "Refund Management".localiz()
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
    
    @IBAction func exportDidTapped(_ sender: Any) {
//        var csv = "Username,Order ID,Transaction ID,Ordered On,Total Amount,Cancelled/Returned Date,Seller Name,Country,Rejected Reason,Status\n"
        let csvHeader = [
            "Username".localiz(),
            "Order ID".localiz(),
            "Transaction Id".localiz(),
            "Ordered on".localiz(),
            "Total Amount".localiz(),
            "Cancelled/Returned Date".localiz(),
            "Seller Name".localiz(),
            "Country".localiz(),
            "Rejected Reason".localiz(),
            "Status".localiz()
        ].joined(separator: ",") + "\n"

        var csv = csvHeader
           for data in viewModel.refundListData {
               let username = data.order?.deliveryDetails?.name ?? ""
               let orderId = "#\(data.order?.id ?? 0)"
               let fullTransaction = data.order?.transactionID.map { String(describing: $0) } ?? ""
               let transactionId = fullTransaction.count >= 7 ? String(fullTransaction.suffix(7)) : fullTransaction
               let orderedOn = CommonUtils.customizeChangeDateFormatZone(
                   inputDate: data.order?.createdAt ?? "",
                   inputFormat: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'",
                   outputFormat: "dd/MM/yyyy 'at' hh:mm a")
               let cancelledDate = CommonUtils.customizeChangeDateFormatZone(
                   inputDate: data.updatedAt ?? "",
                   inputFormat: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'",
                   outputFormat: "dd/MM/yyyy 'at' hh:mm a")
               let amount = CommonUtils.formatPriceStringInput(data.order?.totalAmount)
               let seller = "\(data.productDetails?.sellerDetails?.firstName ?? "") \(data.productDetails?.sellerDetails?.lastName ?? "")"
               let country = AppLanguageManager.shared.currentLanguage == .ar ? data.productDetails?.store?.countryInfo?.nameAr ?? "" : data.productDetails?.store?.countryInfo?.name ?? ""
               let reason = data.cancelReason ?? data.returnReason ?? data.exchangeReason ?? ""
               let status = "Pending".localiz()
               let row = "\"\(username)\",\"\(orderId)\",\"\(transactionId)\",\"\(orderedOn)\",\"\(amount)\",\"\(cancelledDate)\",\"\(seller)\",\"\(country)\",\"\(reason)\",\"\(status)\"\n"
               
               csv.append(row)
           }
        CSVExporter.exportCSV(fileName: "Refund List".localiz(), csvString: csv, vc: self)
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

extension RefundManagementViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.refundListData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RefundManagementTableViewCell", for: indexPath) as! RefundManagementTableViewCell
        let data = viewModel.refundListData[indexPath.row]
        let isExpanded = expandedIndex == indexPath
        cell.configure(isExpanded: isExpanded, data: data)
        cell.isViewMore = {
            if self.expandedIndex == indexPath {
                self.expandedIndex = nil
            } else {
                self.expandedIndex = indexPath
            }
            self.refundTableView.reloadData()
        }
        cell.refundCompletion = {
            self.viewModel.refundOrder(orderDetailId: data.orderID ?? 0) {
                let vc = PaymentMethodVC.instantiate(fromAppStoryboard: .NotificationCMS)
                vc.orderId = data.orderID ?? 0
                vc.paymentFrom = .refundOrder
                vc.payAmount = Double(data.amount ?? "") ?? 0
                self.navigationController?.pushViewController(vc, animated: true)
            }
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
