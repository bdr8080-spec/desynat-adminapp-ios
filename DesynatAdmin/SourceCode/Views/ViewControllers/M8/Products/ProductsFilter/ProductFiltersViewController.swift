//
//  ProductFiltersViewController.swift
//  DesynatAdmin
//
//  Created by fluper_mac3 on 13/02/26.
//

import UIKit

struct FilterSection {
    var header: String
    var options: [FilterOption]
}

struct FilterOption {
    var id: String
    var title: String
    var isSelected: Bool = false
    var selectedImage: String = "selectedCheckBox"
    var unselectedImage: String = "unslectedCheckbox"
}

//import UIKit

class ProductFiltersViewController: UIViewController {

    @IBOutlet weak var filterTableView: UITableView!
    @IBOutlet weak var headerView: UIView!
    
    // MARK: - Data Lists
    var countriesList: [GetCountryDataModel] = []
    var categoriesList: [GetCategoryModel] = []
    var subCategoriesList: [GetSubCategoryDataList] = []
    var brandsList: [GetBrandDataList] = []
    
    // MARK: - Selected IDs
    var selectedCountryIDs: [String] = []
    var selectedCategoryIDs: [String] = []
    var selectedSubCategoryIDs: [String] = []
    var selectedBrandIDs: [String] = []
    
    // MARK: - Callback
    var onFilterApplied: ((_ countryIDs: [String],
                           _ categoryIDs: [String],
                           _ subCategoryIDs: [String],
                           _ brandIDs: [String]) -> Void)?
    
    // MARK: - Filters Container
    var filtersOptions: [FilterSection] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        registerXib()
        setupUI()
        prepareFilters()
    }
    
    // MARK: - Apply Button
    @IBAction func applyDidTapped(_ sender: Any) {
        onFilterApplied?(selectedCountryIDs,
                         selectedCategoryIDs,
                         selectedSubCategoryIDs,
                         selectedBrandIDs)
        dismiss(animated: true)
    }
    
    // MARK: - Close Button
    @IBAction func crossDidTapped(_ sender: Any) {
        dismiss(animated: true)
    }
    
    // MARK: - Clear Button
    @IBAction func clearDidTapped(_ sender: Any) {
        
        selectedCountryIDs.removeAll()
        selectedCategoryIDs.removeAll()
        selectedSubCategoryIDs.removeAll()
        selectedBrandIDs.removeAll()
        
        for section in 0..<filtersOptions.count {
            for index in 0..<filtersOptions[section].options.count {
                filtersOptions[section].options[index].isSelected = false
            }
        }
        
        filterTableView.reloadData()
    }
    
    // MARK: - UI Setup
    func setupUI() {
        headerView.layer.cornerRadius = 32
        headerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        headerView.clipsToBounds = true
    }
    
    // MARK: - Prepare Filters (Handles Preselection)
    func prepareFilters() {
        
        let countryOptions = countriesList.map {
            FilterOption(
                id: "\($0.id ?? 0)",
                title: $0.name ?? "",
                isSelected: selectedCountryIDs.contains("\($0.id ?? 0)")
            )
        }
        
        let categoryOptions = categoriesList.map {
            FilterOption(
                id: "\($0.id ?? 0)",
                title: $0.name ?? "",
                isSelected: selectedCategoryIDs.contains("\($0.id ?? 0)")
            )
        }
        
        let subCategoryOptions = categoriesList.map {
            FilterOption(
                id: "\($0.id ?? 0)",
                title: $0.name ?? "",
                isSelected: selectedSubCategoryIDs.contains("\($0.id ?? 0)")
            )
        }
        
        let brandOptions = brandsList.map {
            FilterOption(
                id: "\($0.id ?? 0)",
                title: $0.nameEnglish ?? "",
                isSelected: selectedBrandIDs.contains("\($0.id ?? 0)")
            )
        }
        
        filtersOptions = [
            FilterSection(header: "Country", options: countryOptions),
            FilterSection(header: "Category", options: categoryOptions),
            FilterSection(header: "Sub-category", options: subCategoryOptions),
            FilterSection(header: "Brand", options: brandOptions)
        ]
        
        filterTableView.reloadData()
    }
    
    // MARK: - Register Table
    func registerXib() {
        
        filterTableView.delegate = self
        filterTableView.dataSource = self
        
        filterTableView.registerCellFromNib(cellID: "FilterOptionsTableViewCell")
        
        filterTableView.register(
            UINib(nibName: "FilterHeaderTableViewCell", bundle: nil),
            forHeaderFooterViewReuseIdentifier: "FilterHeaderTableViewCell"
        )
        
        filterTableView.estimatedRowHeight = 0
        filterTableView.estimatedSectionHeaderHeight = 0
        filterTableView.estimatedSectionFooterHeight = 0
        filterTableView.showsVerticalScrollIndicator = false
    }
}

extension ProductFiltersViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return filtersOptions.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filtersOptions[section].options.count
    }
    
    func tableView(_ tableView: UITableView,
                   viewForHeaderInSection section: Int) -> UIView? {
        
        let header = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: "FilterHeaderTableViewCell"
        ) as! FilterHeaderTableViewCell
        if section == 3 {
            header.descriptionLabel.isHidden = false
        } else {
            header.descriptionLabel.isHidden = true
        }
        header.titleLabel.text = filtersOptions[section].header
        return header
    }
    
    func tableView(_ tableView: UITableView,
                   heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView,
                   heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "FilterOptionsTableViewCell",
            for: indexPath
        ) as! FilterOptionsTableViewCell
        
        let option = filtersOptions[indexPath.section].options[indexPath.row]
        
        cell.titleLabel.text = option.title
        cell.selectedImageView.image = UIImage(
            named: option.isSelected
            ? option.selectedImage
            : option.unselectedImage
        )
        
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.section {
            
        // MARK: Country (Single)
        case 0:
            for i in 0..<filtersOptions[0].options.count {
                filtersOptions[0].options[i].isSelected = (i == indexPath.row)
            }
            
            selectedCountryIDs = [filtersOptions[0].options[indexPath.row].id]
            
            
        // MARK: Category (Single)
        case 1:
            for i in 0..<filtersOptions[1].options.count {
                filtersOptions[1].options[i].isSelected = (i == indexPath.row)
            }
            
            selectedCategoryIDs = [filtersOptions[1].options[indexPath.row].id]
            
            
        // MARK: SubCategory (Multi)
        case 2:
            filtersOptions[2].options[indexPath.row].isSelected.toggle()
            
            let id = filtersOptions[2].options[indexPath.row].id
            
            if filtersOptions[2].options[indexPath.row].isSelected {
                selectedSubCategoryIDs.append(id)
            } else {
                selectedSubCategoryIDs.removeAll { $0 == id }
            }
            
            
        // MARK: Brand (Multi)
        case 3:
            filtersOptions[3].options[indexPath.row].isSelected.toggle()
            
            let id = filtersOptions[3].options[indexPath.row].id
            
            if filtersOptions[3].options[indexPath.row].isSelected {
                selectedBrandIDs.append(id)
            } else {
                selectedBrandIDs.removeAll { $0 == id }
            }
            
        default:
            break
        }
        
        tableView.reloadSections(IndexSet(integer: indexPath.section), with: .none)
    }
}
