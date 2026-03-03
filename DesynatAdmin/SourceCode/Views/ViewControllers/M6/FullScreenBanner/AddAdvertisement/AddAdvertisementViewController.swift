//
//  AddAdvertisementViewController.swift
//  DesynatAdmin
//
//  Created by fluper on 08/01/26.
//

import UIKit
import SDWebImage

class AddAdvertisementViewController: UIViewController {
    
    @IBOutlet weak var forTypeLabel: CustomLabelFont!
    @IBOutlet weak var mainImageView: CustomImageView!
    @IBOutlet weak var toTextField: UITextField!
    @IBOutlet weak var fromTextField: UITextField!
    @IBOutlet weak var countryLabel: CustomLabelFont!
    @IBOutlet weak var titleTextField: UITextField!
    
    let datePicker = UIDatePicker()
    private var activeTextField: UITextField?
    var countryId: Int = 0
    var selectedImageUrl: String = ""
    private lazy var viewModel = AddAdvertisementViewModel(hostVC: self)
    var isComingForEdit: Bool = false
    var giftsListData: FullScreenBannerDataList?
    var onCardUpdated: ((FullScreenBannerDataList) -> Void)?
    var forTypeList = ["App Banner", "Web Banner"]
    var selectedForType: Int = 0 //type 1 mobile,2-web
    func selectedAspectRatio() -> BannerAspectRatio {
        return selectedForType == 1 ? .mobile : .web
    }
    var pickedImage: UIImage?
    var pickedGifData: Data?
    var pickedFileName: String = ""
    var isGifSelected: Bool = false
    private var isImageChanged: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTextFields()
        viewModel.getAllCountry()
        if isComingForEdit {
            bindData()
        }
    }
    
    @IBAction func countryDidTapped(_ sender: UIButton) {
        let countryNames = viewModel.countryListData.map { country -> String in
            let name = country.name ?? ""
            let dialCode = country.dialCode ?? ""
            let flag = country.flag1 ?? "🇰🇼"
            return "\(flag)  \(name) (\(dialCode))"
        }
        
        kSharedAppDelegate.dropDown(dataSource: countryNames, anchorView: sender) { index, item in
            let selectedCountry = self.viewModel.countryListData[index]
            self.countryLabel.text = selectedCountry.name
            self.countryId = selectedCountry.id ?? 0
        }
    }
    
    @IBAction func forTypeDropDownDidTapped(_ sender: UIButton) {
        kSharedAppDelegate.dropDown(dataSource: forTypeList, anchorView: sender) { index, item in
            self.forTypeLabel.text = item
            self.selectedForType = index + 1
        }
    }
    
    @IBAction func submitDidTapped(_ sender: UIButton) {
        guard viewModel.validFields() else { return }
        uploadBannerThenSubmit()
    }
    
    @IBAction func uploadImageDidTapped(_ sender: UIButton) {
        ImagePickerManager.shared.pickFromGalleryOnly(self) { [weak self]
            image, gifData, isGif, fileName, url in
            
            guard let self = self else { return }
            
            self.isImageChanged = true   // VERY IMPORTANT
            self.isGifSelected = isGif
            self.pickedFileName = fileName
            
            if isGif, let gifData = gifData {
                self.pickedGifData = gifData
                self.pickedImage = nil
                if let url = url {
                    self.mainImageView.sd_setImage(with: url)
                }
            } else if let image = image {
                self.pickedGifData = nil
                self.pickedImage = self.processCameraImage(image)
                self.mainImageView.image = self.pickedImage
            }
        }
    }
    
    private func processCameraImage(_ image: UIImage) -> UIImage {
        
        let aspect = selectedAspectRatio()
        
        let targetSize: CGSize = (aspect == .mobile)
        ? CGSize(width: 1080, height: 1920)   // Mobile 9:16
        : CGSize(width: 1920, height: 1080)   // Web 16:9
        
        let croppedImage = image.cropToAspectRatio(aspect.value)
        return croppedImage.resize(to: targetSize)
    }
    
    
    @IBAction func backDidTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func uploadBannerThenSubmit() {
        
        let keyParam: [String: Any] = ["type": selectedForType]
        
        // Edit flow WITHOUT image change
        if isComingForEdit, !isImageChanged {
            submitFinalApi()
            return
        }
        
        // GIF upload
        if isGifSelected, let gifData = pickedGifData {
            viewModel.uploadFullScreenBanner(
                file: gifData,
                isImage: false,
                isGif: true,
                keyParam: keyParam
            ) { [weak self] url in
                self?.selectedImageUrl = url
                self?.submitFinalApi()
            }
            return
        }
        
        // Image upload
        if let image = pickedImage {
            viewModel.uploadFullScreenBanner(
                file: image,
                isImage: true,
                keyParam: keyParam
            ) { [weak self] url in
                self?.selectedImageUrl = url
                self?.submitFinalApi()
            }
            return
        }
        
        // Add flow safety
        showAlert(msg: "Please select image")
    }
    
    
    private func submitFinalApi() {
        if isComingForEdit {
            viewModel.editAdvertisementApi()
        } else {
            viewModel.addAdvertisementApi()
        }
    }
    
    func bindData() {
        titleTextField.text = giftsListData?.title
        if let imageUrlString = giftsListData?.image,
           let url = URL(string: imageUrlString) {
            selectedImageUrl = imageUrlString
            mainImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            mainImageView.sd_imageIndicator?.startAnimatingIndicator()
            mainImageView.sd_setImage(with: url, placeholderImage: UIImage(named: ""))
        } else {
            mainImageView.image = UIImage(named: "placeholder")
        }
        countryLabel.text = giftsListData?.countryInfo?.name
        countryId = giftsListData?.countryInfo?.id ?? 0
        fromTextField.text = convertDateFormat(giftsListData?.startDate ?? "")
        toTextField.text = convertDateFormat(giftsListData?.endDate ?? "")
        selectedForType = (Int(giftsListData?.type ?? "1") ?? 1)
        forTypeLabel.text = forTypeList[selectedForType - 1]
        
    }
    
    func convertDateFormat(
        _ dateString: String,
        from inputFormat: String = "yyyy-MM-dd",
        to outputFormat: String = "dd/MM/yyyy"
    ) -> String? {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = inputFormat
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        guard let date = inputFormatter.date(from: dateString) else {
            return nil
        }
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = outputFormat
        outputFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        return outputFormatter.string(from: date)
    }
    
}

