//
//  ReelsCollectionViewCell.swift
//  DesynatAdmin
//
//  Created by Meet Goti on 10/11/25.
//

import UIKit
import SDWebImage

class ReelsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var mainImageView: CustomImageView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    var currentVideoURL: URL?
    var onPlayTapped: (()-> Void)?
    var onDeleteTapped: (()-> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func deleteButtonTapped(_ sender: UIButton) {
        onDeleteTapped?()
    }

    
    @IBAction func playButtonTapped(_ sender: UIButton) {
        onPlayTapped?()
    }
    
    func configData(data: GetMyReelsList?){
        let fileString = data?.file ?? ""
        let thumbnailString = data?.thumbnail ?? ""
        
        // Detect video
        let isVideo = fileString.lowercased().contains(".mp4")
        playButton.isHidden = !isVideo
        // Decide which URL to load
        let finalURLString = isVideo ? thumbnailString : fileString
        let url = URL(string: finalURLString)
        mainImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        mainImageView.sd_imageIndicator?.startAnimatingIndicator()
        
        // Set image
        mainImageView.sd_setImage(
            with: url,
            placeholderImage: UIImage(named: "placeholder")
        )
    }
    
}

