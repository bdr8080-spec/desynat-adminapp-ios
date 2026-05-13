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
    @IBOutlet weak var noDataFoundLabel: UILabel!
    
    // MARK: - Property Decalaration
    var galleryAssets: [PHAsset] = []
    private lazy var viewModel = AddStoryViewModel(hostVC: self)
    var thumbnailImage: String?
    
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
        
        switch status {
        case .authorized:
            loadAssets()
            
        case .limited:
            updateUI(for: .limitedAccess)
            loadAssets()
            
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { newStatus in
                if newStatus == .authorized || newStatus == .limited {
                    self.fetchGalleryAssets()
                } else {
                    self.updateUI(for: .denied)
                }
            }
            
        case .restricted, .denied:
            updateUI(for: .denied)
            
        @unknown default:
            updateUI(for: .denied)
        }
    }
    
    func loadAssets() {
        galleryAssets.removeAll()
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        let allAssets = PHAsset.fetchAssets(with: fetchOptions)
        allAssets.enumerateObjects { asset, _, _ in
            self.galleryAssets.append(asset)
        }
        
        if galleryAssets.isEmpty {
            updateUI(for: .noData)
        } else {
            updateUI(for: .hasData)
        }
        
        DispatchQueue.main.async {
            self.contentCollectionView.reloadData()
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
                  let image = image else { return }
            
            DispatchQueue.main.async {
                let vc = UploadPostViewController.instantiate(fromAppStoryboard: .LiveStoryDealManagement)
                vc.selectedImage = image   // ✅ pass image
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    private func handleVideoAsset(_ asset: PHAsset) {
        
        let options = PHVideoRequestOptions()
        options.deliveryMode = .highQualityFormat
        
        PHImageManager.default().requestAVAsset(forVideo: asset, options: options) { [weak self] avAsset, _, _ in
            
            guard let self = self,
                  let urlAsset = avAsset as? AVURLAsset else { return }
            
            let videoURL = urlAsset.url
            
            // Generate thumbnail
            CommonUtils.generateThumbnail(url: videoURL) { thumbnail in
                guard let data = thumbnail?.jpegData(compressionQuality: 0.25) else { return }
                self.viewModel.uploadMediaForGettingThumbnailImageUrl(fileData: data, isImage: true) {
                    DispatchQueue.main.async {
                        DispatchQueue.main.async {
                            let vc = UploadPostViewController.instantiate(fromAppStoryboard: .LiveStoryDealManagement)
                            vc.selectedImage = thumbnail
                            vc.videoURL = videoURL   // ✅ IMPORTANT
                            
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                    }
                }
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
        
        // ✅ IMAGE CASE
        if let image = info[.originalImage] as? UIImage {
            
            let vc = UploadPostViewController.instantiate(fromAppStoryboard: .LiveStoryDealManagement)
            vc.selectedImage = image
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        // ✅ VIDEO CASE (🔥 FIX HERE)
        else if let videoURL = info[.mediaURL] as? URL {
            
            CommonUtils.generateThumbnail(url: videoURL) { thumbnail in
                guard let data = thumbnail?.jpegData(compressionQuality: 0.25) else { return }
                self.viewModel.uploadMediaForGettingThumbnailImageUrl(fileData: data, isImage: true) {
                    DispatchQueue.main.async {
                        DispatchQueue.main.async {
                            let vc = UploadPostViewController.instantiate(fromAppStoryboard: .LiveStoryDealManagement)
                            vc.selectedImage = thumbnail
                            vc.videoURL = videoURL   // ✅ IMPORTANT
                            
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                    }
                }
            }
        }
    }
    
    func updateUI(for state: GalleryState) {
        DispatchQueue.main.async {
            switch state {
            case .loading:
                self.noDataFoundLabel.isHidden = true
                self.contentCollectionView.isHidden = true
                
            case .hasData:
                self.noDataFoundLabel.isHidden = true
                self.contentCollectionView.isHidden = false
                
            case .noData:
                self.noDataFoundLabel.text = "No photos or videos found.".localiz()
                self.noDataFoundLabel.isHidden = false
                self.contentCollectionView.isHidden = true
                
            case .limitedAccess:
                self.noDataFoundLabel.text = "You have allowed limited access to your gallery.\nPlease select more photos.".localiz()
                self.noDataFoundLabel.isHidden = false
                self.contentCollectionView.isHidden = false
                
            case .denied:
                self.noDataFoundLabel.text = "Gallery permission denied.\nPlease allow access in Settings.".localiz()
                self.noDataFoundLabel.isHidden = false
                self.contentCollectionView.isHidden = true
            }
        }
    }
    
}


enum GalleryState {
    case loading
    case hasData
    case noData
    case limitedAccess
    case denied
}
