//
//  ProductDetailViewController.swift
//  DesynatAdmin
//
//  Created by fluper_mac3 on 13/02/26.
//


import UIKit
import SDWebImage

class ProductDetailViewController: UIViewController {
    
    // MARK: - IBOutlet's
    @IBOutlet weak var brandTitleLabel: UILabel!
    @IBOutlet weak var storeLocationLabel: UILabel!
    @IBOutlet weak var storeNameLabel: UILabel!
    @IBOutlet weak var sellerNameLabel: UILabel!
    @IBOutlet weak var sellerImageView: CustomImageView!
    @IBOutlet weak var addedOnDateLabel: UILabel!
    @IBOutlet weak var maxCartQuanity: UILabel!
    @IBOutlet weak var minimumCartQuantityLabel: UILabel!
    @IBOutlet weak var priceSeparatorLabel: UILabel!
    @IBOutlet weak var womenStackView: UIStackView!
    @IBOutlet weak var lengthStackView: UIStackView!
    @IBOutlet weak var sleeveLengthStackView: UIStackView!
    @IBOutlet weak var womenDetailsView: CustomView!
    @IBOutlet weak var cashOnDeliveryLabel: UILabel!
    @IBOutlet weak var readyToShipLabel: UILabel!
    @IBOutlet weak var customizableLabel: UILabel!
    @IBOutlet weak var affiliatedLabel: UILabel!
    @IBOutlet weak var ratingReviewALlowedLabel: UILabel!
    @IBOutlet weak var exchnageAllowedLAbel: UILabel!
    @IBOutlet weak var returnAllowedLAbel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var skuLabel: UILabel!
    @IBOutlet weak var totalStocksLabel: UILabel!
    @IBOutlet weak var shoulderView: UIStackView!
    @IBOutlet weak var hipView: UIStackView!
    @IBOutlet weak var waistView: UIStackView!
    @IBOutlet weak var bustView: UIStackView!
    @IBOutlet weak var sleeveLenghtLabel: UILabel!
    @IBOutlet weak var lengthLabel: UILabel!
    @IBOutlet weak var waistLabel: UILabel!
    @IBOutlet weak var shoulderLabel: UILabel!
    @IBOutlet weak var hipLabel: UILabel!
    @IBOutlet weak var bustLabel: UILabel!
    @IBOutlet weak var actualPriceLAbel: CustomLabelFont!
    @IBOutlet weak var discountPriceALbel: UILabel!
    @IBOutlet weak var finalPriceLabel: UILabel!
    @IBOutlet weak var ratingCountLabel: UILabel!
    @IBOutlet weak var brandCategoryLabel: UILabel!
    @IBOutlet weak var descriptionLAbel: UILabel!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var statusButton: UIButton!
    @IBOutlet weak var specificationTableViewHieghtConstraint: NSLayoutConstraint!
    @IBOutlet weak var imagesPageController: UIPageControl!
    @IBOutlet weak var productImageCollectionView: UICollectionView! {
        didSet {
            productImageCollectionView.registerCellFromNib(cellID: "ProductDetailImageCollectionViewCell")
        }
    }
    @IBOutlet weak var colorsCollectionView: UICollectionView! {
        didSet {
            colorsCollectionView.registerCellFromNib(cellID: "ProductColoursCollectionViewCell")
        }
    }
    @IBOutlet weak var sizeCollectionView: UICollectionView! {
        didSet {
            sizeCollectionView.registerCellFromNib(cellID: "SizeVariantCollectionViewCell")
        }
    }
    @IBOutlet weak var specificationTableView: UITableView! {
        didSet {
            specificationTableView.registerCellFromNib(cellID: "ListTableViewCell")
        }
    }
    
    // MARK: - Property Decalaration
    private lazy var viewModel = ProductDetailsViewModel(hostVC: self)
    private var selectedColourIndex = 0
    private var selectedSizeIndex = 0
    private var speifcationArray = [""]
    private var selectedVariant: ProductVariant?
    private var sizeChartUrl :String? = ""
    var productId: Int = 0
    var productVariants: [ProductVariant] = []
    var coloursList: [Color] = []
    var sizesList: [Color] = []
    var hasActionPermission: Bool = false
    