extension AddAdvertisementViewController {
    private func setUpTextFields() {
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .date
        datePicker.minimumDate = Date()
        datePicker.backgroundColor = .white
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneDatePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker))
        toolbar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        
        fromTextField.inputView = datePicker
        fromTextField.inputAccessoryView = toolbar
        toTextField.inputView = datePicker
        toTextField.inputAccessoryView = toolbar
        
        fromTextField.delegate = self
        toTextField.delegate = self
    }
    
    @objc private func doneDatePicker() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        
        if activeTextField == fromTextField {
            fromTextField.text = formatter.string(from: datePicker.date)
            if let toText = toTextField.text,
               let toDate = formatter.date(from: toText),
               toDate < datePicker.date {
                toTextField.text = ""
            }
        }
        
        else if activeTextField == toTextField {
            if let fromText = fromTextField.text,
               let fromDate = formatter.date(from: fromText),
               datePicker.date < fromDate {
                showValidationAlert()
                return
            }
            toTextField.text = formatter.string(from: datePicker.date)
        }
        view.endEditing(true)
    }
    
    private func showValidationAlert() {
        let alert = UIAlertController(title: "Invalid Date",
                                      message: "To Date cannot be earlier than From Date.",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }
    
    
    @objc private func cancelDatePicker() {
        view.endEditing(true)
    }
}


extension AddAdvertisementViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        if textField == toTextField {
            if let fromText = fromTextField.text,
               let fromDate = formatter.date(from: fromText) {
                datePicker.minimumDate = fromDate
            } else {
                datePicker.minimumDate = nil
            }
        }
        if textField == fromTextField {
            datePicker.minimumDate = Date()
        }
    }
}

enum BannerAspectRatio {
    case mobile   // 9:16
    case web      // 16:9
    
    var value: CGFloat {
        switch self {
        case .mobile:
            return 9.0 / 16.0
        case .web:
            return 16.0 / 9.0
        }
    }
}

extension UIImage {
    
    func cropToAspectRatio(_ ratio: CGFloat) -> UIImage {
        let width = size.width
        let height = size.height
        let currentRatio = width / height
        
        var cropRect: CGRect
        
        if currentRatio > ratio {
            let newWidth = height * ratio
            cropRect = CGRect(
                x: (width - newWidth) / 2,
                y: 0,
                width: newWidth,
                height: height
            )
        } else {
            let newHeight = width / ratio
            cropRect = CGRect(
                x: 0,
                y: (height - newHeight) / 2,
                width: width,
                height: newHeight
            )
        }
        
        guard let cgImage = cgImage?.cropping(to: cropRect) else {
            return self
        }
        
        return UIImage(cgImage: cgImage, scale: scale, orientation: imageOrientation)
    }
    
    func resize(to targetSize: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: targetSize))
        }
    }
}
