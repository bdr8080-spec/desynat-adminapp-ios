//
//  TicketManagementDetailsViewController.swift
//  DesynatAdmin
//
//  Created by fluper_mac3 on 26/03/26.
//

import UIKit
import SDWebImage

class TicketManagementDetailsViewController: UIViewController {
    
    @IBOutlet weak var attachmnetButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var requestedByLbl: UILabel!
    @IBOutlet weak var ticketStatusLbl: UILabel!
    @IBOutlet weak var ticketIdLbl: UILabel!
    @IBOutlet weak var submittedBy: UILabel!
    @IBOutlet weak var ticketTypeLabel: UILabel!
    @IBOutlet weak var raisedOnLabel: UILabel!
    @IBOutlet weak var titleLabel: CustomLabelFont!
    @IBOutlet weak var descriptionLabel: CustomLabelFont!
    @IBOutlet weak var attachmnetImageView: CustomImageView!
    @IBOutlet weak var attachmentStackView: UIStackView!
    @IBOutlet weak var resolvedOnDateLabel: UILabel!
    @IBOutlet weak var resolvedOnStackView: UIStackView!
    @IBOutlet weak var statusUpdateTF: UITextField!
    @IBOutlet weak var statusUpdateStackView: UIStackView!
    @IBOutlet weak var updateStatusButtonView: UIStackView!
    
    var ticketDetails: TicketManagementList?
    var ticketType: TiketListType = .newList
    var statusUpdate = ["Pending".localiz(), "Resolved".localiz()]
    var selectedStatusIndex: Int? = -1
    var isStatusUpdated: (() -> Void)?
    private lazy var viewModel = TicketManagementDetailsViewModel(hostVC: self)
    var hasActionPermission: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configData()
        statusUpdateStackView.isHidden = !hasActionPermission
        updateStatusButtonView.isHidden = !hasActionPermission
    }
    
    @IBAction func statusDidTapped(_ sender: UIButton) {
        let buttonFrame = sender.convert(sender.bounds, to: scrollView)
            
        let currentOffset = scrollView.contentOffset.y
            scrollView.setContentOffset(CGPoint(x: 0, y: currentOffset + 100), animated: true)
            // Show dropdown AFTER slight delay (important)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                let statusName = self.statusUpdate
                
                kSharedAppDelegate.dropDown(
                    dataSource: statusName,
                    anchorView: sender
                ) { index, item in
                    let selectedStatus = self.statusUpdate[index]
                    self.statusUpdateTF.text = selectedStatus
                    self.selectedStatusIndex = index
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                    self.scrollView.setContentOffset(.zero, animated: true)
                                }
                }
            }
        
    }
    
    @IBAction func backDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func attachmentDidTapped(_ sender: Any) {
        guard let data = ticketDetails else { return }
        if let file = data.file?.lowercased(),
           file.hasSuffix(".pdf") {
            openPDF(urlString: data.file ?? "")
        } else {
            attachmnetImageView.enableFullscreenZoom()
        }
    }
    
    @IBAction func updateStatusDidTapped(_ sender: Any) {
        guard let selectedStatusIndex = self.selectedStatusIndex,  selectedStatusIndex != -1 else {
            CommonUtils.showToast(message: "Please select status".localiz())
            return
        }
        viewModel.updateStatusRequest()
    }
    
    func configData() {
        guard let data = ticketDetails else { return }
        var fullname: String? = ""
        let senderTypeRequest = data.senderType ?? 1
        
        switch senderTypeRequest {
        case 2:
            fullname  = "\(data.senderDetails?.firstName ?? "") \(data.senderDetails?.lastName ?? "")"
        case 4:
            fullname  = data.senderDetails?.fullNameEnglish
        default:
            fullname = data.senderDetails?.fullName
        }
        
        requestedByLbl.text = fullname
        //requestedByLbl.text = data.senderDetails?.fullNameEnglish
        titleLabel.text = data.title ?? ""
        ticketIdLbl.text = data.ticketID ?? ""
        ticketTypeLabel.text = data.ticketTypeDetails?.name ?? ""
        raisedOnLabel.text = convertServerDate(data.createdAt ?? "")
        let status = statusType(status: data.status ?? 0)
        ticketStatusLbl.text = status.text
        ticketStatusLbl.textColor = status.color
        descriptionLabel.text = data.description ?? ""
        if let imageUrlString = data.file,
           let url = URL(string: imageUrlString) {
            attachmnetImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            attachmnetImageView.sd_imageIndicator?.startAnimatingIndicator()
            attachmnetImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "uploadTicket"))
        } else {
            attachmnetImageView.image = UIImage(named: "uploadTicket")
        }
        resolvedOnStackView.isHidden = (data.status != 1)
        resolvedOnDateLabel.text = convertServerDate(data.updatedAt ?? "")
        attachmentStackView.isHidden = (data.file?.isEmpty ?? true)
//        switch ticketType {
//        case .pastList:
//            statusUpdateStackView.isHidden = false
//            updateStatusButtonView.isHidden = false
//        default:
//            statusUpdateStackView.isHidden = false
//            updateStatusButtonView.isHidden = false
//        }
        if let file = data.file?.lowercased(),
           file.hasSuffix(".pdf") {
            attachmnetButton.isUserInteractionEnabled = true
        } else {
            attachmnetButton.isUserInteractionEnabled = false
        }
        attachmnetImageView.enableFullscreenZoom()
    }
    
    func statusType(status: Int) -> (text: String, color: UIColor) {
        let state = TicketStatus(rawValue: status)
        return (state?.text ?? "Unknown", state?.color ?? .gray)
    }
    
    func convertServerDate(_ isoString: String) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"
        if AppLanguageManager.shared.currentLanguage == .ar {
            formatter.locale = Locale(identifier: "ar")
           } else {
               formatter.locale = Locale(identifier: "en_US")
           }
        guard let date = formatter.date(from: isoString) else {
            return isoString
        }
        
        let outputFormatter = DateFormatter()
//        outputFormatter.locale = Locale(identifier: "en_US_POSIX")
        outputFormatter.dateFormat = "dd MMM yy, h:mm a"   // <- Output format
        if AppLanguageManager.shared.currentLanguage == .ar {
            outputFormatter.locale = Locale(identifier: "ar")
           } else {
               outputFormatter.locale = Locale(identifier: "en_US")
           }
        return outputFormatter.string(from: date)
    }
    
    func openPDF(urlString: String) {
        let pdfVC = PDFViewerViewController()
        pdfVC.pdfURLString = urlString
        self.navigationController?.present(pdfVC, animated: true)
    }
}

enum TicketStatus: Int {
    case pending = 0
    case resolved = 1
    
    var text: String {
        switch self {
        case .pending: return "Pending".localiz()
        case .resolved: return "Resolved".localiz()
        }
    }
    
    var color: UIColor {
        switch self {
        case .pending: return UIColor(hexString: "#D72E04")   // red
        case .resolved: return UIColor(hexString: "#0A8A20")  // green
        }
    }
}
