//
//  SubCategoryViewController.swift
//  DesynatAdmin
//
//  Created by Rakhi Kumari on 31/10/25.
//

import UIKit

class SubCategoryViewController: UIViewController {
    
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var noDataFoundLabel: UILabel!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var subCategoryCollectionView: UICollectionView! {
        didSet {
            subCategoryCollectionView.registerCellFromNib(cellID: "SubCategoryCollectionViewCell")
        }
    }
    
    var categoryId: String = ""
    private lazy var viewModel = SubcategoryViewModel(hostVC: self)
    private var searchWorkItem: DispatchWorkItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTextField.delegate = self
        updatePaginationButtonImages()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.currentPage = 1
        viewModel.getAllsubcategory(param: ["category_id": categoryId])
    }
    
    @IBAction func backDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
    
    
    @IBAction func plusDidTapped(_ sender: Any) {
        let vc = AddSubCategoryViewController.instantiate(fromAppStoryboard: .SideMenu)
        vc.categoryId = categoryId
        vc.isComingForEdit = false
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    @IBAction func nextButtonAction(_ sender: Any) {
        viewModel.goToNextPage(param: ["category_id": categoryId])
    }
    
    
    @IBAction func previousButtonAction(_ sender: Any) {
        viewModel.goToPreviousPage(param: ["category_id": categoryId])
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

extension SubCategoryViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.subCategoryListData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SubCategoryCollectionViewCell", for: indexPath) as! SubCategoryCollectionViewCell
        let data = viewModel.subCategoryListData[indexPath.row]
        cell.configData(data: data)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = SubCatgoryDetailsViewController.instantiate(fromAppStoryboard: .SideMenu)
        vc.subCategoryData = viewModel.subCategoryListData[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spacing: CGFloat = 7
        let totalSpacing = spacing * 2 // 3 cells per row → 2 spaces between
        let width = (collectionView.frame.width - totalSpacing) / 2
        return CGSize(width: width, height: 215)
    }
    
}

extension SubCategoryViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
        
        // Cancel previous search work item
        searchWorkItem?.cancel()
        
        // Create new one
        let workItem = DispatchWorkItem { [weak self] in
            guard let self = self else { return }
            self.viewModel.searchText = currentText
            self.viewModel.currentPage = 1
            self.viewModel.getAllsubcategory(param: ["category_id": self.categoryId])
        }
        
        // Store and execute after delay
        searchWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: workItem)
        
        return true
    }
}
