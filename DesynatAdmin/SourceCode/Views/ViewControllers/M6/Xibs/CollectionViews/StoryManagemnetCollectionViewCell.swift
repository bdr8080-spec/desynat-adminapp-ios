//
//  StoryManagemnetCollectionViewCell.swift
//  DesynatAdmin
//
//  Created by fluper on 07/01/26.
//

import UIKit
import AVFoundation
import SDWebImage

class StoryManagemnetCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var playPauseImageView: UIImageView!
    @IBOutlet weak var mainImageView: CustomImageView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var postedDateLabel: UILabel!
    
    var onDeleteToggle:(() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupOverlay()
    }
    
    @IBAction func deleteDidTapped(_ sender: Any) {
        onDeleteToggle?()
    }
    
    private let overlayView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.2) // 10% black
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = false
        return view
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        mainImageView.image = UIImage(named: "placeholder")
        playPauseImageView.isHidden = true
        mainImageView.sd_cancelCurrentImageLoad() // cancel SDWebImage load
    }
    
    
    private func setupOverlay() {
        mainImageView.addSubview(overlayView)
        NSLayoutConstraint.activate([
            overlayView.leadingAnchor.constraint(equalTo: mainImageView.leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: mainImageView.trailingAnchor),
            overlayView.topAnchor.constraint(equalTo: mainImageView.topAnchor),
            overlayView.bottomAnchor.constraint(equalTo: mainImageView.bottomAnchor)
        ])
    }
    
    func configData(data: AdminStoriesList?) {
        guard let data = data else { return }
        
        postedDateLabel.text = formatDateString(data.createdAt ?? "")
        statusLabel.text = data.status == 1 ? "Active".localiz() : "Inactive".localiz()
        
        let fileString = data.file ?? ""
        let thumbnailString = data.thumbnail ?? ""
        
        // Detect video by extension
        let fileExtension = URL(string: fileString)?.pathExtension.lowercased() ?? ""
        let isVideo = ["mp4", "mov", "m4v"].contains(fileExtension)
        
        // Show play icon only for video
        playPauseImageView.isHidden = !isVideo
        
        // Load thumbnail for video, image for normal file
        let finalURLString = isVideo ? thumbnailString : fileString
        let url = URL(string: finalURLString)
        
        if !isVideo {
            mainImageView.enableFullscreenZoom()
        }
        
        mainImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        mainImageView.sd_imageIndicator?.startAnimatingIndicator()
        
        mainImageView.sd_setImage(
            with: url,
            placeholderImage: UIImage(named: "placeholder")
        )
    }
    
    // MARK: - Load Image from URL
    private func loadImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async {
                self?.mainImageView.image = UIImage(data: data)
            }
        }.resume()
    }
    
    func formatDateString(_ isoDate: String) -> String? {
        // 1. Create ISO8601 DateFormatter
        let isoFormatter = DateFormatter()
        isoFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"
        isoFormatter.locale = Locale(identifier: "en_US_POSIX")
        isoFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        // 2. Convert string to Date
        guard let date = isoFormatter.date(from: isoDate) else {
            return nil
        }
        
        // 3. Format date to desired format
        let displayFormatter = DateFormatter()
        displayFormatter.dateFormat = "dd/MM/yyyy, hh:mma" // 12-hour format with AM/PM
        displayFormatter.locale = Locale(identifier: "en_US_POSIX")
        displayFormatter.timeZone = TimeZone.current // or specify a time zone if needed
        
        return displayFormatter.string(from: date)
    }
    
    private func generateThumbnail(url: URL, completion: @escaping (UIImage?) -> Void) {
        let asset = AVAsset(url: url)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        imageGenerator.appliesPreferredTrackTransform = true
        imageGenerator.requestedTimeToleranceBefore = .zero
        imageGenerator.requestedTimeToleranceAfter = .zero
        
        // ── Most important change ──
        let secondsToTry: Double = 1.5     // ← try 1.0, 1.5, 2.0, 3.0 — pick what looks best for your videos
        let time = CMTime(seconds: secondsToTry, preferredTimescale: 600)
        
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                let cgImage = try imageGenerator.copyCGImage(at: time, actualTime: nil)
                let thumbnail = UIImage(cgImage: cgImage)
                
                DispatchQueue.main.async {
                    completion(thumbnail)
                }
            } catch {
                print("Thumbnail generation failed at \(secondsToTry)s → \(error)")
                
                // Fallback: try at 0.5s or just show placeholder
                DispatchQueue.main.async {
                    completion(UIImage(named: "placeholder"))
                }
            }
        }
    }
    
}

