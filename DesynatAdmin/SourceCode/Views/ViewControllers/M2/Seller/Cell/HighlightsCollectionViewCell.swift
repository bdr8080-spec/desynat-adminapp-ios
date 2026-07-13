//
//  HighlightsCollectionViewCell.swift
//  DesynatAdmin
//
//  Created by Meet Goti on 10/11/25.
//

import UIKit
import SDWebImage

class HighlightsCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var mainImageView: CustomImageView!
    @IBOutlet weak var lblTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configData(data: GetHighLightsList?){
        let fileString = data?.highlights?.first?.file ?? ""
        let thumbnailString = data?.highlights?.first?.thumbnail ?? ""
        let isVideo = fileString.lowercased().contains(".mp4")
        let finalURLString = isVideo ? thumbnailString : fileString
        let url = URL(string: finalURLString)
        mainImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        mainImageView.sd_imageIndicator?.startAnimatingIndicator()
        mainImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"))
        lblTitle.text = data?.title
    }
    
}
