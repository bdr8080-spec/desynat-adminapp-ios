//
//  GiftCardsListViewController.swift
//  DesynatAdmin
//
//  Created by fluper on 09/12/25.
//

import UIKit

class GiftCardsListViewController: UIViewController {
    
    // MARK: - IBOutlet's
    @IBOutlet weak var searchTF: UITextField!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var pageCountLabel: UILabel!
    @IBOutlet weak var noDataFoundLabel: UILabel!
    @IBOutlet weak var cardsTableView: UITableView! {
        didSet {
            cardsTableView.registerCellFromNib(cellID: "GiftCardsTableViewCell")
        }
    }
    
    // MARK: - Property Decalaration
    private lazy var viewModel = GiftCardsListViewModel(hostVC: self)
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
        viewModel.getAllCards()
    }
    
    // MARK: - Button's Action
    @IBAction func backDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func plusDidTapped(_ sender: Any) {
        let nextVC = AddNewCardViewController.instantiate(fromAppStoryboard: .ShippingPromocode)
        nextVC.isComingForEdit = false
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @IBAction func nextDidTapped(_ sender: Any) {
        viewModel.goToNextPage()
    }
    
    @IBAction func previousDidTapped(_ sender: Any) {
        viewModel.goToPreviousPage()
    }
    
    //MARK: Function's declaration
    func updatePaginationButtonImages() {
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
extension GiftCardsListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.giftsListData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GiftCardsTableViewCell", for: indexPath) as! GiftCardsTableViewCell
        let data = viewModel.giftsListData[indexPath.row]
        cell.configData(data: data)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nextVC = GiftCardDetailsViewController.instantiate(fromAppStoryboard: .ShippingPromocode)
        nextVC.giftsListData = viewModel.giftsListData[indexPath.row]
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
}

//MARK: UITextFieldDelegate Methods
extension GiftCardsListViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
        searchWorkItem?.cancel()
        let workItem = DispatchWorkItem { [weak self] in
            guard let self = self else { return }
            self.viewModel.searchText = currentText
            self.viewModel.currentPage = 1
            viewModel.getAllCards()
        }
        searchWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: workItem)
        return true
    }
}
