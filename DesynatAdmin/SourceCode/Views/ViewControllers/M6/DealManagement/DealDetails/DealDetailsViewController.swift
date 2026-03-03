//
//  DealDetailsViewController.swift
//  DesynatAdmin
//
//  Created by fluper on 07/01/26.
//

import UIKit
import SDWebImage

class DealDetailsViewController: UIViewController {
    
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var subCategoryLabel: UILabel!
    @IBOutlet weak var totalSellerLabel: UILabel!
    @IBOutlet weak var noDataFoundLabel: UILabel!
    @IBOutlet weak var mainImageView: CustomImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var pageCountLabel: UILabel!
    @IBOutlet weak var enrollTableView: UITableView! {
        didSet {
            enrollTableView.registerCellFromNib(cellID: "EnrolledSellerTableViewCell")
        }
    }
    
    @IBOutlet weak var hotDealsLaebl: UILabel!
    @IBOutlet weak var hotDealsView: UIView!
    @IBOutlet weak var hotDealsstackView: UIStackView!
    @IBOutlet weak var statusImageView: UIImageView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var discountLabel: UILabel!
    @IBOutlet weak var activeButtonStackView: UIStackView!
    @IBOutlet weak var revenueDetailsView: CustomView!
    
    var type: Int = 1 // 1 active 2 expired
    var dealId: Int = 0
    var dealData: DealListManagementList?
    private lazy var viewModel = DealDetailsViewModel(hostVC: self)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if type == 1 {
            activeButtonStackView.isHidden = false
            revenueDetailsView.isHidden = true
            hotDealsView.isHidden = false
            hotDealsLaebl.isHidden = false
            hotDealsstackView.isHidden = false
        } else {
            activeButtonStackView.isHidden = true
            revenueDetailsView.isHidden = false
            hotDealsView.isHidden = true
            hotDealsLaebl.isHidden = true
            hotDealsstackView.isHidden = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getDealDetailsList()
    }
    
    @IBAction func backDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func nextDidTapped(_ sender: Any) {
        guard viewModel.currentPage < viewModel.totalPages else { return }
        viewModel.currentPage += 1
        reloadPaginationUI()
    }
    
    @IBAction func previousDidTapped(_ sender: Any) {
        guard viewModel.currentPage > 1 else { return }
        viewModel.currentPage -= 1
        reloadPaginationUI()
    }
    
    @IBAction func editDidTapped(_ sender: Any) {
        let nextVC = AddDealViewController.instantiate(fromAppStoryboard: .LiveStoryDealManagement)
        nextVC.comingforEdit = true
        nextVC.dealData = dealData
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @IBAction func statusDidTapped(_ sender: Any) {
        viewModel.upadteDealStatus(param: ["deal_id": dealId])
    }
    
    @IBAction func deleteDidTapped(_ sender: Any) {
        guard let gift = dealData else { return }
        self.showConfirmationAlert(msg: "Are you sure you want to delete this deal?"){ [weak self] in
            guard let self = self else { return }
            self.viewModel.deleteDealDetails(param: ["deal_id": gift.id ?? 0])
        }
    }
    
    private func reloadPaginationUI() {
        let hasData = viewModel.totalItems > 0
        
        noDataFoundLabel.isHidden = hasData
        enrollTableView.isHidden = !hasData
        
        if hasData {
            enrollTableView.reloadData()
            updatePaginationButtonImages()
        } else {
            // Reset pagination UI
            previousButton.isUserInteractionEnabled = false
            nextButton.isUserInteractionEnabled = false
            
            previousButton.setImage(UIImage(named: "previousLeft"), for: .normal)
            nextButton.setImage(UIImage(named: "lightnextimage"), for: .normal)
            
            pageCountLabel.text = "00 of 00"
        }
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
        
        pageCountLabel.text = String(
            format: "%02d of %02d",
            viewModel.currentPage,
            viewModel.totalPages
        )
    }
    
    
    func bindData() {
        titleLabel.text = dealData?.nameEnglish
        if let imageUrlString = dealData?.image,
           let url = URL(string: imageUrlString) {
            mainImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            mainImageView.sd_imageIndicator?.startAnimatingIndicator()
            mainImageView.sd_setImage(with: url, placeholderImage: UIImage(named: ""))
        } else {
            mainImageView.image = UIImage(named: "")
        }
        mainImageView.enableFullscreenZoom()
        discountLabel.text = "\(CommonUtils.formatPriceStringInput(dealData?.discount, currency: "%"))"
        let startDate = convertDateFormat(dealData?.from ?? "") ?? ""
        let endDate = convertDateFormat(dealData?.to ?? "") ?? ""
        dateLabel.text = "\(startDate) - \(endDate)"
        if dealData?.status == 1 {
            statusLabel.text = "Active"
            statusImageView.image = UIImage(named: "toggleOn")
        } else {
            statusLabel.text = "Inactive"
            statusImageView.image = UIImage(named: "toggleOff")
        }
        viewModel.currentPage = 1
        reloadPaginationUI()
        //    totalSellerLabel.text = data.t
        let count = dealData?.sellerDealrecords?.count ?? 0
        totalSellerLabel.text = "\(count) " + (count == 1 ? "Seller" : "Sellers")
        categoryLabel.text = dealData?.categoryDetails?.name
        subCategoryLabel.text = dealData?.subCategoryDetails?.compactMap({ $0.nameEnglish }).joined(separator: ", ")
    }
    
    func convertDateFormat(
        _ dateString: String,
        from inputFormat: String = "yyyy-MM-dd",
        to outputFormat: String = "dd/MM/yyyy"
    ) -> String? {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = inputFormat
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        guard let date = inputFormatter.date(from: dateString) else {
            return nil
        }
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = outputFormat
        outputFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        return outputFormatter.string(from: date)
    }
}

extension DealDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.paginatedItems.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "EnrolledSellerTableViewCell",
            for: indexPath
        ) as! EnrolledSellerTableViewCell
        
        let data = viewModel.paginatedItems[indexPath.row]
        cell.configData(data: data)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nextVC = EnrollDealDetailsViewController.instantiate(fromAppStoryboard: .LiveStoryDealManagement)
        nextVC.type = type
        nextVC.dealId = viewModel.paginatedItems[indexPath.row].dealID
        nextVC.sellerId = viewModel.paginatedItems[indexPath.row].sellerDetails?.id
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
}
