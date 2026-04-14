//
//  ProductManagementTableViewCell.swift
//  DesynatDealer
//
//  Created by fluper on 19/11/25.
//

import UIKit
import SDWebImage

class ProductManagementTableViewCell: UITableViewCell {
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var statusButton: UIButton!
    @IBOutlet weak var colorsCollectionView: UICollectionView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var orifinalPriceLabel: UILabel!
    @IBOutlet weak var dirscountPriceLabel: CustomLabelFont!
    @IBOutlet weak var discuntPercentageLabel: UILabel!
    @IBOutlet weak var productImageView: CustomImageView!
    @IBOutlet weak var locationLaebl: UILabel!
    
    var onStatusToggle: (() -> Void)?
    var coloursList: [Color]?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        colorsCollectionView.delegate = self
        colorsCollectionView.dataSource = self
        colorsCollectionView.registerCellFromNib(cellID: "ColorsCollectionViewCell")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func statusDidTapped(_ sender: Any) {
        onStatusToggle?()
    }
    
    func configData(data: ProductsList?) {
        var colorsArray: [Color] = []
        if let variants = data?.productVariants {
            var seenHexCodes = Set<String>()
            for variant in variants {
                if let color = variant.color, let hex = color.hexCode, !seenHexCodes.contains(hex) {
                    colorsArray.append(color)
                    seenHexCodes.insert(hex)
                }
            }
        }
        self.coloursList = colorsArray
        colorsCollectionView.reloadData()
        
        if data?.brand?.nameEnglish == "Other" {
            productNameLabel.text = data?.otherEn
        } else {
            productNameLabel.text = data?.brand?.nameEnglish
        }
        descriptionLabel.text = data?.productNameEn
        if let imageUrlString = data?.productVariants?.first?.variantImage?.first,
           let url = URL(string: imageUrlString) {
            productImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            productImageView.sd_imageIndicator?.startAnimatingIndicator()
            productImageView.sd_setImage(with: url, placeholderImage: UIImage(named: ""))
        } else {
            productImageView.image = UIImage(named: "")
        }
        
        ratingLabel.text = "(\(data?.reviewRating ?? "0"))"
        orifinalPriceLabel.text = "\(data?.productVariants?.first?.finalPrice ?? "") KD"
        CommonUtils.setStrikethrough(label: dirscountPriceLabel, text: "\(data?.productVariants?.first?.actualPrice ?? "") KD")
        CommonUtils.updateDiscountPercentageLabel(discuntPercentageLabel,
                                                  actualAmountLabel: dirscountPriceLabel,
                                                  discountType: data?.productVariants?.first?.discountType,
                                                  discountValue: data?.productVariants?.first?.discountValue)
        if data?.productActiveStatus == 1 {
            statusButton.setImage(UIImage(named: "toggleOn"), for: .normal)
        } else {
            statusButton.setImage(UIImage(named: "toggleOff"), for: .normal)
        }
        
        locationLaebl.text = data?.store?.countryInfo?.name
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
            return "Invalid date"
        }
    }
    
}

// MARK: - COLLECTION VIEW METHODS
extension ProductManagementTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return coloursList?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorsCollectionViewCell", for: indexPath) as! ColorsCollectionViewCell
        if let colorHex = coloursList?[indexPath.item].hexCode {
            cell.mainView.backgroundColor = UIColor(hexString: colorHex)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 18, height: 18)
    }
}

