//
//  ProductFiltersViewController.swift
//  DesynatAdmin
//
//  Created by fluper_mac3 on 13/02/26.
//

import UIKit

class ProductFiltersViewController: UIViewController {
    
    // MARK: - IBOutlet's
    @IBOutlet weak var filterTableView: UITableView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var buttonActionStackView: UIStackView!
    
    // MARK: - Data Lists
    var countriesList: [GetCountryDataModel] = []
    var categoriesList: [GetCategoryModel] = []
    var subCategoriesList: [GetSubCategoryDataList] = []
    var brandsList: [GetBrandDataList] = []
    
    // MARK: - Selected IDs
    var selectedCountryIDs: [String] = []
    var selectedCategoryIDs: String = ""
    var selectedSubCategoryIDs: [String] = []
    var selectedBrandIDs: [String] = []
    
    // MARK: - Callback
    var onFilterApplied: ((_ countryIDs: [String],
                           _ categoryIDs: String,
                           _ subCategoryIDs: [String],
                           _ brandIDs: [String]) -> Void)?
    var onClearFilter: (() -> Void)?
    
    // MARK: - Filters Container
    var filtersOptions: [FilterSection] = []
    
    // MARK: - Dynamic Visible Sections
    var visibleSections: [FilterSection] {
        if selectedCategoryIDs.isEmpty {
            return filtersOptions.filter { $0.type != .subCategory }
        }
        return filtersOptions
    }
    
    // MARK: - View's LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        registerXib()
        setupUI()
        prepareFilters()
        if !selectedCategoryIDs.isEmpty {
            getAllsubcategoryApi(id: Int(selectedCategoryIDs))
        }
        buttonActionStackView.semanticContentAttribute = .forceLeftToRight
    }
    
    // MARK: - Button's Action
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
        onClearFilter?()
        dismiss(animated: true)
    }
    
    //MARK: Function's declaration
    func setupUI() {
        headerView.layer.cornerRadius = 32
        headerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        headerView.clipsToBounds = true
    }
    
    // MARK: - Subcategory API
    func getAllsubcategoryApi(id: Int?) {
        let param: [String: Any] = ["category_id": id ?? 0]
        WebService.sharedInstance.getAllsubcategory(param: param) { [weak self] list in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.subCategoriesList = list.data ?? []
                let subCategoryOptions = self.subCategoriesList.map {
                    FilterOption(
                        id: "\($0.id ?? 0)",
                        title: AppLanguageManager.shared.currentLanguage == .ar ? $0.nameArabic ?? "" : $0.nameEnglish ?? "",
                        isSelected: self.selectedSubCategoryIDs.contains("\($0.id ?? 0)")
                    )
                }
                if let index = self.filtersOptions.firstIndex(where: { $0.type == .subCategory }) {
                    self.filtersOptions[index].options = subCategoryOptions
                }
                
                self.filterTableView.reloadData()
            }
        }
    }
    
    // MARK: - Prepare Filters
    func prepareFilters() {
        let countryOptions = countriesList.map {
            FilterOption(
                id: "\($0.id ?? 0)",
                title: AppLanguageManager.shared.currentLanguage == .ar ? $0.nameAr ?? "" : $0.name ?? "",
                isSelected: selectedCountryIDs.contains("\($0.id ?? 0)")
            )
        }
        let categoryOptions = categoriesList.map {
            FilterOption(
                id: "\($0.id ?? 0)",
                title: AppLanguageManager.shared.currentLanguage == .ar ? $0.nameAr ?? "" : $0.name ?? "",
                isSelected: selectedCategoryIDs == "\($0.id ?? 0)"
            )
        }
        let subCategoryOptions = subCategoriesList.map {
            FilterOption(
                id: "\($0.id ?? 0)",
                title: AppLanguageManager.shared.currentLanguage == .ar ? $0.nameArabic ?? "" : $0.nameEnglish ?? "",
                isSelected: selectedSubCategoryIDs.contains("\($0.id ?? 0)")
            )
        }
        let brandOptions = brandsList.map {
            FilterOption(
                id: "\($0.id ?? 0)",
                title: AppLanguageManager.shared.currentLanguage == .ar ? $0.nameArabic ?? "" : $0.nameEnglish ?? "",
                isSelected: selectedBrandIDs.contains("\($0.id ?? 0)")
            )
        }
        filtersOptions = [
            FilterSection(type: .country, header: "Country".localiz(), options: countryOptions),
            FilterSection(type: .category, header: "Category".localiz(), options: categoryOptions),
            FilterSection(type: .subCategory, header: "Sub-category".localiz(), options: subCategoryOptions),
            FilterSection(type: .brand, header: "Brand".localiz(), options: brandOptions)
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
        filterTableView.showsVerticalScrollIndicator = false
    }
}

