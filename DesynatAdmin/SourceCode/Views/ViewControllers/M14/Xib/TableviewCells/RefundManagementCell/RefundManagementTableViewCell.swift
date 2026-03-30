//
//  RefundManagementTableViewCell.swift
//  DesynatAdmin
//
//  Created by  shailendra singh on 27/03/26.
//

import UIKit

class RefundManagementTableViewCell: UITableViewCell {

    @IBOutlet weak var forHideView: UIView!
    @IBOutlet weak var viewMoreButton: UIButton!
    var isViewMore: (() -> Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func viewLessAndMoreBtn(_ sender: UIButton) {
        isViewMore?()
    }
    func configure(isExpanded: Bool) {
            forHideView.isHidden = !isExpanded
            let title = isExpanded ? "View Less" : "More info"
            viewMoreButton.setTitle(title, for: .normal)
        }
    
}
