//
//  TableViewCell.swift
//  Flash Chat iOS13
//
//  Created by Shaik Ismail on 07/09/24.
//  Copyright © 2024 Angela Yu. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    @IBOutlet var messageBubble: UIView!
    
    @IBOutlet var label: UILabel!
    
    @IBOutlet var rightAvatar: UIImageView!
    
    @IBOutlet var leftAvatar: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        messageBubble.layer.cornerRadius=messageBubble.frame.size.height/5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
