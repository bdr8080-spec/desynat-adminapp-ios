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
    
    var picker = UIImagePickerController()
    lazy var alert = UIAlertController(title: "Choose File", message: nil, preferredStyle: .actionSheet) // ✅ lazy to prevent crash
    var viewController: UIViewController?
    var pickImageCallback: ((UIImage, String, URL?) -> ())?
    var allowPDFSelection: Bool = false
    
    // MARK: - Init
    override init() {
        super.init()
        picker.delegate = self
    }
    
    // MARK: - Setup Alert
//    private func setupAlert() {
//        alert = UIAlertController(title: "Choose File", message: nil, preferredStyle: .actionSheet)
//
//        let cameraAction = UIAlertAction(title: "Camera", style: .default) { _ in
//            self.openCamera()
//        }
//
//        let galleryAction = UIAlertAction(title: "Gallery", style: .default) { _ in
//            self.openGallery()
//        }
//
//        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
//
//        alert.addAction(cameraAction)
//        alert.addAction(galleryAction)
//        alert.addAction(cancelAction)
//    }
  
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        guard let image = info[.originalImage] as? UIImage else {
            print("❌ Could not get image from picker info")
            return
        }
        let fileName = UUID().uuidString + ".jpg"
        pickImageCallback?(image, fileName, nil)
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
