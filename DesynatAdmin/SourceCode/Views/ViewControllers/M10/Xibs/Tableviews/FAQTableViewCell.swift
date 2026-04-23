//
//  FAQTableViewCell.swift
//  DesynatAdmin
//
//  Created by fluper_mac3 on 16/03/26.
//

import UIKit

class FAQTableViewCell: UITableViewCell {

    @IBOutlet weak var titleView: CustomView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var vectorImageView: UIImageView!
    @IBOutlet weak var descriptionView: CustomView!
    @IBOutlet weak var decsriptionLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    var onEditTapped: (() -> Void)?
    var onDeleteTapped: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func editDidTapped(_ sender: Any) {
        onEditTapped?()
    }
    
    @IBAction func binDidTapped(_ sender: Any) {
        onDeleteTapped?()
    }
    
    func configData(data: FAQListDataModel?, index: Int) {
        titleLabel.text = "Q\(index + 1).\(data?.questionEnglish ?? "")"
        decsriptionLabel.text = data?.answerEnglish
    }
    
}
