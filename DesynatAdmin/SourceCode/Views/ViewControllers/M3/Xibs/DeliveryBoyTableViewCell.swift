//
//  DeliveryBoyTableViewCell.swift
//  DesynatAdmin
//
//  Created by fluper on 20/11/25.
//

import UIKit
import SDWebImage

class DeliveryBoyTableViewCell: UITableViewCell {
    
    @IBOutlet weak var editView: UIView!
    @IBOutlet weak var deleteView: UIView!
    @IBOutlet weak var buttonStackView: UIStackView!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var mobileLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var joinedDateLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var deleteButtonOutlet: UIButton!
    @IBOutlet weak var editButtonOutlet: UIButton!
    @IBOutlet weak var statusButtonOutlet: UIButton!
    
    weak var delegate: DeliveryBoyManagementCellDelegate?
    var onStatusToggle: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    @IBAction func editDidTapepd(_ sender: Any) {
        delegate?.didTapEdit(self)
    }
    
    @IBAction func deleteDidTapped(_ sender: Any) {
        delegate?.didTapDelete(self)
    }
    
    @IBAction func activeStatusDidTapped(_ sender: Any) {
        onStatusToggle?()
    }
    
    
    func configData(data: DeliveryBoysList?) {
        usernameLabel.text = data?.fullNameEnglish
        if let imageUrlString = data?.profilePic,
           let url = URL(string: imageUrlString) {
            mainImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            mainImageView.sd_imageIndicator?.startAnimatingIndicator()
            mainImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "userProfile"))
        } else {
            mainImageView.image = UIImage(named: "userProfile")
        }
        let result = convertISOToDMY(data?.createdAt ?? "") ?? ""
        joinedDateLabel.text = "\("Joined on".localiz()) \(result)"
        mobileLabel.text = "\(data?.countryCode ?? "")-\(data?.mobile ?? "")"
        emailLabel.text = data?.email
        if data?.status == "1" {
            statusButtonOutlet.setImage(UIImage(named: "toggleOn"), for: .normal)
        } else {
            statusButtonOutlet.setImage(UIImage(named: "toggleOff"), for: .normal)
        }
    }
    
    private func convertISOToDMY(_ isoString: String) -> String? {
        // ISO8601 parser
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        // Parse to Date
        guard let date = isoFormatter.date(from: isoString) else {
            return nil
        }
        
        // Output formatter
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "dd/MM/yyyy"
        
        return outputFormatter.string(from: date)
    }
    
}

protocol DeliveryBoyManagementCellDelegate: AnyObject {
    func didTapEdit(_ cell: DeliveryBoyTableViewCell)
    func didTapDelete(_ cell: DeliveryBoyTableViewCell)
}
