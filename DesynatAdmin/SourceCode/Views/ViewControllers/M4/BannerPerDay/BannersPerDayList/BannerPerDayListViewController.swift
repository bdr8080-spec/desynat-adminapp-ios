//
//  BannerPerDayListViewController.swift
//  DesynatAdmin
//
//  Created by fluper on 09/12/25.
//

import UIKit

class BannerPerDayListViewController: UIViewController {
    
    // MARK: - IBOutlet's
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var storyLabel: UILabel!
    @IBOutlet weak var storyButtonOutlet: CustomButton!
    @IBOutlet weak var noDataFoundLabel: UILabel!
    @IBOutlet weak var topButton: CustomButton!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var bottomButton: CustomButton!
    @IBOutlet weak var bottomLabel: UILabel!
    @IBOutlet weak var subCatgeoryButton: CustomButton!
    @IBOutlet weak var subCategoryLabel: UILabel!
    @IBOutlet weak var bannersTableView: UITableView! {
        didSet {
            bannersTableView.registerCellFromNib(cellID: "BannerPerDayListTableViewCell")
        }
    }
    
    // MARK: - Property Decalaration
    var type: Int = 1 //1-top,2-bottom,3-sub category,4-story
    private lazy var viewModel = BannerPerDayListViewModel(hostVC: self)
    var hasActionPermission: Bool = false
    
    // MARK: - View's LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        topButton.layer.cornerRadius = 5
        topButton.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        topButton.clipsToBounds = true
        lblTitle.text = "Banner & Story per day price".localiz()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getAllBannersPerDay()
    }
    
    // MARK: - Button's Action
    @IBAction func topDidTapped(_ sender: Any) {
        topButton.setImage(UIImage(named: "topTabbar"), for: .normal)
        topButton.layer.cornerRadius = 5
        topButton.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        topButton.clipsToBounds = true
        topLabel.textColor = UIColor.white
        bottomButton.setImage(UIImage(named: ""), for: .normal)
        bottomButton.layer.cornerRadius = 0
        bottomLabel.textColor = UIColor.black
        subCatgeoryButton.setImage(UIImage(named: ""), for: .normal)
        subCatgeoryButton.layer.cornerRadius = 0
        subCategoryLabel.textColor = UIColor.black
        storyButtonOutlet.setImage(UIImage(named: ""), for: .normal)
        storyButtonOutlet.layer.cornerRadius = 0
        storyLabel.textColor = UIColor.black
        type = 1
        viewModel.getAllBannersPerDay()
    }
    
    @IBAction func bottomDidTapped(_ sender: Any) {
        topButton.setImage(UIImage(named: ""), for: .normal)
        bottomButton.layer.cornerRadius = 0
        topLabel.textColor = UIColor.black
        bottomButton.setImage(UIImage(named: "topTabbar"), for: .normal)
        bottomButton.layer.cornerRadius = 0
        bottomLabel.textColor = UIColor.white
        subCatgeoryButton.setImage(UIImage(named: ""), for: .normal)
        subCatgeoryButton.layer.cornerRadius = 0
        subCategoryLabel.textColor = UIColor.black
        storyButtonOutlet.setImage(UIImage(named: ""), for: .normal)
        storyButtonOutlet.layer.cornerRadius = 0
        storyLabel.textColor = UIColor.black
        type = 2
        viewModel.getAllBannersPerDay()
    }
    
    @IBAction func subCategoryDidTapped(_ sender: Any) {
        topButton.setImage(UIImage(named: ""), for: .normal)
        topButton.layer.cornerRadius = 0
        topLabel.textColor = UIColor.black
        bottomButton.setImage(UIImage(named: ""), for: .normal)
        bottomLabel.textColor = UIColor.black
        bottomButton.layer.cornerRadius = 0
        subCatgeoryButton.setImage(UIImage(named: "topTabbar"), for: .normal)
        subCategoryLabel.textColor = UIColor.white
        subCatgeoryButton.layer.cornerRadius = 0
        storyButtonOutlet.setImage(UIImage(named: ""), for: .normal)
        storyButtonOutlet.layer.cornerRadius = 0
        storyLabel.textColor = UIColor.black
        subCatgeoryButton.clipsToBounds = true
        type = 3
        viewModel.getAllBannersPerDay()
    }
    
    @IBAction func storyDidTapped(_ sender: Any) {
        topButton.setImage(UIImage(named: ""), for: .normal)
        topButton.layer.cornerRadius = 0
        topLabel.textColor = UIColor.black
        bottomButton.setImage(UIImage(named: ""), for: .normal)
        bottomLabel.textColor = UIColor.black
        bottomButton.layer.cornerRadius = 0
        subCatgeoryButton.setImage(UIImage(named: ""), for: .normal)
        subCategoryLabel.textColor = UIColor.black
        subCatgeoryButton.layer.cornerRadius = 0
        storyButtonOutlet.setImage(UIImage(named: "topTabbar"), for: .normal)
        storyButtonOutlet.layer.cornerRadius = 5
        storyLabel.textColor = UIColor.white
        storyButtonOutlet.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        storyButtonOutlet.clipsToBounds = true
        type = 4
        viewModel.getAllStoryPriceForPerDay()
    }
    
    @IBAction func backDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

// MARK: - TABLE VIEW METHODS
extension BannerPerDayListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.bannersListData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BannerPerDayListTableViewCell", for: indexPath) as! BannerPerDayListTableViewCell
        let data = viewModel.bannersListData[indexPath.row]
        cell.configData(data: data)
        cell.editButton.isHidden = !hasActionPermission
        cell.onEditTap = { [weak self] in
            guard let self else { return }
            let nextVC = AddPricePerDayViewController.instantiate(fromAppStoryboard: .ShippingPromocode)
            nextVC.bannerDetails = data
            nextVC.isStorySelected = (type == 4)
            nextVC.onChangesAreDone = {
                if self.type == 4 {
                    self.viewModel.getAllStoryPriceForPerDay()
                } else {
                    self.viewModel.getAllBannersPerDay()
                }
            }
            self.navigationController?.present(nextVC, animated: true)
        }
        return cell
    }
    
}
