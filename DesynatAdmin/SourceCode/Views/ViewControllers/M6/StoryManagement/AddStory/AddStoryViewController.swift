//
//  AddStoryViewController.swift
//  DesynatAdmin
//
//  Created by fluper on 07/01/26.
//

import UIKit
import Photos

class AddStoryViewController: UIViewController {
    
    // MARK: - IBOutlet's
    @IBOutlet weak var contentCollectionView: UICollectionView! {
        didSet {
            contentCollectionView.registerCellFromNib(cellID: "SelectVideoFromGalleryCollectionViewCell")
        }
    }
    
    // MARK: - Property Decalaration
    var galleryAssets: [PHAsset] = []
    private lazy var viewModel = AddStoryViewModel(hostVC: self)
    
    // MARK: - View's LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchGalleryAssets()
    }
    
    // MARK: - Button's Action
    @IBAction func backDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func cameraDidTapped(_ sender: Any) {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            print("Camera not available")
            return
        }
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .camera
        picker.mediaTypes = ["public.image", "public.movie"] // allow image & video
        picker.videoQuality = .typeHigh
        picker.allowsEditing = false
        
        present(picker, animated: true)
    }
    
    //MARK: Function's declaration
    func fetchGalleryAssets() {
        let status = PHPhotoLibrary.authorizationStatus()
        if status == .authorized || status == .limited {
            let fetchOptions = PHFetchOptions()
            fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            let allAssets = PHAsset.fetchAssets(with: fetchOptions)
            allAssets.enumerateObjects { asset, _, _ in
                self.galleryAssets.append(asset)
            }
            DispatchQueue.main.async {
                self.contentCollectionView.reloadData()
            }
        } else if status == .notDetermined {
            PHPhotoLibrary.requestAuthorization { newStatus in
                if newStatus == .authorized || newStatus == .limited {
                    self.fetchGalleryAssets()
                }
            }
        } else {
            // Handle denied or restricted
            print("Access to photo library denied.")
        }
    }
    
    
}

// MARK: - COLLECTION VIEW METHODS
extension AddStoryViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return galleryAssets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectVideoFromGalleryCollectionViewCell", for: indexPath) as! SelectVideoFromGalleryCollectionViewCell
        
        let asset = galleryAssets[indexPath.item]
        let cellSize = CGSize(width: cell.frame.width, height: cell.frame.height)
        
        CommonUtils.getThumbnail(asset: asset, size: cellSize) { image in
            DispatchQueue.main.async {
                cell.mainImageView.image = image
            }
        }
        
        // Optional: indicate if asset is video
        if asset.mediaType == .video {
            cell.playPauseImageView.isHidden = false // add a play icon in your cell
        } else {
            cell.playPauseImageView.isHidden = true
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let asset = galleryAssets[indexPath.item]
        
        if asset.mediaType == .image {
            handleImageAsset(asset)
        } else if asset.mediaType == .video {
            handleVideoAsset(asset)
        }
    }
    
    private func handleImageAsset(_ asset: PHAsset) {
        
        let options = PHImageRequestOptions()
        options.isSynchronous = false
        options.deliveryMode = .highQualityFormat
        
        PHImageManager.default().requestImage(
            for: asset,
            targetSize: CGSize(width: 1080, height: 1080),
            contentMode: .aspectFill,
            options: options
        ) { [weak self] image, _ in
            guard let self = self,
                  let image = image,
                  let imageData = image.jpegData(compressionQuality: 0.25) else { return }
            
            self.viewModel.uploadMedia(
                fileData: imageData,
                isImage: true
            )
        }
    }
    
    private func handleVideoAsset(_ asset: PHAsset) {
        
        let options = PHVideoRequestOptions()
        options.deliveryMode = .highQualityFormat
        
        PHImageManager.default().requestAVAsset(forVideo: asset, options: options) { [weak self] avAsset, _, _ in
            guard let self = self,
                  let urlAsset = avAsset as? AVURLAsset else { return }
            
            do {
                let videoData = try Data(contentsOf: urlAsset.url)
                DispatchQueue.main.async {
                    self.viewModel.uploadMedia(fileData: videoData, isImage: false)
                }
            } catch {
                print("Failed to read video data:", error)
            }
        }
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spacing: CGFloat = 10
        let totalSpacing = spacing * 2 // 3 cells per row → 2 spaces between
        let width = (collectionView.frame.width - totalSpacing) / 3
        return CGSize(width: width, height: 132)
    }
}

extension AddStoryViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true)
        
        // Handle image
        if let image = info[.originalImage] as? UIImage {
            guard let imageData = image.jpegData(compressionQuality: 0.25) else { return }
            self.viewModel.uploadMedia(fileData: imageData, isImage: true)
            
        }
        // Handle video
        else if let videoURL = info[.mediaURL] as? URL {
            // compress and then upload
            compressAndUploadVideo(videoURL: videoURL)
        }
    }
    
    func compressAndUploadVideo(videoURL: URL) {
        let avAsset = AVURLAsset(url: videoURL)
        
        // Use medium quality preset for compression
        guard let exportSession = AVAssetExportSession(asset: avAsset,
                                                       presetName: AVAssetExportPresetMediumQuality) else {
            print("Failed to create export session")
            return
        }
        
        // Temporary file for compressed video
        let outputURL = FileManager.default.temporaryDirectory
            .appendingPathComponent("compressed_\(UUID().uuidString).mov")
        
        exportSession.outputURL = outputURL
        exportSession.outputFileType = .mov
        exportSession.shouldOptimizeForNetworkUse = true
        
        exportSession.exportAsynchronously {
            switch exportSession.status {
            case .completed:
                do {
                    let videoData = try Data(contentsOf: outputURL)
                    
                    // Call your existing upload method
                    DispatchQueue.main.async {
                        self.viewModel.uploadMedia(fileData: videoData, isImage: false)
                    }
                } catch {
                    print("Failed to read compressed video data:", error)
                }
                
            case .failed, .cancelled:
                print("Video compression failed:", exportSession.error ?? "Unknown error")
            default:
                break
            }
        }
    }
    
}