    // MARK: - View's LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        statusButton.isUserInteractionEnabled = hasActionPermission
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getProductDetailsService()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        DispatchQueue.main.async {
            self.specificationTableViewHieghtConstraint.constant = self.specificationTableView.contentSize.height
        }
    }
    
    // MARK: - Button's Action
    @IBAction func backDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Page Control Tap Handling
    @IBAction func pageControlChanged(_ sender: UIPageControl) {
        let page = sender.currentPage
        let indexPath = IndexPath(item: page, section: 0)
        productImageCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    @IBAction func updateStatusDidTapped(_ sender: Any) {
        guard let user = viewModel.productDetails else { return }
        let newStatus = user.productActiveStatus == 1 ? 0 : 1
        let params: [String: Any] = ["id": user.id ?? 0]
        viewModel.updateActiveStatus(param: params) { [weak self] success in
            guard let self = self else { return }
            if success {
                self.viewModel.productDetails?.productActiveStatus = newStatus
                if let updatedUser = self.viewModel.productDetails {
                    self.configData(data: updatedUser)
                    let message = newStatus == 1 ? "Product has been unblocked Successfully".localiz() : "Product has been blocked Successfully".localiz()
                    CommonUtils.showToast(message: message)
                }
            }
        }
    }
    
    @IBAction func sizeGuideDidTapped(_ sender: Any) {
        let nextVC = SizeChartViewController.instantiate(fromAppStoryboard: .ReasonManagement)
        nextVC.sizeChartUrl = sizeChartUrl
        self.navigationController?.present(nextVC, animated: true)
    }
    
    //MARK: Function's declaration
    func formatDateString(_ isoDateString: String) -> String {
        let inputFormatter = DateFormatter()
//        inputFormatter.locale = Locale(identifier: "en_US_POSIX")
        if AppLanguageManager.shared.currentLanguage == .ar {
            inputFormatter.locale = Locale(identifier: "ar")
           } else {
               inputFormatter.locale = Locale(identifier: "en_US")
           }
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS'Z'"
        inputFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        guard let date = inputFormatter.date(from: isoDateString) else {
            return ""
        }
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "dd/MM/yyyy"
        outputFormatter.timeZone = TimeZone.current
        return outputFormatter.string(from: date)
    }
    
    
    func configData(data: ProductsList) {
        // MARK: - Basic Product info
        
        if AppLanguageManager.shared.currentLanguage == .ar {
            productNameLabel.text = "\(data.productNameAr ?? "-") (بواسطة \(data.sellerDetails?.firstName ?? "") \(data.sellerDetails?.lastName ?? ""))"
            if data.brand?.nameEnglish == "Other" {
                brandTitleLabel.text = data.otherAr
            } else {
                brandTitleLabel.text = data.brand?.nameArabic
            }
            brandCategoryLabel.text = data.productNameAr ?? "-"//data.category?.name ?? ""
            descriptionLAbel.text = "\(data.store?.storeName ?? "-") (\(data.category?.nameAr ?? "-"))"//data.productNameEn ?? "-"
        } else {
            productNameLabel.text = "\(data.productNameEn ?? "-") (by \(data.sellerDetails?.firstName ?? "") \(data.sellerDetails?.lastName ?? ""))"
            if data.brand?.nameEnglish == "Other" {
                brandTitleLabel.text = data.otherEn
            } else {
                brandTitleLabel.text = data.brand?.nameEnglish
            }
            brandCategoryLabel.text = data.productNameEn ?? "-"//data.category?.name ?? ""
            descriptionLAbel.text = "\(data.store?.storeName ?? "-") (\(data.category?.name ?? "-"))"//data.productNameEn ?? "-"
        }
        
        
        descriptionLabel.text = data.descriptionEn ?? "-"
        
        ratingCountLabel.text = " (\(data.reviewRating ?? "0"))"
        sizeChartUrl = data.uploadSizeChart
        let categoryName = data.category?.name ?? "Women"
        if categoryName == "Women" {
            womenDetailsView.isHidden = false
            bustView.isHidden = false
            hipView.isHidden = false
            waistView.isHidden = false
            shoulderView.isHidden = false
            sleeveLengthStackView.isHidden = false
            lengthStackView.isHidden = false
            womenStackView.isHidden = false
        } else {
            womenDetailsView.isHidden = true
            bustView.isHidden = true
            hipView.isHidden = true
            waistView.isHidden = true
            shoulderView.isHidden = true
            sleeveLengthStackView.isHidden = true
            lengthStackView.isHidden = true
            womenStackView.isHidden = true
        }
        
        // Status
        if data.productActiveStatus == 1 {
            statusLabel.text = "Active".localiz()
            statusButton.setImage(UIImage(named: "toggleOn"), for: .normal)
        } else {
            statusLabel.text = "Inactive".localiz()
            statusButton.setImage(UIImage(named: "toggleOff"), for: .normal)
        }
        
        // MARK: - Switch Labels (YES / NO)
        cashOnDeliveryLabel.text = data.cashOnDelivery == "1" ? "Yes".localiz() : "No".localiz()
        readyToShipLabel.text = data.readyToShip == "1" ? "Yes".localiz() : "No".localiz()
        customizableLabel.text = data.customizedProduct == "1" ? "Yes".localiz() : "No".localiz()
        affiliatedLabel.text = data.affiliatedProduct == "1" ? "Yes".localiz() : "No".localiz()
        ratingReviewALlowedLabel.text = data.reviewRating == "1" ? "Yes".localiz() : "No".localiz()
        returnAllowedLAbel.text = data.productReturn == "1" ? "\(data.returnDays ?? "") \("days".localiz())" : "No".localiz()
        exchnageAllowedLAbel.text = data.productExchangable == "1" ? "\(data.exchangableDays ?? "") \("days".localiz())" : "No".localiz()
        
        // In configData
        productVariants = data.productVariants ?? []
        minimumCartQuantityLabel.text = data.minCardQuantity
        maxCartQuanity.text = data.maxCardQuantity
        addedOnDateLabel.text = formatDateString(data.createdAt ?? "")
        if let imageUrlString = data.store?.storeImage,
           let url = URL(string: imageUrlString) {
            sellerImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            sellerImageView.sd_imageIndicator?.startAnimatingIndicator()
            sellerImageView.sd_setImage(with: url, placeholderImage: UIImage(named: ""))
        } else {
            sellerImageView.image = .userProfile
        }
        sellerNameLabel.text = "\(data.sellerDetails?.firstName ?? "") \(data.sellerDetails?.lastName ?? "")"
        storeLocationLabel.text = AppLanguageManager.shared.currentLanguage == .ar ? data.store?.countryInfo?.nameAr : data.store?.countryInfo?.name
        storeNameLabel.text = data.store?.storeName
        var uniqueColorsDict: [Int: Color] = [:]
        for variant in productVariants {
            if let color = variant.color {
                if uniqueColorsDict[color.id ?? 0] == nil {
                    uniqueColorsDict[color.id ?? 0] = color
                }
            }
        }
        coloursList = Array(uniqueColorsDict.values)
        colorsCollectionView.reloadData()
        sizeCollectionView.reloadData()
        
        guard !coloursList.isEmpty else {
            selectedVariant = nil
            selectedColourIndex = 0
            selectedSizeIndex = 0
            updateVariantUI()
            return
        }
        
        selectedColourIndex = 0
        let firstColor = coloursList[0]
        let firstColorId = firstColor.id
        
        if let defaultVariant = productVariants.first(where: { $0.color?.id == firstColorId }) {
            selectedVariant = defaultVariant
        } else if let anyVariant = productVariants.first {
            selectedVariant = anyVariant
            selectedColourIndex = coloursList.firstIndex(where: { $0.id == anyVariant.color?.id }) ?? 0
        }
        sizesList = productVariants
            .filter { $0.color?.id == firstColorId }
            .compactMap { $0.size }
        
        selectedSizeIndex = 0
        
        colorsCollectionView.reloadData()
        sizeCollectionView.reloadData()
        productImageCollectionView.reloadData()
        
        updateVariantUI()
        
        speifcationArray = data.productSpecifications?.compactMap {
            "● \($0.nameEn ?? "") - \($0.featureEn ?? "")"
        } ?? []
        specificationTableView.reloadData()
        specificationTableViewHieghtConstraint.constant = specificationTableView.contentSize.height
    }
    
    func updateVariantUI(updateImages: Bool = true) {
        guard let variant = selectedVariant else { return }
        
        if updateImages {
            let images = variant.variantImage ?? []
            imagesPageController.numberOfPages = images.count
            imagesPageController.currentPage = 0
            productImageCollectionView.setContentOffset(CGPoint.zero, animated: false)
            productImageCollectionView.reloadData()
        }
        
        finalPriceLabel.text = "\(variant.finalPrice ?? "0") KD"
        CommonUtils.setStrikethrough(label: actualPriceLAbel, text: "\(variant.actualPrice ?? "0") KD")
        
        CommonUtils.updateDiscountPercentageLabel(discountPriceALbel,
                                                  actualAmountLabel: actualPriceLAbel,
                                                  discountType: variant.discountType,
                                                  discountValue: variant.discountValue)
        
        let value = Double(variant.discountValue ?? "0") ?? 0
        if value > 0 {
            priceSeparatorLabel.isHidden = false
        } else {
            priceSeparatorLabel.isHidden = true
        }
        
        totalStocksLabel.text = variant.totalStock ?? "0"
        skuLabel.text = variant.sku ?? "-"
        
        bustLabel.text = variant.bust ?? "-"
        waistLabel.text = variant.waist ?? "-"
        hipLabel.text = variant.hip ?? "-"
        shoulderLabel.text = variant.shoulder ?? "-"
        sleeveLenghtLabel.text = variant.sleeveLength ?? "-"
        lengthLabel.text = variant.length ?? "-"
        
        if let colorId = variant.color?.id {
            sizesList = productVariants
                .filter { $0.color?.id == colorId }
                .compactMap { $0.size }
            sizeCollectionView.reloadData()
        }
    }
    
    func convertDate(_ input: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"
        inputFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "dd/MM/yyyy"
        
        if let date = inputFormatter.date(from: input) {
            return outputFormatter.string(from: date)
        } else {
            return "Invalid date".localiz()
        }
    }
    
}

