//
//  CatalogViewController.swift
//  DesynatUser
//
//  Created by Rakhi Kumari on 24/10/25.
//

import UIKit

class PaymentsController: UIViewController {
    
    // MARK: - IBOutlet's
    @IBOutlet weak var orderbtnLbl: UILabel!
    @IBOutlet weak var ordersBtn: CustomButton!
    @IBOutlet weak var planBtn: CustomButton!
    @IBOutlet weak var planLbl: UILabel!
    @IBOutlet weak var giftCardBtn: CustomButton!
    @IBOutlet weak var giftCardLbl: UILabel!
    @IBOutlet weak var bannerBtn: CustomButton!
    @IBOutlet weak var bannerLbl: UILabel!
    @IBOutlet weak var orderCommisionForHide: UIStackView!
    @IBOutlet weak var chooseMonthForHide: UIView!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
//    @IBOutlet weak var tableViewHeightConstraints: NSLayoutConstraint!
    @IBOutlet weak var paymentTableView: TableViewDynamicHeight!{
        didSet{
            paymentTableView.registerCellFromNib(cellID: "PaymentTableViewCell")
        }
    }
    @IBOutlet weak var totalRevenueLbl: UILabel!
    @IBOutlet weak var orderCommissionLbl: UILabel!
    @IBOutlet weak var specialOrderLbl: UILabel!
    @IBOutlet weak var chooseMonthLbl: CustomLabelFont!
    @IBOutlet weak var chooseYear: CustomLabelFont!
    @IBOutlet weak var pagecountLabel: UILabel!
    @IBOutlet weak var noDataFoundLabel: UILabel!
    @IBOutlet weak var searchTF: UITextField!
    
    // MARK: - Property Decalaration
    var expandedIndex: IndexPath?
    var selectedTab: PaymentTab = .orders
    private lazy var viewModel = PaymentsViewModel(hostVC: self)
    private var searchWorkItem: DispatchWorkItem?
    
    // MARK: - View's LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTF.delegate = self
        updateTabUI(selected: .orders)
        viewModel.fetchOrdersList()
    }
    
    // MARK: - Button's Action
    @IBAction func orderBtnDidTapped(_ sender: Any) {
        selectedTab = .orders
        updateTabUI(selected: .orders)
        searchTF.text = ""
        viewModel.currentPage = 1
        viewModel.fetchOrdersList()
    }
    @IBAction func planBtnDidTapped(_ sender: Any) {
        selectedTab = .plans
        updateTabUI(selected: .plans)
        searchTF.text = ""
        viewModel.currentPage = 1
        viewModel.fetchPlansList()
    }
    @IBAction func giftCardBtnDidTapped(_ sender: Any) {
        selectedTab = .giftCards
        updateTabUI(selected: .giftCards)
        searchTF.text = ""
        viewModel.currentPage = 1
        viewModel.fetchGiftCardsList()
    }
    @IBAction func bannerBtnDidTapped(_ sender: Any) {
        selectedTab = .banners
        updateTabUI(selected: .banners)
        searchTF.text = ""
        viewModel.currentPage = 1
        viewModel.fetchBannersList()
    }
    
    @IBAction func filterDidTapped(_ sender: Any) {
        let vc = PaymentFilterViewController.instantiate(fromAppStoryboard: .Payment)
                vc.selectedFilter = viewModel.filter(for: selectedTab)
        
                vc.onApplyFilter = { [weak self] filter in
                    guard let self = self else { return }
        
                    self.viewModel.setFilter(filter, for: self.selectedTab)
                    self.viewModel.currentPage = 1
        
                    switch self.selectedTab {
                    case .orders:
                        self.viewModel.fetchOrdersList()
                    case .plans:
                        self.viewModel.fetchPlansList()
                    case .giftCards:
                        self.viewModel.fetchGiftCardsList()
                    case .banners:
                        self.viewModel.fetchBannersList()
                    }
                }
                vc.onClearFilter = { [weak self] in
                    guard let self = self else { return }
        
                    self.viewModel.setFilter(PaymentFilterModel(), for: self.selectedTab)
                    self.viewModel.currentPage = 1
        
                    switch self.selectedTab {
                    case .orders:
                        self.viewModel.fetchOrdersList()
                    case .plans:
                        self.viewModel.fetchPlansList()
                    case .giftCards:
                        self.viewModel.fetchGiftCardsList()
                    case .banners:
                        self.viewModel.fetchBannersList()
                    }
                }
        self.navigationController?.present(vc, animated: true)
    }
    
    //MARK: Function's declaration
    private func updateTabUI(selected: PaymentTab) {
        // Reset all
        let buttons = [ordersBtn, planBtn, giftCardBtn, bannerBtn]
        let labels = [orderbtnLbl, planLbl, giftCardLbl, bannerLbl]
        buttons.forEach {
            $0?.setImage(UIImage(named: ""), for: .normal)
            $0?.layer.cornerRadius = 0
            $0?.clipsToBounds = true
        }
        labels.forEach {
            $0?.textColor = UIColor.black
        }
        // Apply selected state
        switch selected {
            
        case .orders:
            ordersBtn.setImage(UIImage(named: "topTabbar"), for: .normal)
            ordersBtn.layer.cornerRadius = 5
            ordersBtn.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
            orderbtnLbl.textColor = .white
            orderCommisionForHide.isHidden = false
            chooseMonthForHide.isHidden = true
            
        case .plans:
            planBtn.setImage(UIImage(named: "topTabbar"), for: .normal)
            planLbl.textColor = .white
            orderCommisionForHide.isHidden = true
            chooseMonthForHide.isHidden = false
            
        case .giftCards:
            giftCardBtn.setImage(UIImage(named: "topTabbar"), for: .normal)
            giftCardLbl.textColor = .white
            orderCommisionForHide.isHidden = true
            chooseMonthForHide.isHidden = false
            
        case .banners:
            bannerBtn.setImage(UIImage(named: "topTabbar"), for: .normal)
            bannerBtn.layer.cornerRadius = 5
            bannerBtn.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
            bannerLbl.textColor = .white
            orderCommisionForHide.isHidden = true
            chooseMonthForHide.isHidden = false
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
        }
    
    
}
extension PaymentsController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentTableViewCell", for: indexPath) as! PaymentTableViewCell
        
        let isExpanded = expandedIndex == indexPath
        cell.configure(isExpanded: isExpanded, tab: selectedTab)
        cell.isViewMore = {
            if self.expandedIndex == indexPath {
                self.expandedIndex = nil
            } else {
                self.expandedIndex = indexPath
            }
            
            self.paymentTableView.reloadData()
        }
        return cell
    }
}

//MARK: UITextFieldDelegate Methods
extension PaymentsController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
        searchWorkItem?.cancel()
        let workItem = DispatchWorkItem { [weak self] in
            guard let self = self else { return }
            self.viewModel.searchText = currentText
            self.viewModel.currentPage = 1
            switch selectedTab {
            case .orders:
                self.viewModel.fetchOrdersList()
            case .plans:
                self.viewModel.fetchPlansList()
            case .giftCards:
                self.viewModel.fetchGiftCardsList()
            case .banners:
                self.viewModel.fetchBannersList()
            }
        }
        searchWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: workItem)
        return true
    }
}




enum PaymentTab {
    case orders
    case plans
    case giftCards
    case banners
}
