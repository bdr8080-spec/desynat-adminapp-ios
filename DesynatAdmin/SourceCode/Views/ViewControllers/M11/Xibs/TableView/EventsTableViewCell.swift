//
//  EventsTableViewCell.swift
//  DesynatAdmin
//
//  Created by fluper_mac3 on 20/03/26.
//

import UIKit

class EventsTableViewCell: UITableViewCell {

    var onWatchLiveSelect: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func watchLiveDidTapped(_ sender: Any) {
        onWatchLiveSelect?()
    }
}
