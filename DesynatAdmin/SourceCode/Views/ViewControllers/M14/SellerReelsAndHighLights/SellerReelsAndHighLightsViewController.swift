//
//  SellerReelsAndHighLightsViewController.swift
//  DesynatAdmin
//
//  Created by fluper_mac2 on 18/05/26.
//

import UIKit
import SDWebImage
import AVFoundation
import AVKit

class SellerReelsAndHighLightsViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var imageView: CustomImageView!
    @IBOutlet weak var captiontxtArea: UILabel!
    @IBOutlet weak var captionView: UIView!
    @IBOutlet weak var playVideoButton: UIButton!
    @IBOutlet weak var addedDateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var highLightsView: UIView!
    @IBOutlet weak var highLightsTitleLabel: UILabel!
    
    // MARK: - Properties
    private lazy var viewModel = SellerReelsAndHighLightsViewModel(hostVC: self)
    private var videoURL: URL?
    private let activityIndicator = UIActivityIndicatorView(style: .medium)
    var reelsData: GetMyReelsList?
    var thumbnailImage: String?
    var comingReason : ComingReasonAtViewReels = .sellerReels
    var highlights: GetHighLightsList?
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        switch comingReason {
        case .sellerReels:
            titleLabel.text = "Reel"
            highLightsView.isHidden = true
            captionView.isHidden = false
            configData()
        case .sellerHightLights:
            titleLabel.text = "Highlights"
            highLightsView.isHidden = false
            captionView.isHidden = true
            configHighlightsData()
        }
    }
    
    private func setupUI() {
        captionView.layer.cornerRadius = 12
        captionView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        captionView.clipsToBounds = true
        
        // Setup Loader
        activityIndicator.color = .gray
        activityIndicator.hidesWhenStopped = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        imageView.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: imageView.centerYAnchor)
        ])
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
    }
    func saveImageAndGetURLString(_ image: UIImage?) -> String? {
        //  Check image exists
        guard let image = image,
              let data = image.jpegData(compressionQuality: 0.7) else {
            return nil
        }
        
        let fileName = "thumb_\(UUID().uuidString).jpg"
        let fileURL = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)
        
        do {
            try data.write(to: fileURL)
            return fileURL.absoluteString
        } catch {
            return nil
        }
    }
    
    // MARK: - Config Data (For Existing Reel)
    func configData() {
        guard let data = reelsData else { return }
        captiontxtArea.text = data.caption ?? ""
        addedDateLabel.text = formatAddedOnDate(data.createdAt ?? "")
        
        let fileString = data.file ?? ""
        let thumbnailString = data.thumbnail ?? ""
        
        // Detect video
        let isVideo = fileString.lowercased().contains(".mp4")
        
        // Decide which URL to load
        let finalURLString = isVideo ? thumbnailString : fileString
        let url = URL(string: finalURLString)
        if isVideo {
            videoURL = URL(string: data.file ?? "")
        }
        playVideoButton.isHidden = !isVideo
        // Loader
        imageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        imageView.sd_imageIndicator?.startAnimatingIndicator()
        
        // Set image
        imageView.sd_setImage(
            with: url,
            placeholderImage: UIImage(named: "editUploaddReel")
        )
    }
    
    func configHighlightsData() {
        guard let data = highlights else { return }
        highLightsTitleLabel.text = data.title ?? ""
        
        let fileString = data.file ?? ""
        let thumbnailString = data.thumbnail ?? ""
        
        // Detect video
        let isVideo = fileString.lowercased().contains(".mp4")
        
        // Decide which URL to load
        let finalURLString = isVideo ? thumbnailString : fileString
        let url = URL(string: finalURLString)
        if isVideo {
            videoURL = URL(string: data.file ?? "")
        }
        playVideoButton.isHidden = !isVideo
        // Loader
        imageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        imageView.sd_imageIndicator?.startAnimatingIndicator()
        
        // Set image
        imageView.sd_setImage(
            with: url,
            placeholderImage: UIImage(named: "editUploaddReel")
        )
    }
    
    
    // MARK: - Date Formatter (unchanged)
    func formatAddedOnDate(_ input: String) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"
        
        guard let date = formatter.date(from: input) else {
            return "Added On -".localiz()
        }
        
        let outputFormatter = DateFormatter()
        outputFormatter.locale = Locale(identifier: "en_US_POSIX")
        outputFormatter.dateFormat = "dd/MM/yyyy"
        
        let formatted = outputFormatter.string(from: date)
        let text = "Added On".localiz()
        return "\(text) \(formatted)"
    }
    
    // MARK: - Actions (unchanged)
    @IBAction func backbtnTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func playBtnOfVideo(_ sender: Any) {
        guard let url = videoURL else { return }
        let player = AVPlayer(url: url)
        let vc = AVPlayerViewController()
        vc.player = player
        present(vc, animated: true) {
            player.play()
        }
    }
    
    @IBAction func deleteDidTapped(_ sender: Any) {
        switch comingReason {
        case .sellerHightLights:
            self.showConfirmationAlert(msg: "Are you sure you want to delete this highlights?".localiz()) { [weak self] in
                guard let self = self else { return }
                self.viewModel.deleteReel()
            }
        case .sellerReels:
            self.showConfirmationAlert(msg: "Are you sure you want to delete this reel?".localiz()) { [weak self] in
                guard let self = self else { return }
                self.viewModel.deleteReel()
            }
        }
    }
}

enum ComingReasonAtViewReels {
    case sellerHightLights
    case sellerReels
}
