//
//  AddAdvertisementViewController.swift
//  DesynatAdmin
//
//  Created by fluper on 08/01/26.
//

import UIKit
import SDWebImage

class AddAdvertisementViewController: UIViewController {

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
  
  @IBAction func submitDidTapped(_ sender: UIButton) {
    if viewModel.validFields() {
      if isComingForEdit {
        viewModel.editAdvertisementApi()
      } else{
        viewModel.addAdvertisementApi()
      }
    }
  }
  
  @IBAction func uploadImageDidTapped(_ sender: UIButton) {
    ImagePickerManager().pickImage(self) { [weak self] image, fileName, url in
        guard let self = self else { return }
        DispatchQueue.main.async {
            self.mainImageView.image = image
        }
        guard let compressedImage = image.jpegData(compressionQuality: 0.25),
                      let finalImage = UIImage(data: compressedImage) else {
                    return
                }
        self.viewModel.uploadDocument(file: finalImage, isImage: true) { [weak self] uploadedUrl in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.selectedImageUrl = uploadedUrl
            }
        }
    }
  }
  
  @IBAction func backDidTapped(_ sender: UIButton) {
    self.navigationController?.popViewController(animated: true)
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
    datePicker.minimumDate = nil
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
      datePicker.minimumDate = nil
    }
  }
}
