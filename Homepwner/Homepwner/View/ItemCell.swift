//
//  ItemCell.swift
//  Homepwner
//
//  Created by Alibi on 4/1/20.
//  Copyright © 2020 Alibi. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var serialNumberLabel: UILabel!
    @IBOutlet var valueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        nameLabel.adjustsFontForContentSizeCategory = true
        serialNumberLabel.adjustsFontForContentSizeCategory = true
        valueLabel.adjustsFontForContentSizeCategory = true
    }
    
    func updateColorOfValue(value: Int) {
        
        if value < 50 {
            self.valueLabel.textColor = .green
        } else {
            self.valueLabel.textColor = .red
        }
    }
}
