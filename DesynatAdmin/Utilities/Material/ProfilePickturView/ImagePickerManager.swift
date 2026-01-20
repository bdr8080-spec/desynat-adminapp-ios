//
//  ImageDocumentHelper.swift
//  ClupPeRestaurant
//
//  Created by Fluper on 08/02/24.
//
import Foundation
import MobileCoreServices
import UIKit
import AVFoundation
import Photos

class ImagePickerManager: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIDocumentPickerDelegate {
    
    static let shared = ImagePickerManager()
//    var lastImageSource: ImageSourceType = .unknown
    var picker = UIImagePickerController()
    lazy var alert = UIAlertController(title: "Choose File", message: nil, preferredStyle: .actionSheet) // ✅ lazy to prevent crash
    var viewController: UIViewController?
    var pickImageCallback: ((UIImage, String, URL?) -> ())?
    var allowPDFSelection: Bool = false
  var pickGalleryCallback: ((UIImage?, Data?, Bool, String, URL?) -> ())?
    // MARK: - Init
    override init() {
        super.init()
        picker.delegate = self
    }
  
  private func setupAlert() {
      alert = UIAlertController(title: "Choose File", message: nil, preferredStyle: .actionSheet)

      let cameraAction = UIAlertAction(title: "Camera", style: .default) { _ in
          self.openCamera()
      }

      let galleryAction = UIAlertAction(title: "Gallery", style: .default) { _ in
          self.openGallery()
      }

      // ✅ PDF option — only if allowed
      if allowPDFSelection {
          let pdfAction = UIAlertAction(title: "PDF / Files", style: .default) { _ in
              self.openDocumentPicker()
          }
          alert.addAction(pdfAction)
      }

      let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

      alert.addAction(cameraAction)
      alert.addAction(galleryAction)
      alert.addAction(cancelAction)
  }

  func openDocumentPicker() {
      alert.dismiss(animated: true)
      initializeDocument()
  }


    // MARK: - Pick Image
    func pickImage(_ viewController: UIViewController, _ callback: @escaping ((UIImage, String, URL?) -> ())) {
        pickImageCallback = callback
        self.viewController = viewController
        setupAlert()
        alert.popoverPresentationController?.sourceView = viewController.view
        viewController.present(alert, animated: true)
    }
  
  func pickFromGalleryOnly(
      _ viewController: UIViewController,
      callback: @escaping ((UIImage?, Data?, Bool, String, URL?) -> ())
  ) {
      self.viewController = viewController

      picker = UIImagePickerController()
      picker.delegate = self
      picker.sourceType = .photoLibrary
      picker.mediaTypes = ["public.image", "com.compuserve.gif"] // ✅ Image + GIF

      self.pickGalleryCallback = callback
      viewController.present(picker, animated: true)
  }

    
    // MARK: - Camera
    func openCamera() {
        alert.dismiss(animated: true, completion: nil)
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
            viewController?.present(picker, animated: true)
        } else {
            let alertController = UIAlertController(
                title: "Warning",
                message: "You don't have a camera",
                preferredStyle: .alert
            )
            alertController.addAction(UIAlertAction(title: "OK", style: .default))
            viewController?.present(alertController, animated: true)
        }
    }
    
    // MARK: - Gallery
    func openGallery() {
        alert.dismiss(animated: true, completion: nil)
        picker.sourceType = .photoLibrary
        viewController?.present(picker, animated: true)
    }
    
    // MARK: - Image Picker Delegates
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
//    
//  func imagePickerController(
//      _ picker: UIImagePickerController,
//      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
//  ) {
//      picker.dismiss(animated: true)
//
//      // ✅ Detect GIF
//      if let imageURL = info[.imageURL] as? URL,
//         imageURL.pathExtension.lowercased() == "gif" {
//
//          if let gifData = try? Data(contentsOf: imageURL) {
//              let fileName = imageURL.lastPathComponent
//              pickGalleryCallback?(nil, gifData, true, fileName, imageURL)
//              return
//          }
//      }
//
//      // ✅ Normal image
//      if let image = info[.originalImage] as? UIImage {
//          let fileName = UUID().uuidString + ".jpg"
//          pickGalleryCallback?(image, nil, false, fileName, nil)
//      }
//  }

    
//  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//      picker.dismiss(animated: true, completion: nil)
//          guard let image = info[.originalImage] as? UIImage else { return }
//          // ✅ Save image to temporary folder
//          let fileName = UUID().uuidString + ".jpg"
//          let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)
//          if let data = image.jpegData(compressionQuality: 0.8) {
//              try? data.write(to: tempURL)
//          }
//          // ✅ Provide valid URL to callback
//          pickImageCallback?(image, fileName, tempURL)
//  }
  func imagePickerController(
      _ picker: UIImagePickerController,
      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
  ) {
      picker.dismiss(animated: true)

      // ==================================================
      // ✅ NEW FLOW — Gallery only (Image + GIF)
      // ==================================================
      if let galleryCallback = pickGalleryCallback {

          // GIF
          if let imageURL = info[.imageURL] as? URL,
             imageURL.pathExtension.lowercased() == "gif",
             let gifData = try? Data(contentsOf: imageURL) {

              let fileName = imageURL.lastPathComponent
              galleryCallback(nil, gifData, true, fileName, imageURL)
              pickGalleryCallback = nil
              return
          }

          // Normal image
          if let image = info[.originalImage] as? UIImage {
              let fileName = UUID().uuidString + ".jpg"
              galleryCallback(image, nil, false, fileName, nil)
              pickGalleryCallback = nil
              return
          }
      }

      // ==================================================
      // ✅ OLD FLOW — Camera / Gallery (IMAGE ONLY)
      // ==================================================
      if let image = info[.originalImage] as? UIImage {

          let fileName = UUID().uuidString + ".jpg"
          let tempURL = FileManager.default
              .temporaryDirectory
              .appendingPathComponent(fileName)

          if let data = image.jpegData(compressionQuality: 0.8) {
              try? data.write(to: tempURL)
          }

          pickImageCallback?(image, fileName, tempURL)
          pickImageCallback = nil
      }
  }


}

extension ImagePickerManager {
    // MARK: - Document Picker
    private func initializeDocument() {
        let doc = UIDocumentPickerViewController(forOpeningContentTypes: [.pdf])
        doc.delegate = self
        viewController?.present(doc, animated: true)
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        controller.dismiss(animated: true)
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        for url in urls {
            defer { url.stopAccessingSecurityScopedResource() }
            guard url.startAccessingSecurityScopedResource() else { return }
            pickImageCallback?(UIImage(), "", url)
        }
    }
    
//    func getImageSource(from info: [UIImagePickerController.InfoKey : Any],
//                        picker: UIImagePickerController) -> ImageSourceType {
//
//        if picker.sourceType == .camera {
//            return .camera
//        }
//
//        if picker.sourceType == .photoLibrary {
//            return .gallery
//        }
//
//        return .unknown
//    }

}

// MARK: - Permissions
extension ImagePickerManager {
    func requestMediaPermissions() {
        DispatchQueue.main.async {
            // Camera Permission
            AVCaptureDevice.requestAccess(for: .video) { granted in
                print("📷 Camera permission granted: \(granted)")
            }
            
            // Photo Library Permission
            PHPhotoLibrary.requestAuthorization { status in
                print("🖼️ Photo Library permission status: \(status.rawValue)")
            }
        }
    }
}

//enum ImageSourceType {
//    case camera
//    case gallery
//    case unknown
//}