// MARK: - COLLECTION VIEW METHODS
extension ProductDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case productImageCollectionView:
            return selectedVariant?.variantImage?.count ?? 0
        case colorsCollectionView:
            return coloursList.count
        case sizeCollectionView:
            return sizesList.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case productImageCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductDetailImageCollectionViewCell", for: indexPath) as! ProductDetailImageCollectionViewCell
            if let images = selectedVariant?.variantImage, images.count > indexPath.row {
                cell.configData(variantImageUrl: images[indexPath.row])
            }
            return cell
        case colorsCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductColoursCollectionViewCell", for: indexPath) as! ProductColoursCollectionViewCell
            cell.mainView.backgroundColor = UIColor(hexString: coloursList[indexPath.row].hexCode ?? "")
            if selectedColourIndex == indexPath.row {
                cell.borderView.layer.borderColor = UIColor.darkBrown.cgColor
            } else {
                cell.borderView.layer.borderColor = UIColor.white.cgColor
            }
            return cell
        case sizeCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SizeVariantCollectionViewCell", for: indexPath) as! SizeVariantCollectionViewCell
            let size = sizesList[indexPath.row]
            cell.titleLabel.text = size.name
            if let colorId = selectedVariant?.color?.id,
               let variant = productVariants.first(where: { $0.color?.id == colorId && $0.size?.id == size.id }) {
                let stock = Int(variant.totalStock ?? "0") ?? 0
                if stock > 0 {
                    cell.titleLabel.textColor = .black
                    cell.mainView.alpha = 1.0
                    cell.mainView.layer.borderColor = (selectedSizeIndex == indexPath.row ? UIColor.darkBrown : UIColor.lightGray).cgColor
                } else {
                    cell.titleLabel.textColor = .gray
                    cell.mainView.layer.borderColor = UIColor.lightGray.cgColor
                    cell.mainView.alpha = 0.5
                }
            }
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case productImageCollectionView:
            guard let images = selectedVariant?.variantImage else { return }
            let vc = FullscreenGalleryViewController()
            vc.images = images
            vc.startIndex = indexPath.row
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true)
        case colorsCollectionView:
            selectedColourIndex = indexPath.row
            let selectedColorId = coloursList[indexPath.row].id
            if let firstInStockVariant = productVariants.first(where: { $0.color?.id == selectedColorId && (Int($0.totalStock ?? "0") ?? 0) > 0 }) {
                selectedVariant = firstInStockVariant
            } else {
                selectedVariant = productVariants.first(where: { $0.color?.id == selectedColorId })
            }
            sizesList = productVariants
                .filter { $0.color?.id == selectedColorId }
                .compactMap { $0.size }
            if let firstInStockSizeIndex = sizesList.firstIndex(where: {_ in
                if let variant = productVariants.first(where: { $0.color?.id == selectedColorId && $0.size?.id == $0.id }) {
                    return (Int(variant.totalStock ?? "0") ?? 0) > 0
                }
                return false
            }) {
                selectedSizeIndex = firstInStockSizeIndex
            } else {
                selectedSizeIndex = 0
            }
            
            colorsCollectionView.reloadData()
            sizeCollectionView.reloadData()
            updateVariantUI(updateImages: true)
        case sizeCollectionView:
            let size = sizesList[indexPath.row]
            guard let colorId = selectedVariant?.color?.id else { return }
            if let variant = productVariants.first(where: { $0.color?.id == colorId && $0.size?.id == size.id }) {
                let stock = Int(variant.totalStock ?? "0") ?? 0
                guard stock > 0 else { return }
                selectedVariant = variant
                selectedSizeIndex = indexPath.row
                updateVariantUI(updateImages: false)
                sizeCollectionView.reloadData()
            }
        default:
            print("")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case productImageCollectionView:
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        case colorsCollectionView:
            return CGSize(width: 54, height: 45)
        case sizeCollectionView:
            return CGSize(width: 55, height: 42)
        default:
            return CGSize(width: 0, height: 0)
        }
    }
    
    // MARK: - Update Page Control on Scroll
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == productImageCollectionView {
            let pageIndex = Int(round(scrollView.contentOffset.x / productImageCollectionView.frame.width))
            imagesPageController.currentPage = pageIndex
        }
    }
}

// MARK: - TABLE VIEW METHODS
extension ProductDetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case specificationTableView:
            return speifcationArray.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView {
        case specificationTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ListTableViewCell", for: indexPath) as! ListTableViewCell
            cell.titleLabel.text = speifcationArray[indexPath.row]
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        viewWillLayoutSubviews()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch tableView {
        case specificationTableView:
            return 30
        default:
            return UITableView.automaticDimension
        }
    }
}