// MARK: - TABLE VIEW METHODS
extension ProductFiltersViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return visibleSections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return visibleSections[section].options.count
    }
    
    func tableView(_ tableView: UITableView,
                   viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: "FilterHeaderTableViewCell"
        ) as! FilterHeaderTableViewCell
        let sectionData = visibleSections[section]
        header.titleLabel.text = sectionData.header
        header.descriptionLabel.isHidden = (sectionData.type != .brand)
        return header
    }
    
    func tableView(_ tableView: UITableView,
                   heightForHeaderInSection section: Int) -> CGFloat {
        let sectionType = visibleSections[section].type
        switch sectionType {
        case .brand:
            return 60
        default:
            return 40
        }
    }
    
    func tableView(_ tableView: UITableView,
                   heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "FilterOptionsTableViewCell",
            for: indexPath
        ) as! FilterOptionsTableViewCell
        let section = visibleSections[indexPath.section]
        let option = section.options[indexPath.row]
        cell.titleLabel.text = option.title
        if section.type == .category {
            cell.selectedImageView.image = option.isSelected ? .radioSelected : .radioUnselected
        } else {
            cell.selectedImageView.image = UIImage(
                named: option.isSelected
                ? option.selectedImage
                : option.unselectedImage
            )
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        let sectionType = visibleSections[indexPath.section].type
        switch sectionType {
            
            // MARK: - Country (Single + Toggle)
        case .country:
            guard let sectionIndex = filtersOptions.firstIndex(where: { $0.type == .country }) else { return }
            
            let tappedOption = filtersOptions[sectionIndex].options[indexPath.row]
            
            if tappedOption.isSelected {
                // Deselect if already selected
                filtersOptions[sectionIndex].options[indexPath.row].isSelected = false
                selectedCountryIDs.removeAll()
            } else {
                // Select new one
                for i in 0..<filtersOptions[sectionIndex].options.count {
                    filtersOptions[sectionIndex].options[i].isSelected = false
                }
                filtersOptions[sectionIndex].options[indexPath.row].isSelected = true
                selectedCountryIDs = [tappedOption.id]
            }
            
            
            // MARK: - Category (Single + Toggle)
        case .category:
            guard let sectionIndex = filtersOptions.firstIndex(where: { $0.type == .category }) else { return }
            
            let tappedOption = filtersOptions[sectionIndex].options[indexPath.row]
            
            if tappedOption.isSelected {
                // Deselect
                filtersOptions[sectionIndex].options[indexPath.row].isSelected = false
                selectedCategoryIDs = ""
                
                // Also clear subcategories
                selectedSubCategoryIDs.removeAll()
                subCategoriesList.removeAll()
                
            } else {
                // Select new category
                for i in 0..<filtersOptions[sectionIndex].options.count {
                    filtersOptions[sectionIndex].options[i].isSelected = false
                }
                filtersOptions[sectionIndex].options[indexPath.row].isSelected = true
                selectedCategoryIDs = tappedOption.id
                
                // Reset old subcategories
                selectedSubCategoryIDs.removeAll()
                getAllsubcategoryApi(id: Int(tappedOption.id))
            }
            
            
            // MARK: - SubCategory (Multi)
        case .subCategory:
            toggleMultiSelection(type: .subCategory,
                                 index: indexPath.row,
                                 selectedArray: &selectedSubCategoryIDs)
            
            
            // MARK: - Brand (Multi)
        case .brand:
            toggleMultiSelection(type: .brand,
                                 index: indexPath.row,
                                 selectedArray: &selectedBrandIDs)
        }
        
        tableView.reloadData()
    }
}

// MARK: - Helpers

extension ProductFiltersViewController {
    
    func updateSingleSelection(type: FilterType, index: Int) {
        guard let sectionIndex = filtersOptions.firstIndex(where: { $0.type == type }) else { return }
        
        for i in 0..<filtersOptions[sectionIndex].options.count {
            filtersOptions[sectionIndex].options[i].isSelected = (i == index)
        }
    }
    
    func toggleMultiSelection(type: FilterType, index: Int, selectedArray: inout [String]) {
        guard let sectionIndex = filtersOptions.firstIndex(where: { $0.type == type }) else { return }
        
        filtersOptions[sectionIndex].options[index].isSelected.toggle()
        let id = filtersOptions[sectionIndex].options[index].id
        
        if filtersOptions[sectionIndex].options[index].isSelected {
            selectedArray.append(id)
        } else {
            selectedArray.removeAll { $0 == id }
        }
    }
    
    func getOption(type: FilterType, index: Int) -> FilterOption {
        let sectionIndex = filtersOptions.firstIndex { $0.type == type }!
        return filtersOptions[sectionIndex].options[index]
    }
}

// MARK: - Models

enum FilterType {
    case country
    case category
    case subCategory
    case brand
}

struct FilterSection {
    var type: FilterType
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
