//
//  SpellCell.swift
//  Harry-Potter-App
//
//  Created by Alibi on 12.04.2018.
//  Copyright © 2018 Alibi. All rights reserved.
//

import UIKit

class SpellCell: UITableViewCell {

    @IBOutlet weak var nameLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func updateUI(spellForCell: Spells, indexPath: Int) {
        
        nameLbl.text = "\(indexPath + 1). \(spellForCell.name!.capitalized)"
    }
    
    
}
