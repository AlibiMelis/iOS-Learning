//
//  MessageCell.swift
//  firebase-sort-data
//
//  Created by Jess Rascal on 06/08/2016.
//  Copyright © 2016 Jess Rascal. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {

    @IBOutlet weak var msgTextLabel: UILabel!
    
    var msg: Message!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(msg: Message) {
        self.msg = msg
        self.msgTextLabel.text = msg.msgText
    }

}
